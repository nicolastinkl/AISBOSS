//
//  SimpleServiceViewContainer.swift
//  AIVeris
//
//  Created by Rocky on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class SimpleServiceViewContainer: UIView {
    
    private static let DIVIDER_TOP_MARGIN: CGFloat = 8
    private static let DIVIDER_BOTTOM_MARGIN: CGFloat = 8

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var paramsView: UIView!
    @IBOutlet weak var originalPrice: AIHorizontalLineLabel!
    @IBOutlet weak var savedMoney: UILabel!
    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var divider: UIImageView!
    @IBOutlet weak var settingState: UIImageView!
    
    
    @IBOutlet weak var paramsViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var dividerTopMargin: NSLayoutConstraint!
    @IBOutlet weak var dividerBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var messageHeight: NSLayoutConstraint!
    
    private var dataModel: AIProposalServiceModel?
    
    private var paramViewHeight: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let starRateView = CWStarRateView(frameAndImage: CGRectMake(0, 0, 60, 10), numberOfStars: 5, foreground: "review_star_yellow", background: "review_star_gray")
        topView.addSubview(starRateView)
        
        layout(starRateView, review) {star, review in
            star.left == review.right - 2
            star.height == starRateView.height
            star.width == starRateView.width
            star.top == review.top + 1
        }
        
        name.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(42))
        price.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(48))
        review.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(31))
        savedMoney.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(31))
        originalPrice.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(26))
        
        layer.cornerRadius = 6
        layer.masksToBounds = true
        logo.layer.cornerRadius = logo.width / 2
        
        originalPrice.linePosition = .Middle
        
    }
    
    //加载数据
    func loadData(dataModel : AIProposalServiceModel){
        self.dataModel = dataModel
        
        logo.asyncLoadImage(dataModel.service_thumbnail_icon ?? "")
        price.text = dataModel.service_price ?? "$0"
        name.text = dataModel.service_desc ?? ""
        
        if dataModel.service_param != nil {
            
            if let key = dataModel.service_param.param_key {
                let viewTemplate = ProposalServiceViewTemplate(rawValue: Int(key)!)
                if let paramValueString = dataModel.service_param.param_value{
                    let jsonData = paramValueString.dataUsingEncoding(NSUTF8StringEncoding)
                    //获取到参数的dictionary
                    let paramDictionary = try? NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    if let serviceView = createServiceView(viewTemplate!,paramDictionary : paramDictionary!) {
                        addParamsView(serviceView)
                        addMessageView()
                    }
                }
            }
        }
    }
    
    
    private func createServiceView(viewTemplate : ProposalServiceViewTemplate, paramDictionary : NSDictionary) -> View? {
        switch viewTemplate {
        case ProposalServiceViewTemplate.PlaneTicket:
            let serviceDetailView = ServiceCardDetailIcon(frame: CGRectMake(0, 0, AITools.displaySizeFrom1080DesignSize(895), 0))
            serviceDetailView.loadData()
            return serviceDetailView
            //let serviceDetailView = FlightServiceView.createInstance()
            //serviceDetailView.loadData(paramDictionary)
            //return serviceDetailView
        case ProposalServiceViewTemplate.Taxi:
            let v = AIIconTextView.createInstance()
            v.loadData("")
            return v
        case ProposalServiceViewTemplate.Hotel:
            return AccommodationService(frame: CGRect(x: 0, y: 0, width: paramsView.frame.width, height: 0))
        default:
            return nil
        }
    }
    
    private func addParamsView(serviceParams: UIView) {
        frame.size.height = topHeight() + paramsViewTopMargin.constant + serviceParams.frame.height + dividerTopMargin.constant + dividerBottomMargin.constant + divider.height
        paramViewHeight = serviceParams.frame.height
        paramsView.addSubview(serviceParams)
        
        layout(paramsView, serviceParams) {container, item in
            item.left == container.left
            item.top == container.top
            item.bottom == container.bottom
            item.right == container.right
        }
    }
    
    private func addMessageView() {
        
        let msgContent = ServiceSettingView.createInstance()
        
        dividerTopMargin.constant = SimpleServiceViewContainer.DIVIDER_TOP_MARGIN
        dividerBottomMargin.constant = SimpleServiceViewContainer.DIVIDER_BOTTOM_MARGIN
        messageHeight.constant = msgContent.height
        
        messageView.setNeedsUpdateConstraints()
        
        messageView.addSubview(msgContent)
        
        layout(messageView, msgContent) {container, view in
            view.left == container.left
            view.top == container.top
            view.bottom == container.bottom
            view.right == container.right
        }
        
        divider.hidden = false
        frame.size.height = totalHeight()
    }
    
    private func topHeight() -> CGFloat {
        return topView.height
    }
    
    private func totalHeight()-> CGFloat {
        return topHeight() + paramsViewTopMargin.constant + paramViewHeight + dividerTopMargin.constant + dividerBottomMargin.constant + divider.height + messageHeight.constant
    }
}
