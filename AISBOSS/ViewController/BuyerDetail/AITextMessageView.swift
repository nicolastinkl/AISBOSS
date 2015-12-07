//
//  AITextMessageView.swift
//  AIVeris
//
//  Created by tinkl on 23/11/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation



class AITextMessageView: UIView {
    
    @IBOutlet weak var content: UILabel!
    
    weak var delegate:AIDeleteActionDelegate?
    
    class func currentView()->AITextMessageView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AITextMessageView", owner: self, options: nil).first  as! AITextMessageView
        selfView.content.font = AITools.myriadLightSemiCondensedWithSize(36/2.5)
        
        let longPressGes = UILongPressGestureRecognizer(target: selfView, action: "handleLongPress:")
        longPressGes.minimumPressDuration = 0.3
        selfView.addGestureRecognizer(longPressGes)
        
        return selfView
    }
    
    func handleLongPress(longPressRecognizer:UILongPressGestureRecognizer){
        
        if (longPressRecognizer.state != UIGestureRecognizerState.Began) {
            return;
        }
        
        if (becomeFirstResponder() == false) {
            return;
        }
        
        let meunController = UIMenuController()
        meunController.setTargetRect(self.bounds, inView: self)
        
        let item = UIMenuItem(title: "Delete", action: "sendDeleteMenuItemPressed:")
        meunController.menuItems = [item]
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuWillShow:", name: UIMenuControllerWillShowMenuNotification, object: nil)
        meunController.setMenuVisible(true, animated: true)
        
    }
    
    func menuWillShow(notification:NSNotification){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIMenuControllerWillShowMenuNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuWillHide:", name: UIMenuControllerWillHideMenuNotification, object: nil)
    }
    
    func menuWillHide(notification:NSNotification){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIMenuControllerWillHideMenuNotification, object: nil)
    }
    
    func sendDeleteMenuItemPressed(menuController: UIMenuController){
        self.resignFirstResponder()
        delegate?.deleteAction(self)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.resignFirstResponder() == false {
            return
        }
        
        let menu =  UIMenuController.sharedMenuController()
        menu.setMenuVisible(false, animated: true)
        menu.update()
        self.resignFirstResponder()
        
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func becomeFirstResponder()->Bool{
        return super.becomeFirstResponder()
    }
    
    
}