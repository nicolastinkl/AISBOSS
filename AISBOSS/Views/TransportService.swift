//
//  TransportService.swift
//  AIVeris
//
//  Created by Rocky on 15/11/3.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class TransportService: ServiceDetailView {
    
    private var time: UILabel!
    private var from: UILabel!
    private var to: UILabel!
    private var timeTitle: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelf()
    }
    
    private func initSelf() {
        frame.size.height = AITools.displaySizeFrom1080DesignSize(225)
        addTime()
        addLocation()
    }
    
    override func loadData(paramData : NSDictionary) {
        super.loadData(paramData)
        
        time.text = getStringContent("pickup_time")
        from.text = getStringContent("pickup_location")
        to.text = getStringContent("destination")
    }
    
    private func addTime() {
        timeTitle = UILabel(frame: CGRect(x: 35, y: 15, width: 25, height: 12))
        timeTitle.textColor = UIColor.whiteColor()
        timeTitle.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(36))
        timeTitle.text = "Time"
        addSubview(timeTitle)
        
        time = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        time.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(66))
        time.textColor = UIColor.whiteColor()
        addSubview(time)
        layout(timeTitle, time) {title, time in
            time.left == title.right + 5
            time.bottom == title.bottom + 3
            time.right == time.superview!.right
            time.height == AITools.displaySizeFrom1080DesignSize(66)
        }
        
        time.text = "Oct.10th 10:30"
    }
    
    private func addLocation() {
    
        let fromIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let fromIconImg = UIImage(named: "location_from")
        let fromIconSize = AITools.imageDisplaySizeFrom1080DesignSize(fromIconImg!.size)
        fromIcon.image = fromIconImg
        addSubview(fromIcon)
        
        let toIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let toIconImg = UIImage(named: "location_to")
        let toIconSize = AITools.imageDisplaySizeFrom1080DesignSize(toIconImg!.size)
        toIcon.image = toIconImg
        addSubview(toIcon)
        
        from = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        from.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(36))
        from.textColor = UIColor.whiteColor()
        to = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        to.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(36))
        to.textColor = UIColor.whiteColor()
        addSubview(from)
        addSubview(to)
        
        layout(fromIcon, from, timeTitle) {fromIcon, from, timeTitle in
            fromIcon.left == timeTitle.left
            fromIcon.top == timeTitle.bottom + AITools.displaySizeFrom1080DesignSize(32)
            fromIcon.width == fromIconSize.width
            fromIcon.height == fromIconSize.height
        }
        
        layout(time, from, fromIcon) {time, from, fromIcon in
            from.top == time.bottom + AITools.displaySizeFrom1080DesignSize(26)
            from.left == fromIcon.right + 5
            from.right == from.superview!.right
            from.height == AITools.displaySizeFrom1080DesignSize(36)
        }
        
        layout(toIcon, fromIcon) {toIcon, fromIcon in
            toIcon.left == fromIcon.left
            toIcon.top == fromIcon.bottom + AITools.displaySizeFrom1080DesignSize(25)
            toIcon.width == toIconSize.width
            toIcon.height == toIconSize.height
        }
        
        layout(to, from) {to, from in
            to.top == from.bottom + AITools.displaySizeFrom1080DesignSize(20)
            to.left == from.left
            to.right == to.superview!.right
            to.height == from.height
        }
        
        from.text = "Pudong Airport T2"
        to.text = "Yanan Jingan District road 1218"
    }

}
