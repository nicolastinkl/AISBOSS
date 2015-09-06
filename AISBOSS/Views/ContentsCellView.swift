//
//  ContentsCellView.swift
//  AITrans
//
//  Created by admin on 15/7/1.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

import UIKit

class ContentsCellView: UITableViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var expandView: UIView!
    @IBOutlet weak var contentImage: UIImageView!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func onAction(sender: AnyObject) {
    }
    
    @IBAction func expand(sender: AnyObject) {
        expandView.hidden = (expandView.hidden == true) ? false : true
    }
}
