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
		
		let stringType = AudioAssistantStringType(rawValue: type)
		
		if let stringType = stringType {
			switch stringType {
			case .Message:
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
            AudioAssistantManager.sharedInstance.receiverHangUpRoom(silence: true)
        default:
            break
        }
	}
	
	func parseMessage(message: String) {
		// notify ui with message
	}
	
}
