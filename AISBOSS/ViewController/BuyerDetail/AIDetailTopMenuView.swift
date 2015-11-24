//
//  AIDetailTopMenuView.swift
//  AIVeris
//
//  Created by tinkl on 23/11/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

internal class AIDetailTopMenuView : UIView {
    @IBOutlet weak var like: UILabel!
    
    @IBOutlet weak var share: UILabel!
    @IBOutlet weak var custom: UILabel!
    class func currentView()->AIDetailTopMenuView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AIDetailTopMenuView", owner: self, options: nil).first  as! AIDetailTopMenuView
        return selfView
    }
    
}