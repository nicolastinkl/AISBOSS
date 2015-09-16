//
//  AICatalogServicesModel.swift
//  AI2020OS
//
//  Created by admin on 15/6/1.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import AISwiftyJSON

struct AICatalogServicesResult: JSONJoy {
    var services = [AIServiceTopicModel]()
    var page_num = 0
    
    init() {
        
    }
    
    init(_ decoder: JSONDecoder) {
        if decoder["page_num"].integer != nil {
            page_num = decoder["page_num"].integer!
        }
        if let jsonArray = decoder["service_list"].array {
            for subDecoder in jsonArray {
                services.append(AIServiceTopicModel(subDecoder))
            }
        }
    }
}


/*!
*  @author tinkl, 15-09-15 16:09:21
*
*  服务Coverflow数据结构Model
*/
struct AICustomerServiceCoverFlowModel : JSONJoy {
    var service_id : Int?
    var service_name : String?
    var service_price : String?
    var service_intro : String?
    var provider_id : Int?
    var provider_name : String?
    var service_rating : Int?
    var provider_icon : String?
    var service_img : String?
    
    init(){
        
    }
    
    init(_ decoder: JSONDecoder) {
        service_id = decoder["service_id"].integer
        service_name = decoder["service_name"].string
        service_price = decoder["service_price"].string
        service_intro = decoder["service_intro"].string
        provider_id = decoder["provider_id"].integer
        provider_name = decoder["provider_name"].string
        service_rating = decoder["service_rating"].integer
        provider_icon = decoder["provider_icon"].string
        service_img = decoder["service_img"].string
    }
}
