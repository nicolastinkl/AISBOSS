//
//  AIFavoritesServicesModel.swift
//  AI2020OS
//
//  Created by Rocky on 15/6/12.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import AISwiftyJSON

class AIFavoritesServicesResult: JSONJoy {
    var services = [AIServiceTopicModel]()

    init() {
        
    }
    
    required init(_ decoder: JSONDecoder) {
        if let jsonArray = decoder["collected_services"].array {
            for subDecoder in jsonArray {
                services.append(AIServiceTopicModel(subDecoder))
            }
        }
    }
}

class AIFavoritesServiceTagsResult: JSONJoy {
    var tags = [String]()
    
    init() {
        
    }
    
    required init(_ decoder: JSONDecoder) {
        if let jsonArray = decoder["service_tags"].array {
            for subDecoder in jsonArray {
                if let tag = subDecoder["tag_name"].string {
                    tags.append(tag)
                }
            }
        }
    }
}