//
//  AccommodationService.swift
//  AIVeris
//
//  Created by Rocky on 15/11/3.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class AccommodationService: UIView {

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
        addPeriod()
        addAdditionDescription()
    }

    private func addPeriod() {
        period = UILabel(frame: CGRect(x: 0, y: 0, width: 160, height: 30))
        period.textColor = UIColor.whiteColor()
        addSubview(period)
        
        dayCount = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dayCount.textColor = UIColor.whiteColor()
        addSubview(dayCount)

        layout(dayCount, period) {dayCount, period in
            dayCount.left == period.right
            dayCount.bottom == period.bottom
            dayCount.height == 25
            dayCount.width >= 100
        }
        
        period.text = "Oct.10th - Oct.12th"
        dayCount.text = "(two days)"
    }
    
    private func addAdditionDescription() {
        additionDes = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        additionDes.textColor = UIColor.whiteColor()
        addSubview(additionDes)
        
        layout(additionDes, period) {additionDes, period in
            additionDes.left == period.left
            additionDes.top == period.bottom + 10
            additionDes.height >= 25
            additionDes.right == additionDes.superview!.right
        }
        additionDes.text = "president room  free breakfast  free wifi"
    }
}
