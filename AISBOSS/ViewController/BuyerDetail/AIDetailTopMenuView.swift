//
//  AIDetailTopMenuView.swift
//  AIVeris
//
//  Created by tinkl on 23/11/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

internal class AIDetailTopMenuView : UIView {
    
    class func currentView()->AIDetailTopMenuView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AIDetailTopMenuView", owner: self, options: nil).first  as! AIDetailTopMenuView
        return selfView
    }
    
}