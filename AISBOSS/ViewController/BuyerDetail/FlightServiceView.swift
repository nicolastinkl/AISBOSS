//
//  FlightServiceView.swift
//  AIVeris
//
//  Created by Rocky on 15/11/9.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class FlightServiceView: ServiceDetailView {

    @IBOutlet weak var takeOffTime: UILabel!
    @IBOutlet weak var fromAirport: UILabel!
    @IBOutlet weak var toAirport: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var to: UILabel!
    @IBOutlet weak var arriveTime: UILabel!
    
    static func createInstance() -> FlightServiceView {
        return NSBundle.mainBundle().loadNibNamed("FlightServiceView", owner: self, options: nil).first  as! FlightServiceView
    }
    
    override func awakeFromNib() {
        frame.size.height = AITools.displaySizeFrom1080DesignSize(275)
        
        takeOffTime.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(66))
        arriveTime.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(66))
        
        from.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(56))
        to.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(56))
        
        fromAirport.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(36))
        toAirport.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(36))
    }
    
    override func loadData(paramData : NSDictionary) {
        super.loadData(paramData)
        
        takeOffTime.text = getStringContent("departure_time")
        from.text = getStringContent("departure_place")
        fromAirport.text = getStringContent("departure_desc")
        
        arriveTime.text = getStringContent("departure_time")
        to.text = getStringContent("arrival_place")
        toAirport.text = getStringContent("arrival_desc")
    }

}
