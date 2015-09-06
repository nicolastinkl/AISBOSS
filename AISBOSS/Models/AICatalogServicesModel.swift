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