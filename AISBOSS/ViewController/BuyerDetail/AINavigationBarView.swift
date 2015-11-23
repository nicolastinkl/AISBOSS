//
//  AINavigationBarView.swift
//  AIVeris
//
//  Created by tinkl on 23/11/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Cartography

internal class AINavigationBarView : UIView{
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var custView: UIView!
    
    @IBAction func backAction(sender: AnyObject) {
    
    }
    
    class func currentView()->AINavigationBarView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AINavigationBarView", owner: self, options: nil).first  as! AINavigationBarView
        let customView = AIDetailTopMenuView.currentView()
        selfView.custView.addSubview(customView)
        layout(customView) { (view1) -> () in
            view1.left == view1.superview!.left
            view1.right == view1.superview!.right
            view1.top == view1.superview!.top
            view1.bottom == view1.superview!.bottom
        }
        
        return selfView
    }
    
    
}