//
//  AITextMessageView.swift
//  AIVeris
//
//  Created by tinkl on 23/11/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AITextMessageView: UIView {
    
    
    class func currentView()->AITextMessageView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AITextMessageView", owner: self, options: nil).first  as! AITextMessageView
        return selfView
    }
    
}