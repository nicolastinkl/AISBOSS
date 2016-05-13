//
//  ServiceQRCodeView.swift
//  AIVeris
//
//  Created by admin on 16/5/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class ServiceQRCodeView: UIView {

    @IBOutlet weak var codeImage: UIImageView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var item1: UILabel!
    @IBOutlet weak var item2: UILabel!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSelfFromXib()
        
        serviceName.font = AITools.myriadSemiboldSemiCnWithSize(AITools.displaySizeFrom1080DesignSize(55))
        item1.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(30))
        item2.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(30))
    }

}
