//
//  AITopInfoView.swift
//  AITrans
//
//  Created by admin on 7/1/15.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//

import Foundation
import AISpring

class AITopInfoView: SpringView {
    
    class func currentView()->AITopInfoView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AITopInfoView", owner: self, options: nil).first  as! AITopInfoView
        selfView.Label_number.transform = CGAffineTransformMakeRotation(CGFloat(M_PI*0.03))
        return selfView
    }
    
    @IBOutlet weak var Label_Title: UILabel!
    @IBOutlet weak var ImageView_Type: UIImageView!
    @IBOutlet weak var Label_Type: UILabel!
    
    @IBOutlet weak var Image_start: UIImageView!
    @IBOutlet weak var View_MarkTags: UIView!
    
    @IBOutlet weak var Label_number: UILabel!
    
    @IBOutlet weak var Image_numberFirst: UIImageView!
    
    @IBOutlet weak var Image_numberSecound: UIImageView!
    
    @IBAction func expendAction(sender: AnyObject) {
        AIApplication().SendAction("expendCell:", ownerName: self)
    }
}