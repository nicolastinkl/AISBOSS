//
//  AudioAssistantManager.swift
//  AIVeris
//
//  Created by admin on 5/10/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

struct AudioAssistantString {
	static let HangUp = "HangUp"
}

enum AudioAssistantStringType: String {
	/// 普通消息
	case Message
	/// 锚点
	case Anchor
	/// 命令
	case Command
}

class AudioAssistantManager: NSObject {
	static let sharedInstance = AudioAssistantManager()
	
	var _session: OTSession?
	var _publisher: OTPublisherKit?
	var _subscriber: OTSubscriber?
	
	/// 判断是否连接上了房间
	var isConnected: Bool {
		return _session?.connection != nil
	}
	
	private var _roomNumber: String?
	private var _otherConnection: OTConnection?
	private var _sessionDidConnectHandler: (() -> ())?
	
	var type: CallType = .Caller
	
	/// 拨打者 还是 接收者
	enum CallType: Int {
		case Caller, Receiver
	}
	
	/// 打电话
	func callRoom(roomNumber roomNumber: String, sessionDidConnectHandler: (() -> ())? = nil) {
		type = .Caller
		connectionToAudioAssiastantRoom(roomNumber: roomNumber, sessionDidConnectHandler: sessionDidConnectHandler)
	}
	
	/// 接电话
	func answerRoom(roomNumber roomNumber: String, sessionDidConnectHandler: (() -> ())? = nil) {
		type = .Receiver
		connectionToAudioAssiastantRoom(roomNumber: roomNumber, sessionDidConnectHandler: sessionDidConnectHandler)
	}
	
	/**
	 拨打者挂断房间

	 - parameter silence: 静音 Default is false , true 就不发挂断消息
	 */
	func calllerHangUpRoom(silence silence: Bool = false) {
		if !silence {
			sendString((AudioAssistantString.HangUp), type: .Message)
		}
		disconnectFromToAudioAssiastantRoom()
	}
	
	/**
	 接收者挂断房间

	 - parameter silence: 静音 Default is false , true 就不发挂断消息
	 */
	func receiverHangUpRoom(silence silence: Bool = false) {
		sendString((AudioAssistantString.HangUp), type: .Message)
		disconnectFromToAudioAssiastantRoom()
	}
	
	func hangUpFromRoom(roomNumber roomNumber: String) {
		connectionToAudioAssiastantRoom(roomNumber: roomNumber) { [weak self] in
			self?.sendString(AudioAssistantString.HangUp, type: .Message)
			self?.disconnectFromToAudioAssiastantRoom()
		}
	}
	
	/// 发布屏幕流
	func doPublish() {
		print(#function + " called")
		_publisher = OTPublisherKit(delegate: self, name: UIDevice.currentDevice().name, audioTrack: true, videoTrack: true)
		_publisher?.videoType = .Screen
		_publisher?.audioFallbackEnabled = false
		
		let videoCapture = TBScreenCapture(view: UIApplication.sharedApplication().keyWindow)
		_publisher?.videoCapture = videoCapture
		
		_session?.publish(_publisher, error: nil)
	}
	
	/// 订阅视频流
	func doSubscribe(stream: OTStream) {
		_subscriber = OTSubscriber(stream: stream, delegate: self)
		_session?.subscribe(_subscriber, error: nil)
	}
	
	/// 发送普通消息
	func sendMessage(message: String) {
		sendString(message, type: .Message)
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
	func sendString(string: String, type: AudioAssistantStringType) {
		_session?.signalWithType(type.rawValue, string: string, connection: nil, error: nil)
	}
	
	func sendAnchor(anchor: AIAnchor) {
		let string = JSONSerializer.toJson(anchor)
		sendString(string, type: .Anchor)
	}
	
	private func connectionToAudioAssiastantRoom(roomNumber roomNumber: String, sessionDidConnectHandler: (() -> ())? = nil) {
		_roomNumber = roomNumber
		_sessionDidConnectHandler = sessionDidConnectHandler
		let roomURLString = String(format: "http://104.18.58.238/%@.json", roomNumber)
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
	
	private func disconnectFromToAudioAssiastantRoom() {
		_session?.disconnect(nil)
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
		print(#function + " called")
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
//
//
//    - (void)    session:(OTSession*) session
//    connectionDestroyed:(OTConnection*) connection;
//
//
//    - (void)   session:(OTSession*)session
//    receivedSignalType:(NSString*)type
//    fromConnection:(OTConnection*)connection
//    withString:(NSString*)string;
	
	func session(session: OTSession!, receivedSignalType type: String!, fromConnection connection: OTConnection!, withString string: String!) {
		if connection != _session?.connection {
			_otherConnection = connection
			AADataReceiverParser.sharedInstance.parseString(string, type: type)
		}
	}
//
//
//    - (void)     session:(OTSession*)session
//    archiveStartedWithId:(NSString*)archiveId
//    name:(NSString*)name;
//
//
//    - (void)     session:(OTSession*)session
//    archiveStoppedWithId:(NSString*)archiveId;
//
//
//    - (void)sessionDidBeginReconnecting:(OTSession*)session;
	
//    - (void)sessionDidReconnect:(OTSession*)session;
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
