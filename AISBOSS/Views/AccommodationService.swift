//
//  AccommodationService.swift
//  AIVeris
//
//  Created by Rocky on 15/11/3.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class AccommodationService: ServiceDetailView {

    private var period: UILabel!
    private var dayCount: UILabel!
    private var additionDes: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelf()
    }
    
    private func initSelf() {
        frame.size.height = AITools.displaySizeFrom1080DesignSize(210)
        addPeriod()
        addAdditionDescription()
    }
    
    override func loadData(paramData : NSDictionary) {
        super.loadData(paramData)
        
        period.text = getStringContent("checkin_time") + " - " + getStringContent("checkout_time")
    //    additionDes.text = getStringContent("destination")
    }

    private func addPeriod() {
        period = UILabel(frame: CGRect(x: 0, y: 0, width: 160, height: AITools.displaySizeFrom1080DesignSize(66)))
        period.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(66))
        period.textColor = UIColor.whiteColor()
        addSubview(period)
        
        dayCount = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dayCount.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(40))
        dayCount.textColor = UIColor.whiteColor()
        addSubview(dayCount)

        layout(dayCount, period) {dayCount, period in
            dayCount.left == period.right
            dayCount.bottom == period.bottom - 3
            dayCount.height == AITools.displaySizeFrom1080DesignSize(40)
            dayCount.width >= 100
        }
        
        period.text = "Oct.10th - Oct.12th"
        dayCount.text = "(two days)"
    }
    
    private func addAdditionDescription() {
        additionDes = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        additionDes.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(36))
        additionDes.textColor = UIColor.whiteColor()
        addSubview(additionDes)
        
        layout(additionDes, period) {additionDes, period in
            additionDes.left == period.left
            additionDes.top == period.bottom + AITools.displaySizeFrom1080DesignSize(10)
            additionDes.height >= 25
            additionDes.right == additionDes.superview!.right
        }
        additionDes.text = "president room  free breakfast  free wifi"
    }
}
