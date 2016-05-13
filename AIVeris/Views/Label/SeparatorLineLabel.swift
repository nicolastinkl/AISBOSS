//
//  SeparatorLineLabel.swift
//  AIVeris
//
//  Created by admin on 16/5/13.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class SeparatorLineLabel: UIView {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var leftLine: UIView!
    @IBOutlet weak var rightLine: UIView!
    
    private var lineUIImage: UIImage?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelfFromXib()
        
        label.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(48))
    }
    
    @IBInspectable var lineImage: UIImage? {
        set {
            lineUIImage = newValue
            
            if let image = newValue {
                let lineImage = UIColor(patternImage: image)
                leftLine.backgroundColor = lineImage
                rightLine.backgroundColor = lineImage
            }
        }
        
        get {
            return lineUIImage
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
