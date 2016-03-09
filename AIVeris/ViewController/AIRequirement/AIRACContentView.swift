//
//  AIRACContentCell.swift
//  AIVeris
//
//  Created by tinkl on 3/8/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIRACContentView: UIView {
    
    @IBOutlet weak var tiitleLabel: UILabel!
    class func currentView()->AIRACContentView{
        
        let selfview =  NSBundle.mainBundle().loadNibNamed("AIRACContentView", owner: self, options: nil).first  as! AIRACContentView
        
        return selfview
    }
    
}

