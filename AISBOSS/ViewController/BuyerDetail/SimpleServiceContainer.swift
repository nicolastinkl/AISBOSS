//
//  SimpleServiceContainer.swift
//  AIVeris
//
//  Created by admin on 15/11/17.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class SimpleServiceContainer: UIView {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var detail: UIView!
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var savedMoney: UILabel!
    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var settingView: UIView!
    
    @IBOutlet weak var settingHeightConstraint: NSLayoutConstraint!
    
    private var dataModel: AIProposalServiceModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        name.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(56))
        price.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(56))
        
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
                        addDetailView(serviceView)
                        addSettingView()
                    }
                }
            }
        }
    }
    
    
    private func createServiceView(viewTemplate : ProposalServiceViewTemplate, paramDictionary : NSDictionary) -> View? {
        switch viewTemplate {
        case ProposalServiceViewTemplate.PlaneTicket:
            let serviceDetailView = FlightServiceView.createInstance()
            //   let serviceDetailView = FlightService(frame: CGRect(x: 0, y: 0, width: detail.frame.width, height: 0))
            serviceDetailView.loadData(paramDictionary)
            return serviceDetailView
        case ProposalServiceViewTemplate.Taxi:
            return TransportService(frame: CGRect(x: 0, y: 0, width: detail.frame.width, height: 0))
        case ProposalServiceViewTemplate.Hotel:
            return AccommodationService(frame: CGRect(x: 0, y: 0, width: detail.frame.width, height: 0))
        }
    }
    
    private func addDetailView(detailView: UIView) {
        frame.size.height = topHeight() + detailView.frame.height
        detail.addSubview(detailView)
        
        layout(detail, detailView) {detail, detailView in
            detailView.left == detail.left
            detailView.top == detail.top
            detailView.bottom == detail.bottom
            detailView.right == detail.right
        }
    }
    
    private func addSettingView() {
        
        let settingContent = ServiceSettingView.createInstance()
        
        frame.size.height += settingContent.frame.height
        
        settingHeightConstraint.constant = settingContent.frame.height
        settingView.setNeedsUpdateConstraints()
        
        settingView.addSubview(settingContent)
        
        layout(settingView, settingContent) {container, view in
            view.left == container.left
            view.top == container.top
            view.bottom == container.bottom
            view.right == container.right
        }
    }
    
    private func topHeight() -> CGFloat {
        return detail.frame.origin.y
    }
}
