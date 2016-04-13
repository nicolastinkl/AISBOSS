//
//  OrderAndBuyerInfoView.swift
//  AIVeris
//
//  Created by Rocky on 16/3/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class OrderAndBuyerInfoView: UIView {
    
    var delegate: OrderAndBuyerInfoViewDelegate?

    @IBOutlet weak var buyerIcon: UIImageView!
    @IBOutlet weak var messageNumber: UILabel!
    @IBOutlet weak var buyerName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var percentageNumber: UILabel!
    @IBOutlet weak var progressBar: YLProgressBar!
    
    static func createInstance() -> OrderAndBuyerInfoView {
        let viewThis = NSBundle.mainBundle().loadNibNamed("OrderAndBuyerInfoView", owner: self, options: nil).first  as! OrderAndBuyerInfoView
        
        return viewThis
    }
    
    var model: BuyerOrderModel? {
        didSet {
            if let m = model {
                
                if let name = m.buyerName {
                    buyerName.text = name
                }
                
                if let service = m.serviceName {
                    serviceName.text = service
                }
                
                setProgress(m.completion != nil ? CGFloat(m.completion!) : 0)
                
                
            //    price.text = m.price != nil ? NSString(format: "%.1f", m.price!) as String : "0"
                price.text = m.price != nil ? m.price! : "0"
                if let number = m.messageNumber {
                    if number > 0 {
                        messageNumber.hidden = false
                        messageNumber.text = String(number)
                    } else {
                        messageNumber.hidden = true
                    }
                }
                
                let imageUrl = "\(AIRequirementViewPublicValue.orderPreModel?.customer.user_portrait_icon ?? "")"
                buyerIcon.asyncLoadImage(imageUrl)
                
                if let serviceIconUrl = m.serviceIcon {
                    serviceIcon.asyncLoadImage(serviceIconUrl)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        
        setBuyerIconCorner()
        
        messageNumber.layer.cornerRadius = messageNumber.frame.width / 2
        messageNumber.layer.masksToBounds = true
        let offSet: CGFloat = 4
        buyerName.font = AITools.myriadSemiboldSemiCnWithSize(AITools.displaySizeFrom1080DesignSize(60-offSet))
        price.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(70-offSet))
        messageNumber.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(40-offSet))
        serviceName.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(36-offSet))
        percentageNumber.font = AITools.myriadLightWithSize(AITools.displaySizeFrom1080DesignSize(36-offSet))
        
        let barColors = [UIColor(hex: "#0b82c5"), UIColor(hex: "#10c2dd")]
        progressBar.progressTintColors = barColors
        
        
        buyerIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "buyerIconClicked:"))
    }
    
    func setProgress(progress: CGFloat) {
        progressBar.setProgress(progress, animated: true)

        
        let percentage: Int = Int(progress * 100 + CGFloat(0.5))
        percentageNumber.text = NSString(format: "%d%%", percentage) as String
    }
    
    
    func buyerIconClicked(sender : UIGestureRecognizer){
        delegate?.buyerIconClicked?()
    }
    
    
    private func setBuyerIconCorner() {
        /*
        let iconBounds = buyerIcon.bounds
        
        let maskLayer = CAShapeLayer()
        
        
        maskLayer.frame = CGRect(x: 0, y: 0, width: iconBounds.width * 1.5, height: iconBounds.width * 1.5)
        
        maskLayer.frame.offsetInPlace(dx: (iconBounds.width - maskLayer.frame.width), dy: (iconBounds.height - maskLayer.frame.height) / 2)
        
        let maskPath = UIBezierPath(roundedRect: maskLayer.bounds, byRoundingCorners: [.TopRight, .BottomRight], cornerRadii: CGSizeMake(maskLayer.frame.width / 2, maskLayer.frame.width / 2))
        
        maskLayer.path = maskPath.CGPath
        buyerIcon.layer.mask = maskLayer
        */
    }
}

@objc protocol OrderAndBuyerInfoViewDelegate {
    optional func buyerIconClicked()
}
