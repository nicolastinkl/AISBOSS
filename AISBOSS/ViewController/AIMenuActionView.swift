//
//  AIMenuActionView.swift
//  AITrans
//
//  Created by admin on 7/1/15.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//

import Foundation
import AISpring

class AIMenuActionView: SpringView {
    
    var delegate: ActionCellDelegate?

    @IBOutlet weak var btnExpend: UIButton!
    @IBOutlet weak var btnBrowse: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnFavirote: UIButton!
    
    class func currentView()->AIMenuActionView{
        var selfView = NSBundle.mainBundle().loadNibNamed("AIMenuActionView", owner: self, options: nil).first  as AIMenuActionView
        return selfView
    }
    
    @IBAction func buttonClick(sender: AnyObject) {
        
        if delegate != nil {
            var type = ActionType.Unkonw
            let element = sender as NSObject
            if element == btnExpend {
                type = .Expend
            } else if element == btnDelete {
                type = .Delete
            } else if element == btnFavirote {
                type = .Favorite
            } else if element == btnBrowse {
                type = .Browse
            }
            //
            delegate?.onAction(self.associatedName!.toInt()!, actionType: type)
        }
        
    }
    
}