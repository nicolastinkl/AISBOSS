//
//  AAGesturesParser.swift
//  AIVeris
//
//  Created by admin on 5/11/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AAGesturesParser: NSObject {
	
	static let sharedInstance = AAGesturesParser()
	
	func parseHitTest(view view: UIView, location: CGPoint, event: UIEvent?) {
		let isAccessable = view.accessibilityIdentifier != nil
		let anchor = AIAnchor()
		anchor.viewQuery = view.accessibilityIdentifier
		anchor.send()
	}
}

extension AAGesturesParser: UIGestureRecognizerDelegate {
	
}

extension UITapGestureRecognizer {
	
	private struct AssociatedKeys {
		static var Target = "target"
		static var Action = "action"
		static var Location = "location"
	}
	
	var locationInSelfView: CGPoint? {
		get {
			if let string = objc_getAssociatedObject(self, &AssociatedKeys.Location) as? String {
				return CGPointFromString(string)
			} else {
				return nil
			}
		}
		set {
			if let newValue = newValue {
				objc_setAssociatedObject(
					self,
					&AssociatedKeys.Location,
					NSStringFromCGPoint(newValue),
					objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
				)
			} else {
				objc_setAssociatedObject(
					self,
					&AssociatedKeys.Location,
					nil,
					objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
				)
			}
		}
	}
	
	var target: AnyObject? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.Target)
		}
		set {
			if let newValue = newValue {
				objc_setAssociatedObject(
					self,
					&AssociatedKeys.Target,
					newValue,
					objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
				)
			}
		}
	}
	
	var action: Selector? {
		get {
			if let string = objc_getAssociatedObject(self, &AssociatedKeys.Action) as? String {
				return Selector(stringLiteral: string)
			} else {
				return objc_getAssociatedObject(self, &AssociatedKeys.Action) as? Selector
			}
		}
		set {
			if let newValue = newValue {
				objc_setAssociatedObject(
					self,
					&AssociatedKeys.Action,
					NSStringFromSelector(newValue),
					objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
				)
			}
		}
	}
	
	func performTap(atPoint point: CGPoint) {
		locationInSelfView = point
		(target as! NSObject).performSelector(action!, withObject: self)
		locationInSelfView = nil
	}
	
	func ai_locationInView(view: UIView?) -> CGPoint {
		if let location = locationInSelfView {
			locationInSelfView = nil
			if let view = view {
				return view.convertPoint(location, toView: view)
			} else {
				return location
			}
		} else {
			return ai_locationInView(view)
		}
	}
	
	func ai_init(target target: AnyObject?, action: Selector) -> Self {
		let result = ai_init(target: target, action: action)
		result.target = target
		result.action = action
		return result
	}
	
	public override class func initialize() {
		struct Static {
			static var token: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.token) {
			let originalSelector = #selector(UITapGestureRecognizer.init(target: action:))
			let swizzledSelector = #selector(UITapGestureRecognizer.ai_init(target: action:))
			Swizzle(self, originalSelector, swizzledSelector)
			Swizzle(self, #selector(UITapGestureRecognizer.locationInView(_:)), #selector(UITapGestureRecognizer.ai_locationInView(_:)))
		}
	}
	
}

extension NSObject {
	static func Swizzle(cls: AnyClass, _ origSEL: Selector, _ newSEL: Selector) {
		let originalMethod = class_getInstanceMethod(cls, origSEL)
		let swizzledMethod = class_getInstanceMethod(cls, newSEL)
		
		if originalMethod == nil {
			return
		}
		if swizzledMethod == nil {
			return;
		}
		
		let didAddedMethod = class_addMethod(cls, origSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
		if didAddedMethod {
			class_replaceMethod(cls, newSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
		} else {
			method_exchangeImplementations(originalMethod, swizzledMethod)
		}
	}
}