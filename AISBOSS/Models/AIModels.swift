//
//  AIModels.swift
//  AI2020OS
//
//  Created by tinkl on 25/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AIServiceTopicResult: JSONJoy  {
    var service_array: Array<AIServiceTopicListModel>?
    init(_ decoder: JSONDecoder) {
        if let addrs = decoder["results"].array {
            service_array = Array<AIServiceTopicListModel>()
            for addrDecoder in addrs {
                service_array?.append(AIServiceTopicListModel(addrDecoder))
            }
        }
    }
    
}

struct AIServiceTopicListModel: JSONJoy  {
    var result_type: Int?
    var service_array: Array<AIServiceTopicModel>?
    
    init(_ decoder: JSONDecoder) {
        result_type = decoder["result_type"].integer
        if let addrs = decoder["result_items"].array {
            service_array = Array<AIServiceTopicModel>()
            for addrDecoder in addrs {
                service_array?.append(AIServiceTopicModel(addrDecoder))
            }
        }
    }
}

class AIServiceTopicModel: JSONJoy  {

    var service_id: Int?
    var service_name: String?
    var service_price: String?
    var service_intro: String?
    var provider_id: String?
    var provider_name: String?
    var service_rating: String?
    var provider_portrait_url: String?
    var service_intro_url: String?
    var service_thumbnail_url: String?
    var contents = [String]()
    var tags = [String]()
    var isFavor = false

    init() {
        
    }
    
    required init(_ decoder: JSONDecoder) {
        service_id = decoder["service_id"].integer
        service_name = decoder["service_name"].string
        service_price = decoder["service_price"].string
        service_intro = decoder["service_intro"].string
        provider_id = decoder["provider_id"].string
        provider_name = decoder["provider_name"].string
        service_rating = decoder["service_rating"].string
        provider_portrait_url = decoder["provider_portrait_url"].string
        service_intro_url = decoder["service_intro_url"].string
        service_thumbnail_url = decoder["service_thumbnail_url"].string
        if let tagsArray = decoder["service_tags"].array {
            for dec in tagsArray {
                if let tag = dec["tag_name"].string {
                    tags.append(tag)
                }
            }
        }
    }
}



struct AIServiceDetailModel: JSONJoy  {
    
    var service_id: Int?
    var service_name: String?
    var service_price: String?
    var service_intro: String?
    var provider_id: String?
    var provider_name: String?
    var service_rating: String?
    var provider_portrait_url: String?
    var service_intro_url: String?
    
    var service_provider: String?
    var service_guarantee: String?
    var service_process: String?
    var service_restraint: String?
    var service_param_list: Array<AIServiceDetailParamsModel>?
    
    init(){
        
    }

    
    init(_ decoder: JSONDecoder) {
        service_id = decoder["service_id"].integer
        service_name = decoder["service_name"].string
        service_price = decoder["service_price"].string
        service_intro = decoder["service_intro"].string
        provider_id = decoder["provider_id"].string
        provider_name = decoder["provider_name"].string
        service_rating = decoder["service_rating"].string
        provider_portrait_url = "http://gtms02.alicdn.com/tps/i2/TB1YHZnHXXXXXa2aXXXSutbFXXX.jpg_190x190.jpg"
        //decoder["provider_portrait_url"].string
        service_intro_url = "http://img.hb.aicdn.com/551053d96f65fe88074cd4049a7d21be5f72e403382e9-dFYCbv_fw658"
        service_provider = decoder["service_provider"].string
        service_guarantee = decoder["service_guarantee"].string
        service_restraint = decoder["service_restraint"].string
        service_process = decoder["service_process"].string
        
        if let addrs = decoder["service_param_list"].array {
            service_param_list = Array<AIServiceDetailParamsModel>()
            for addrDecoder in addrs {
                service_param_list?.append(AIServiceDetailParamsModel(addrDecoder))
            }
        }
        
    }
}

struct AIServiceDetailParamsModel: JSONJoy  {
    
    var param_type: Int?
    var param_key: String?
    var param_value: Array<AIServiceDetailParamsDetailModel>?
    
    init(_ decoder: JSONDecoder) {
        
        param_type = decoder["param_type"].integer
        param_key = decoder["param_key"].string
        
        if let addrs = decoder["param_value"].array {
            param_value = Array<AIServiceDetailParamsDetailModel>()
            for addrDecoder in addrs {
                param_value?.append(AIServiceDetailParamsDetailModel(addrDecoder))
            }
        }
    }
    
    struct AIServiceDetailParamsDetailModel: JSONJoy  {

        var id: Int?
        var title: String?
        var content: String?
        var memo: String?
        var value: String?
        
        init(_ decoder: JSONDecoder) {
            id = decoder["id"].integer
            title = decoder["title"].string
            content = decoder["content"].string
            memo = decoder["memo"].string
            value = decoder["value"].string
        }
    }
    
}

class AIResponseResult: JSONJoy {
    var code: Int?
    var msg: String?
    
    init() {
        
    }
    
    required init(_ decoder: JSONDecoder) {
        code = decoder["result_code"].integer
        msg = decoder["result_msg"].string
    }
}




