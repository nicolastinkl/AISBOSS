//
//  AudioAssistantManager.swift
//  AIVeris
//
//  Created by admin on 5/10/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

class AudioAssistantManager: NSObject {
	static let sharedInstance = AudioAssistantManager()
	
	var _session: OTSession?
	var _publisher: OTPublisherKit?
	var _subscriber: OTSubscriber?
    private var _roomNumber: String?
    private var _sessionDidConnectHandler: (()->())?
	
    func connectionToAudioAssiastantRoom(roomNumber roomNumber: String, sessionDidConnectHandler: (()->())? = nil) {
        _roomNumber = roomNumber
        _sessionDidConnectHandler = sessionDidConnectHandler
        
		let roomURLString = String(format: "https://opentokrtc.com/%@.json", roomNumber)
		let roomURL = NSURL(string: roomURLString)!
		let request = NSMutableURLRequest(URL: roomURL, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
		request.HTTPMethod = "GET"
		
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
	
	func sendString(string: String, type: String) {
		_session?.signalWithType(type, string: string, connection: nil, error: nil)
	}
    
    func sendAnchor(anchor: AIAnchor) {
        let string = JSONSerializer.toJson(anchor)
        _session?.signalWithType("AIAnchor", string: string, connection: nil, error: nil)
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
//
//    - (void)  session:(OTSession*) session
//    connectionCreated:(OTConnection*) connection;
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
//        doPublish()
	}
}

extension AudioAssistantManager: OTSubscriberKitDelegate {
	func subscriberDidConnectToStream(subscriber: OTSubscriberKit!) {
		assert(_subscriber == subscriber)
		if let view = _subscriber?.view {
			view.frame = (UIApplication.sharedApplication().keyWindow?.bounds)!
			UIApplication.sharedApplication().keyWindow?.addSubview(view)
			
			let gesturesParser = AAGesturesParser.sharedInstance
			
			let tap = UITapGestureRecognizer(target: gesturesParser, action: "handleTapGesture:")
			tap.delegate = gesturesParser
			view.addGestureRecognizer(tap)
			
			let pan = UIPanGestureRecognizer(target: gesturesParser, action: "handlePanGesture:")
			pan.delegate = gesturesParser
			view.addGestureRecognizer(pan)
			
			pan.requireGestureRecognizerToFail(tap)
			
		}
	}
	
	func subscriber(subscriber: OTSubscriberKit!, didFailWithError error: OTError!) {
		
	}
}
