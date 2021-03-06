//
//  AudioAssistantManager.swift
//  AIVeris
//
//  Created by admin on 5/10/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

struct AudioAssistantString {
	// 挂断电话
	static let HangUp = "HangUp"
	// 已经接起电话
	static let PickedUp = "PickedUp"
}

class AudioAssistantMessage: NSObject {
	var type: AudioAssistantMessageType
	var content: String
	
	init(type: AudioAssistantMessageType, content: String) {
		self.type = type
		self.content = content
		super.init()
	}
}

enum AudioAssistantMessageType: String {
	/// 普通消息
	case NormalMessage = "NormalMessage"
	/// 锚点
	case Anchor = "Anchor"
	/// 命令
	case Command = "Command"
}

enum AudioAssistantManagerConnectionStatus: Int {
	
	/**  The Manager is not connected. */
	case NotConnected
	/** The Manager is dialing. */
	case Dialing
	/** The Manager is connected. */
	case Connected
	/** The Manager is error. */
	case Error
}

class AudioAssistantManager: NSObject {
	
	static let sharedInstance = AudioAssistantManager()
	static let fakeRoomNumber = "89897384"
    var connectionId: String? {
       return _session?.connection?.connectionId
    }
	
	private var _session: OTSession?
	private var _publisher: OTPublisherKit?
	private var _subscriber: OTSubscriber?
	private var _roomNumber: String?
	private var _otherConnection: OTConnection?
	private var _sessionDidConnectHandler: (() -> ())?
	private var _didFailHandler: ((OTError) -> ())?
	
	var mute: Bool = false {
		didSet {
			_publisher?.publishAudio = mute
		}
	}
	
	var connectionStatus = AudioAssistantManagerConnectionStatus.NotConnected {
		didSet {
			if connectionStatus != oldValue {
				NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIRemoteAssistantConnectionStatusChangeNotificationName, object: nil)
			}
		}
	}
	
	var type: CallType = .Customer
	
	/// 拨打者 还是 接收者
	enum CallType: Int {
		case Customer, Provider
	}
	
	/// 打电话
	func customerCallRoom(roomNumber roomNumber: String, sessionDidConnectHandler: (() -> ())? = nil, didFailHandler: ((OTError) -> ())? = nil) {
		type = .Customer
		connectionToAudioAssiastantRoom(roomNumber: roomNumber, sessionDidConnectHandler: sessionDidConnectHandler, didFailHandler: didFailHandler)
	}
	
	/// 接电话
	func providerAnswerRoom(roomNumber roomNumber: String, sessionDidConnectHandler: (() -> ())? = nil, didFailHandler: ((OTError) -> ())? = nil) {
		type = .Provider
		connectionToAudioAssiastantRoom(roomNumber: roomNumber, sessionDidConnectHandler: sessionDidConnectHandler, didFailHandler: didFailHandler)
	}
	
	/**
	 customer挂断房间
	 */
	func customerHangUpRoom() {
		if connectionStatus == .Connected {
			sendCommand((AudioAssistantString.HangUp))
		}
		disconnectFromToAudioAssiastantRoom()
	}
	
	/**
	 provider挂断房间

	 - parameter silence: 静音 Default is false , true 就不发挂断消息
	 */
	func providerHangUpRoom(roomNumber roomNumber: String?, silence: Bool = false) {
		let rNumber = roomNumber ?? _roomNumber ?? ""
		
		if connectionStatus == .NotConnected {
			connectionToAudioAssiastantRoom(roomNumber: rNumber, sessionDidConnectHandler: { [weak self] in
				self?.disconnectFromToAudioAssiastantRoom()
			})
		} else {
			if silence == false {
				sendCommand((AudioAssistantString.HangUp))
			}
			disconnectFromToAudioAssiastantRoom()
		}
	}
	
	/// 发布屏幕
	func doPublishScreen() {
		print(#function + " called")
		_publisher = OTPublisherKit(delegate: self, name: UIDevice.currentDevice().name, audioTrack: true, videoTrack: true)
		_publisher?.videoType = .Screen
		_publisher?.audioFallbackEnabled = false
		
		let videoCapture = TBScreenCapture(view: UIApplication.sharedApplication().keyWindow)
		_publisher?.videoCapture = videoCapture
		
		_session?.publish(_publisher, error: nil)
	}
	
	/// 发布音频
	func doPublishAudio() {
		_publisher = OTPublisherKit(delegate: self, name: UIDevice.currentDevice().name, audioTrack: true, videoTrack: false)
		
		_session?.publish(_publisher, error: nil)
	}
	
	/// 订阅流
	func doSubscribe(stream: OTStream) {
		_subscriber = OTSubscriber(stream: stream, delegate: self)
		_session?.subscribe(_subscriber, error: nil)
	}
	
	/// 发送普通消息
	func sendNormalMessage(message: String) {
		sendString(message, type: .NormalMessage)
	}
	
	/// 发送命令
	func sendCommand(command: String) {
		sendString(command, type: .Command)
	}
	
	/**
	 发送字符串

	 - parameter string: 使用 AudioAssistantMessage
	 - parameter type:   字符串类型
	 */
	func sendString(string: String, type: AudioAssistantMessageType) {
		_session?.signalWithType(type.rawValue, string: string, connection: nil, error: nil)
	}
	
	func sendAnchor(anchor: AIAnchor) {
        anchor.connectionId = connectionId
		let string = anchor.toJSONString()
		sendString(string, type: .Anchor)
	}
	
	private func connectionToAudioAssiastantRoom(roomNumber roomNumber: String, sessionDidConnectHandler: (() -> ())? = nil, didFailHandler: ((OTError) -> ())? = nil) {
		connectionStatus = .NotConnected
		_roomNumber = roomNumber
		_didFailHandler = didFailHandler
		_sessionDidConnectHandler = sessionDidConnectHandler
		let roomURLString = String(format: "http://104.18.58.238/%@.json", roomNumber)
		print(String("https://opentokrtc.com/%@.json", roomNumber))
		let roomURL = NSURL(string: roomURLString)!
		let request = NSMutableURLRequest(URL: roomURL, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
		request.HTTPMethod = "GET"
		request.addValue("opentokrtc.com", forHTTPHeaderField: "Host")
		
		NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { [unowned self](response, data, error) in
			if error != nil {
				print("Error, \(error?.localizedDescription), \(roomURLString)")
				self.connectionToAudioAssiastantRoom(roomNumber: roomNumber, sessionDidConnectHandler: sessionDidConnectHandler)
			} else {
				if let roomInfo = try?NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary {
					if let roomInfo = roomInfo {
						let apiKey = roomInfo["apiKey"] as! String
						let token = roomInfo["token"] as! String
						let sessionId = roomInfo["sid"] as! String
						self._session = OTSession(apiKey: apiKey, sessionId: sessionId, delegate: self)
						self._session?.connectWithToken(token, error: nil)
					}
				}
			}
		}
	}
	
	func disconnectFromToAudioAssiastantRoom() {
		connectionStatus = .NotConnected
		_roomNumber = nil
		_otherConnection = nil
		_publisher = nil
		_session?.unpublish(_publisher, error: nil)
		_session?.disconnect(nil)
		NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIRemoteAssistantConnectionStatusChangeNotificationName, object: AudioAssistantString.HangUp)
	}
}

