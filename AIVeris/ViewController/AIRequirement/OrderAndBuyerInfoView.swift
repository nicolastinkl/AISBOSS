//
//  OrderAndBuyerInfoView.swift
//  AIVeris
//
//  Created by admin on 16/3/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class OrderAndBuyerInfoView: UIView {

    @IBOutlet weak var buyerIcon: UIImageView!
    @IBOutlet weak var messageNumber: UILabel!
    @IBOutlet weak var buyerName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var percentageNumber: UILabel!
    @IBOutlet weak var progressBar: YLProgressBar!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    static func createInstance() -> OrderAndBuyerInfoView {
        let viewThis = NSBundle.mainBundle().loadNibNamed("OrderAndBuyerInfoView", owner: self, options: nil).first  as! OrderAndBuyerInfoView
        
        return viewThis
    }
    
    override func awakeFromNib() {
        messageNumber.layer.cornerRadius = messageNumber.frame.width / 2
        messageNumber.layer.masksToBounds = true
        
        buyerName.font = AITools.myriadSemiboldSemiCnWithSize(AITools.displaySizeFrom1080DesignSize(63))
        price.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(70))
        messageNumber.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(43))
        serviceName.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(36))
        percentageNumber.font = AITools.myriadLightWithSize(AITools.displaySizeFrom1080DesignSize(36))
        
        let barColors = [UIColor(hex: "#0b82c5"), UIColor(hex: "#10c2dd")]
        progressBar.progressTintColors = barColors
    }
    
    func setProgress(progress: CGFloat) {
        progressBar.setProgress(progress, animated: true)

        
        let percentage: Int = Int(progress * 100 + CGFloat(0.5))
        percentageNumber.text = NSString(format: "%d%%", percentage) as String
    }
    

}
