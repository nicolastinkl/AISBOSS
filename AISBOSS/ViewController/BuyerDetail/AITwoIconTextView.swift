//
//  AITowPlacesView.swift
//  AIVeris
//
//  Created by admin on 15/11/23.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AITwoIconAndTextView: UIView {

    @IBOutlet weak var firstIcon: UIImageView!
    @IBOutlet weak var secondIcon: UIImageView!
    @IBOutlet weak var firstText: UILabel!
    @IBOutlet weak var secondText: UILabel!
    
    override func awakeFromNib() {
        firstText.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(36))
        secondText.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(36))
    }
    
    static func createInstance() -> AITwoIconAndTextView {
        return NSBundle.mainBundle().loadNibNamed("AITwoIconTextView", owner: self, options: nil).first  as! AITwoIconAndTextView
    }
}