extension AudioAssistantManager: OTSessionDelegate {
	
	/** @name Connecting to a session */
	
	/**
	 * Sent when the client connects to the session.
	 *
	 * @param session The <OTSession> instance that sent this message.
	 */
	func sessionDidConnect(session: OTSession!) {
		if let sessionDidConnectHandler = _sessionDidConnectHandler {
			_sessionDidConnectHandler = nil
			sessionDidConnectHandler()
		}
		print(#function + " called")
	}
	
	/**
	 * Sent when the client disconnects from the session.
	 *
	 * @param session The <OTSession> instance that sent this message.
	 */
	func sessionDidDisconnect(session: OTSession!) {
		print(#function + " called")
		if let roomNumber = _roomNumber {
			connectionToAudioAssiastantRoom(roomNumber: roomNumber, sessionDidConnectHandler: _sessionDidConnectHandler)
		}
	}
	
	/**
	 * Sent if the session fails to connect, some time after your application
	 * invokes [OTSession connectWithToken:].
	 *
	 * @param session The <OTSession> instance that sent this message.
	 * @param error An <OTError> object describing the issue. The
	 * `OTSessionErrorCode` enum
	 * (defined in the OTError.h file) defines values for the `code` property of
	 * this object.
	 */
	func session(session: OTSession!, didFailWithError error: OTError!) {
		if let didFailHandler = _didFailHandler {
			_didFailHandler = nil
			didFailHandler(error)
		}
		print(#function + " called")
		print(error?.localizedDescription)
		connectionStatus = .Error
	}
	
	/** @name Monitoring streams in a session */
	
	/**
	 * Sent when a new stream is created in this session.
	 *
	 * Note that if your application publishes to this session, your own session
	 * delegate will not receive the [OTSessionDelegate session:streamCreated:]
	 * message for its own published stream. For that event, see the delegate
	 * callback [OTPublisherKit publisher:streamCreated:].
	 *
	 * @param session The OTSession instance that sent this message.
	 * @param stream The stream associated with this event.
	 */
	func session(session: OTSession!, streamCreated stream: OTStream!) {
		print(#function + " called")
		if _subscriber == nil {
			doSubscribe(stream)
		}
	}
	
	/**
	 * Sent when a stream is no longer published to the session.
	 *
	 * @param session The <OTSession> instance that sent this message.
	 * @param stream The stream associated with this event.
	 */
	func session(session: OTSession!, streamDestroyed stream: OTStream!) {
		print(#function + " called")
		_subscriber?.view.removeFromSuperview()
		_subscriber = nil
	}
//
//    @optional
//
	
	/**
	 * Sent when another client connects to the session. The `connection` object
	 * represents the client's connection.
	 *
	 * This message is not sent when your own client connects to the session.
	 * Instead, the <[OTSessionDelegate sessionDidConnect:]>
	 * message is sent when your own client connects to the session.
	 *
	 * @param session The <OTSession> instance that sent this message.
	 * @param connection The new <OTConnection> object.
	 */
	func session(session: OTSession!, connectionCreated connection: OTConnection!) {
		if connection != _session?.connection {
			if _otherConnection != nil {
				sendCommand(AudioAssistantString.HangUp)
			}
		}
	}
	
	func session(session: OTSession!, receivedSignalType type: String!, fromConnection connection: OTConnection!, withString string: String!) {
		if connection != _session?.connection {
			_otherConnection = connection
			AADataReceiverParser.sharedInstance.parseString(string, type: type)
		}
	}
}

extension AudioAssistantManager: OTPublisherKitDelegate {
	func publisher(publisher: OTPublisherKit!, didFailWithError error: OTError!) {
		print(#function + " called")
		print(error.localizedDescription)
	}
}

extension AudioAssistantManager: OTSubscriberKitDelegate {
	func subscriberDidConnectToStream(subscriber: OTSubscriberKit!) {
	}
	
	func subscriber(subscriber: OTSubscriberKit!, didFailWithError error: OTError!) {
		
	}
}
