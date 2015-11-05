//
//  FlightService.swift
//  AIVeris
//
//  Created by Rocky on 15/11/3.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class FlightService: UIView {
    
    private var takeOffTime: UILabel!
    private var arriveTime: UILabel!
    private var from: UILabel!
    private var to: UILabel!
    private var fromAirport: UILabel!
    private var toAirport: UILabel!
    private var plane: UILabel!
    
    var paramData : NSDictionary?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSelf()
    }
    
    init(frame:CGRect , paramData : NSDictionary){
        super.init(frame: frame)
        loadData(paramData)
        initSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelf()
    }
    
    private func loadData(paramData : NSDictionary){
        self.paramData = paramData
    }
    
    private func initSelf() {
        frame.size.height = AITools.displaySizeFrom1080DesignSize(275)
        addTime()
        addLocation()
        addAirport()
        addPlane()
    }
    
    private func addTime() {
        takeOffTime = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width / 3, height: 20))
        takeOffTime.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(66))
        takeOffTime.textColor = UIColor.whiteColor()
        arriveTime = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        arriveTime.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(66))
        arriveTime.textColor = UIColor.whiteColor()
        addSubview(takeOffTime)
        addSubview(arriveTime)
        
        layout(takeOffTime, arriveTime) {takeOffTime, arriveTime in
            arriveTime.baseline == takeOffTime.baseline
            arriveTime.left == takeOffTime.right + 60
            arriveTime.width == takeOffTime.width
            arriveTime.height == takeOffTime.height
        }
        
        takeOffTime.text = "9:30"
        arriveTime.text = "10:40"
    }
    
    private func addLocation() {
        from = UnderlineLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        from.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(56))
        from.textColor = UIColor(hex: "#FEE300")
        to = UnderlineLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        to.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(56))
        to.textColor = UIColor(hex: "#FEE300")
        addSubview(from)
        addSubview(to)
        
        layout(takeOffTime, from, to) {takeOffTime, from, to in
            from.left == takeOffTime.left
            from.top == takeOffTime.bottom + 10
            from.width == takeOffTime.width
            from.height == takeOffTime.height
            
            to.baseline == from.baseline
            to.left == from.right + 60
            to.width == from.width
            to.height == from.height
        }
        
        from.text = "Beijing"
        to.text = "Shanghai"
    }
    
    private func addAirport() {
        fromAirport = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        fromAirport.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(36))
        fromAirport.textColor = UIColor.whiteColor()
        toAirport = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        toAirport.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(36))
        toAirport.textColor = UIColor.whiteColor()
        addSubview(fromAirport)
        addSubview(toAirport)
        
        layout(from, fromAirport, to) {from, fromAirport, to in
            fromAirport.left == from.left
            fromAirport.top == from.bottom + 10
            fromAirport.right == to.left - 10
            fromAirport.height == from.height
        }
        
        layout(fromAirport, toAirport, to) {fromAirport, toAirport, to in
            toAirport.baseline == fromAirport.baseline
            toAirport.left == to.left
            toAirport.width == fromAirport.width
            toAirport.height == fromAirport.height
        }
        
        fromAirport.text = "Capital Airport T3"
        toAirport.text = "Pudong Airport T2"
    }
    
    private func addPlane() {
        let plane = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let planeImg = UIImage(named: "airplane_white")
        let planeSize = AITools.imageDisplaySizeFrom1080DesignSize(planeImg!.size)
        addSubview(plane)
        
        layout(to, plane) {to, plane in
            plane.height == planeSize.height
            plane.width == planeSize.width
            plane.top == to.top + 5
            plane.right == to.left - 10
        }
        
        plane.image = planeImg
    }

}
