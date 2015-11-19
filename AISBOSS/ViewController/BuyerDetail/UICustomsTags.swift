//
//  UICustomsTags.swift
//  AIVeris
//
//  Created by tinkl on 19/11/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import AISpring

internal class UICustomsTags : SpringView {
    
    // MARK: variables
    @IBOutlet weak var content: DesignableLabel!
    @IBOutlet weak var unReadNumber: DesignableLabel!
    
    // MARK: currentView
    class func currentView()->UICustomsTags{
        let selfView = NSBundle.mainBundle().loadNibNamed("UICustomsTags", owner: self, options: nil).first  as! UICustomsTags
        return selfView
    }
    
}