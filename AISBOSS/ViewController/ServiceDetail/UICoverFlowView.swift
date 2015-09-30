//
//  UICoverFlowView.swift
//  AIVeris
//
//  Created by tinkl on 15/9/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

class UICoverFlowView: UIView {
    
    // MARK : variables
    @IBOutlet weak var lableTitle: UILabel!
    @IBOutlet weak var lableContent: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var imageview: AIImageView!
    @IBOutlet weak var avatorImageview: AIImageView!
    @IBOutlet weak var labelNick: UILabel!
    @IBOutlet weak var starView: UIView!
    
    // MARK: currentView
    class func currentView()->UICoverFlowView{
        let selfView = NSBundle.mainBundle().loadNibNamed("UICoverFlowView", owner: self, options: nil).first  as! UICoverFlowView
        return selfView
    }
    
    func fillDataWithModel(model: ServiceList){
        
        let starRateView = CWStarRateView(frame: CGRectMake(22, 0, AIApplication.AIStarViewFrame.width, AIApplication.AIStarViewFrame.height), numberOfStars: 5)
        if starView.subviews.count <= 0 {
            starView.addSubview(starRateView)
        }
        
        starRateView.scorePercent = CGFloat(model.service_rating)
        avatorImageview.maskWithEllipse()
        lableTitle.text = model.service_name as String
        lableContent.text = model.service_intro as String
        labelPrice.text = model.service_price.price_show as String
        imageview.setURL(model.service_intro_img?.toURL()!, placeholderImage: UIImage(named: "Placehold"))

        if model.service_provider.provider_portrait_icon != nil {
            avatorImageview.setURL(model.service_provider.provider_portrait_icon?.toURL()!, placeholderImage: UIImage(named: "Placehold"))        
        }
        
        if model.service_provider.provider_name != nil {
            labelNick.text = model.service_provider.provider_name as String
        }
        
    }
    
}