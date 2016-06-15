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
    var isNowExcutingAnchor = false
    
    private var anchors: [AIAnchor] = [AIAnchor]()
    var topViewController: AITopViewController = AITopViewController()
    
    func handleAnchor(anchor: AIAnchor) {
        excuteAnchor(anchor)
    }
    
    func excuteAnchor(anchor: AIAnchor) {
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