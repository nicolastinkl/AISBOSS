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
    
    func fillDataWithModel(model: Service){
        
        let starRateView = CWStarRateView(frame: CGRectMake(22, 0, AIApplication.AIStarViewFrame.width, AIApplication.AIStarViewFrame.height), numberOfStars: 5)
        if starView.subviews.count <= 0 {
            starView.addSubview(starRateView)
        }
        
        starRateView.scorePercent = CGFloat(model.service_rating ?? 0)
        avatorImageview.maskWithEllipse()
        lableTitle.text = model.service_name ?? ""
        lableContent.text = model.service_intro ?? ""
        labelPrice.text = model.service_price?.price_show ?? ""
        imageview.setAIURL(model.service_intro_img?.toURL()!, placeholderImage: smallPlace())
        let name = NSString(format: "%@", model.service_provider?.provider_name ?? "")
        labelNick.text = "\(name)"
        
        let url = NSString(format: "%@", model.service_provider?.provider_portrait_icon ?? "")
        
        avatorImageview.setAIURL("\(url)".toURL(), placeholderImage: smallPlace())
        
    }
    
}