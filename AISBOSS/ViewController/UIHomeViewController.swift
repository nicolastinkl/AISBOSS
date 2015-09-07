//
//  UIHomeViewController.swift
//  AITrans
//
//  Created by admin on 7/13/15.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//

import Foundation
import UIKit
import AISpring

class UIHomeViewController: UIViewController,GBSlideOutToUnlockViewDelegate {
    @IBOutlet weak var unlockView: GBSlideOutToUnlockView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        unlockView.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        unlockView.layoutSubviews()
        unlockView.fixCenter()
        
        spring(0.3, animations: { () -> Void in
            self.unlockView.hidden = false
        })
    }
    
    // MARK: Delegate 
    
    func slideOutToUnlockViewDidStartToDrag(slideOutToUnlockView: GBSlideOutToUnlockView!) {
        //Started
    }
    
    func slideOutToUnlockView(slideOutView: GBSlideOutToUnlockView!, didDragDistance distance: CGFloat) {
        
    }
    
    func slideOutToUnlockViewDidEndToDrag(slideOutToUnlockView: GBSlideOutToUnlockView!) {
        
    }
    
    func slideOutToUnlockViewDidUnlock(slideOutToUnlockView: GBSlideOutToUnlockView!) {
        //Unlocked
        
        let point =  slideOutToUnlockView.frame.origin
        
        //let center = self.view.center
        
        if point.x > 0  && point.y > 0 {
            
        }
        
        showViewController(UIStoryboard(name: "UIMainStoryboard", bundle: nil).instantiateInitialViewController()!, sender: self)
//        showViewController(UIStoryboard(name: "UICustomerStoryboard", bundle: nil).instantiateInitialViewController() as UIViewController, sender: self)
    }
    
    
}