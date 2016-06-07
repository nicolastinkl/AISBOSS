//
//  AIAnchorManager.swift
//  AIVeris
//
//  Created by 王坜 on 16/5/16.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

struct AITopViewController {
    
    var controller: AnchorProcess?
    var className: String?
}

class AIAnchorManager: NSObject {

    //MARK: Public Properties
    static let defaultManager = AIAnchorManager()
    var excutingAnchor: AIAnchor?
    var queue: NSOperationQueue = {
        let result = NSOperationQueue()
        result.maxConcurrentOperationCount = 1
        return result
    }()
    
    override init() {
        super.init()
        setup()
    }
    
    func setup() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIAnchorManager.handleNotification(_:)), name: AIApplication.Notification.AIRemoteAssistantAnchorOperationCompletedNotificationName, object: nil)
    }
    
    func handleNotification(notification: NSNotification) {
        if let excutingAnchorOperation = queue.operations.first as? AIAnchorOperation {
           let anchor = excutingAnchorOperation.anchor
            excuteAnchor(anchor)
        } else {
            excutingAnchor = nil
        }
    }
    
    //MARK: private Properties
    private var anchors: [AIAnchor] = [AIAnchor]()
    var topViewController: AITopViewController = AITopViewController()
    
    func handleAnchor(anchor: AIAnchor) {
        queue.addOperation(AIAnchorOperation(anchor: anchor))
        excuteAnchor(anchor)
    }
    
    func excuteAnchor(anchor: AIAnchor) {
        excutingAnchor = anchor
        if anchor.className == topViewController.className {
            topViewController.controller?.processAnchor(anchor)
        }
    }
    
    
    func setTopViewController(vc: UIViewController) {
       
    }
}

extension Array {
	public mutating func popFirst() -> Element? {
		let result = first
        if result != nil {
            removeAtIndex(0)
        }
		return result
	}
}