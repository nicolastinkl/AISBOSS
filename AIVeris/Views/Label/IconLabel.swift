//
//  IconLabel.swift
//  AIVeris
//
//  Created by Rocky on 16/5/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class IconLabel: UIView {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelfFromXib()
        
        label.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(48))
    }
    
    
    @IBInspectable var iconImage: UIImage? {
        set {
            icon.image = newValue
        }
        get {
            return icon.image
        }
    }
    
    @IBInspectable var labelContent: String? {
        set {
            label.text = newValue
        }
        get {
            return label.text
        }
    }
}
