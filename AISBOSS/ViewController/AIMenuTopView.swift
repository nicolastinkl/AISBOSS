//
//  AIMenuTopView.swift
//  AITrans
//
//  Created by 刘先 on 15/6/29.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

import Foundation
import AISpring


protocol topActionDelegate{
    func captureAction()
    func txtAction()
    func audioAction()
    func linkAction()
}

class AIMenuTopView: UIView {
    var delegate:topActionDelegate?
    @IBAction func captureAction(sender: AnyObject) {
        delegate?.captureAction()
    }
    @IBAction func audioAction(sender: AnyObject) {
        delegate?.audioAction()
    }
    @IBAction func txtAction(sender: AnyObject) {
        delegate?.txtAction()
    }
    @IBAction func linkAction(sender: AnyObject) {
        delegate?.linkAction()
    }
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let cSelector : Selector = "closeMenuAction:"
        let swipeGuesture = UISwipeGestureRecognizer(target: self, action: cSelector)
        swipeGuesture.direction = UISwipeGestureRecognizerDirection.Up
        self.addGestureRecognizer(swipeGuesture)
    }


    func closeMenuAction(sender: UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizerDirection.Up {
            spring(0.5, animations: {
                //TODO: 以后要加height变化
                //self.setTop(-self.height)
                self.alpha = 0
            })
        }
        
    }
    
    

    class func currentView() ->AIMenuTopView {
        let view = NSBundle.mainBundle().loadNibNamed("AIMenuTopView", owner: self, options: nil).last as! AIMenuTopView
        
        return view
    }
}