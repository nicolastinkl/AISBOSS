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
		print(#function + " called")
		// todo parse string
		if type == "tap" {
			let location = CGPointFromString(string)
			print(location)
			let window = UIApplication.sharedApplication().keyWindow!
			let view = window.hitTest(location, withEvent: nil)
			print(view)
			if let control = view as? UIControl {
				control.sendActionsForControlEvents(.TouchUpInside)
			} else if let tap = view?.gestureRecognizers?.first as? UITapGestureRecognizer {
				handleGesture(tap, location: location)
			}
		}
	}
}

private func handleGesture(gesture: UITapGestureRecognizer, location: CGPoint) {
    gesture.performTap(atPoint: location)
}
