//
//  AIOrderDescView.swift
//  订单右下角
//
//  Created by 刘先 on 15/10/21.
//  Copyright © 2015年 wantsor. All rights reserved.
//

import Foundation
import UIKit

//收起订单的展现方式枚举，
enum DESC_SERVICE_TYPE : Int{
    case DEFAULT  //
    case PLANE_TRAVEL=1
}

class AIOrderDescView: UIView {
    
    var descLabel: UILabel!

    let TEXT_HEIGHT : CGFloat = 21
    let TEXT_PADDING : CGFloat = 5
    let VIEW_PADDING : CGFloat = 1

    
    let DESC_TEXT_FONT = PurchasedViewFont.SERVICE_TITLE
    let LABEL_TITLE_FONT = PurchasedViewFont.SERVICE_STATU
    let LABEL_VALUE_FONT = PurchasedViewFont.ORDER_TIME_VALUE
    let ALERT_LABEL_FONT = PurchasedViewFont.ORDER_ALERT_LABEL
    
    var serviceOrderModel : ServiceOrderModel!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //load data
    func loadData(serviceOrderModel : ServiceOrderModel) {
        self.serviceOrderModel = serviceOrderModel

        if (serviceOrderModel.arrange_script_info != nil) {
        
            let x = buildKeypointsView()
            buildDescriptionAndAlertView(x)
        }
    }
    
    // 创建关键点视图， 返回视图的起始点x坐标
    private func buildKeypointsView() -> CGFloat {
        
        var preFrame: CGRect!
        let arrangeModel = serviceOrderModel.arrange_script_info
        
        if let keypoints = arrangeModel?.info_key_points as? [KeypointModel] {
            for var index = keypoints.count - 1; index >= 0; --index {
                let keypoint = keypoints[index]
                var strSize: CGSize?
                var strLabel: UILabel!
                
                if let content = notEmptyString(keypoint.key_point_content) {
                    strSize = content.sizeWithFont(LABEL_VALUE_FONT, forWidth: 1000)
                    strLabel = createKeypointContentLabel(content)
                } else if let title = notEmptyString(keypoint.key_point_title) {
                    strSize = title.sizeWithFont(LABEL_TITLE_FONT, forWidth: 1000)
                    strLabel = createKeypointTitleLabel(title)
                }
                
                if strSize != nil {
                    
                    var currentStrFrame: CGRect!
                    
                    if preFrame == nil {
                        currentStrFrame = CGRectMake(self.bounds.width - strSize!.width - VIEW_PADDING, 0, strSize!.width, TEXT_HEIGHT)
                    } else {
                        currentStrFrame = CGRectMake(preFrame.origin.x - TEXT_PADDING - strSize!.width, 0, strSize!.width, TEXT_HEIGHT)
                    }
                    
                    strLabel.textColor = PurchasedViewColor.TITLE
                    strLabel.frame = currentStrFrame
                    
                    addSubview(strLabel)
                    
                    preFrame = currentStrFrame
                }
            }
        }
        
        
        if preFrame == nil {
            preFrame = CGRectMake(self.bounds.width - VIEW_PADDING, 0, 0, TEXT_HEIGHT)
        }
        
        return preFrame.origin.x
    }
    
    private func notEmptyString(srcString: String!) -> String? {
        if srcString != nil && srcString != "" {
            return srcString
        } else {
            return nil
        }
    }
    
    private func createKeypointContentLabel(str: String) -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        label.textColor = PurchasedViewColor.TITLE
        label.font = LABEL_VALUE_FONT
        label.text = str
        return label
    }
    
    private func createKeypointTitleLabel(str: String) -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        label.textColor = PurchasedViewColor.TITLE
        label.font = LABEL_TITLE_FONT
        label.alpha = 0.6
        label.text = str
        return label
    }
    
    private func buildDescriptionAndAlertView(keypointViewOriginX: CGFloat) {
        var descLabelFrame : CGRect!
        
        if isDelayed() {
            let alertTextSize = "Delayed".sizeWithFont(ALERT_LABEL_FONT, forWidth: 1000)
            let alertLabelFrame = CGRectMake(keypointViewOriginX - alertTextSize.width - 25, 0, alertTextSize.width, TEXT_HEIGHT)
            let alertLabel = UILabel(frame: alertLabelFrame)
            alertLabel.text = "Delayed"
            alertLabel.font = ALERT_LABEL_FONT
            alertLabel.textColor = UIColor(hex: "#dbb613")
            alertLabel.alpha = 0.6
            self.addSubview(alertLabel)
            
            descLabelFrame = CGRectMake(0, 0, alertLabelFrame.origin.x - TEXT_PADDING, 21)
        } else {
            descLabelFrame = CGRectMake(0, 0, keypointViewOriginX - TEXT_PADDING, 21)
        }
        
        
        descLabel = UILabel(frame: descLabelFrame)
        descLabel.text = serviceOrderModel.arrange_script_info.info_desc ?? "Delivery staff:Mike Liu"
        descLabel.textColor = UIColor.whiteColor()
        descLabel.font = DESC_TEXT_FONT
        addSubview(descLabel)
    }
    
    private func isDelayed() -> Bool {
        return serviceOrderModel.order_state == "Delayed"
    }
}