//
//  UnderlineLabel.swift
//  AIVeris
//
//  Created by admin on 15/11/5.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class UnderlineLabel: UILabel {

    override var text: String? {
        didSet {
            if let str = text {
                let att = NSMutableAttributedString(string: str)
                let range = NSRange(location: 0, length: str.length)
                att.addAttribute(NSUnderlineStyleAttributeName , value: NSNumber(integer: NSUnderlineStyle.StyleSingle.rawValue), range: range)
                attributedText = att
            }
            
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
