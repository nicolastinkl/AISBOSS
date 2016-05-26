//
//  AACustomWindow.swift
//  AIVeris
//
//  Created by admin on 5/16/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AACustomWindow: UIWindow {
	override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
		let view = super.hitTest(point, withEvent: event)
		let isConnected = AudioAssistantManager.sharedInstance.connectionStatus == .Connected
		if let view = view {
//			if isConnected {
//				AAGesturesParser.sharedInstance.parseHitTest(view: view, location: point, event: event)
//			}
		}
		return view
	}
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
}
