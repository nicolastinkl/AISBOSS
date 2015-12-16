//
//  AIBuyServiceModel.swift
//  AIVeris
//
//  Created by tinkl on 26/10/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

import AISwiftyJSON

struct AIBuyServiceModel : JSONJoy {
 
    var new_proposal_flag: Int?
    var proposal_list: Array<AIPopPropsalModel>?
    
    init(_ decoder: JSONDecoder) {

        new_proposal_flag = decoder["new_proposal_flag"].integer
        
        if let addrs = decoder["proposal_list"].array {
            proposal_list = Array<AIPopPropsalModel>()
            for addrDecoder in addrs {
                proposal_list?.append(AIPopPropsalModel(addrDecoder))
            }
        }
    }
}

// 气泡model
struct AIPopPropsalModel : JSONJoy {
    
    var proposal_id: Int?
    var proposal_id_new: Int?
    var service_id: Int?
    var order_times: Int?
    
    var service_thumbnail_icon: String?
    var proposal_name: String?
    var proposal_price: String?

    var service_list: Array<AIPopServiceDetailModel>?
    
    init(_ decoder: JSONDecoder) {
        
        proposal_id = decoder["proposal_id"].integer
        proposal_id_new = decoder["proposal_id_new"].integer
        service_id = decoder["service_id"].integer
        order_times = decoder["order_times"].integer
        
        service_thumbnail_icon = decoder["service_thumbnail_icon"].string ?? ""
        proposal_name = decoder["proposal_name"].string
        proposal_price = decoder["proposal_price"].string
        
        if let addrs = decoder["service_list"].array {
            service_list = Array<AIPopServiceDetailModel>()
            for addrDecoder in addrs {
                service_list?.append(AIPopServiceDetailModel(addrDecoder))
            }
        }
    }
}

struct AIPopServiceDetailModel : JSONJoy {
    var service_id: Int?
    var service_thumbnail_icon: String?
    
    init(_ decoder: JSONDecoder) {
        
        service_id = decoder["service_id"].integer
        service_thumbnail_icon = decoder["service_thumbnail_icon"].string
        
    }
}


/**
 *  @author tinkl, 15-11-20 16:11:50
 *
 *  @brief  处理tag Model
 *
 *  @since <#version number#>
 */
struct AIBuerSomeTagModel : JSONJoy {
    var bsId : Int?
    var unReadNumber : Int?
    var tagName : String?
    init(){
    
    }
    
    init(_ decoder: JSONDecoder) {
        
    }
}
/**
{
"proposal_id": 4,
"proposal_id_new": 0,
"service_id": 1,
"service_thumbnail_icon": "推荐服务图标url",
"proposal_name": "Business Travel",
"proposal_price": "$836+",
"order_times": 40,
"service_list": [
{
"service_id": 1,
"service_thumbnail_icon": "http://10.5.1.249:3000/upload/proposal/A18rg98bANwPe.png"
},
{
"service_id": 2,
"service_thumbnail_icon": "http://10.5.1.249:3000/upload/proposal/FQZ8fUvWNgv6h.png"
},
{
"service_id": 3,
"service_thumbnail_icon": "http://10.5.1.249:3000/upload/proposal/tuZMJKxSr8TeJ.png"
}
]
},
*/