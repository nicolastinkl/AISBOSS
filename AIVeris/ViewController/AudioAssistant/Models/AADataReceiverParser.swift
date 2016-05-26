//
//  AADataReceiverParser.swift
//  AIVeris
//
//  Created by admin on 5/11/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit
import ObjectiveC

class AADataReceiverParser: NSObject {
	static let sharedInstance = AADataReceiverParser()
	
	func parseString(string: String, type: String) {
		
		let stringType = AudioAssistantMessageType(rawValue: type)
		
		if let stringType = stringType {
			switch stringType {
			case .NormalMessage:
				parseMessage(string)
			case .Command:
				parseCommand(string)
			case .Anchor:
				parseAnchorString(string)
			}
		}
	}
	
	func parseAnchorString(anchorString: String) {
		let anchor = AIAnchor.anchorFromJsonString(anchorString)
		print(anchor.viewQuery)
		let window = UIApplication.sharedApplication().keyWindow
		if let viewQuery = anchor.viewQuery {
		}
	}
	
	func parseCommand(command: String) {
		switch command {
		case AudioAssistantString.HangUp:
			let command = AudioAssistantMessage(type: .Command, content: command)
			NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIRemoteAssistantManagerMessageReceivedNotificaitonName, object: command)
		default:
			break
		}
	}
	
	func parseMessage(message: String) {
		switch message {
		case AudioAssistantString.HangUp:
			AudioAssistantManager.sharedInstance.connectionStatus = .NotConnected
		case AudioAssistantString.PickedUp:
			AudioAssistantManager.sharedInstance.connectionStatus = .Connected
		default:
			break
		}
	}
	
}
