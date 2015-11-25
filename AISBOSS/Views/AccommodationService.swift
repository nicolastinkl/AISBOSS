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
    private var model: HotelModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initSelf() {
        frame.size.height = AITools.displaySizeFrom1080DesignSize(210)
        addPeriod()
        addAdditionDescription()
    }
    
    override func loadData(paramData : NSDictionary) {
        super.loadData(paramData)
        initSelf()
        
        period.text = getStringContent("checkin_time") + " - " + getStringContent("checkout_time")
    //    additionDes.text = getStringContent("destination")
        
    }
    
    func loadData(json jonsStr: String) {
        let jsonData = jonsStr.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            model = try HotelModel(data: jsonData)
            initSelf()
        } catch {
            
        }
        
    }

    private func addPeriod() {
        let periodStr = model.checkin_time + " - " + model.checkout_time
        let size = periodStr.sizeWithFont(AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(66)), forWidth: 160)
        period = UILabel(frame: CGRect(x: 35, y: 15, width: size.width, height: AITools.displaySizeFrom1080DesignSize(66)))
        period.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(66))
        period.textColor = UIColor.whiteColor()
        period.text = periodStr
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
        
        dayCount.text = "(two days)"
    }
    
    private func addAdditionDescription() {
        
        additionDes = UILabel(frame: CGRect(x: 35, y: 0, width: 0, height: 0))
        additionDes.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(36))
        additionDes.textColor = UIColor.whiteColor()
        addSubview(additionDes)
        
        layout(additionDes, period) {additionDes, period in
            additionDes.left == period.left
            additionDes.top == period.bottom + AITools.displaySizeFrom1080DesignSize(10)
            additionDes.height >= 25
            additionDes.right == additionDes.superview!.right
        }
        
        if model.facility_desc != nil {
            var desc: String = ""
            
            for de in model.facility_desc {
                let str = de.desc
                desc.appendContentsOf(str + " ")
            }
            
            additionDes.text = desc
        }

    }
}
