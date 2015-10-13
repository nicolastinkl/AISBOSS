//
//  AIServiceSchemeModel.swift
//  AIVeris
//
//  Created by tinkl on 10/10/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import AISwiftyJSON

// 服务方案详情
struct AIServiceSchemeModel : JSONJoy {
    
    var param_list: Array<SchemeParamList>?
    var catalog_list: Array<Catalog>?
    
    init(){
        
    }
    
    init(_ decoder: JSONDecoder) {

        if let addrs = decoder["param_list"].array {
            param_list = Array<SchemeParamList>()
            for addrDecoder in addrs {
                param_list?.append(SchemeParamList(addrDecoder))
            }
        }
        
        if let addrs = decoder["catalog_list"].array {
            catalog_list = Array<Catalog>()
            for addrDecoder in addrs {
                catalog_list?.append(Catalog(addrDecoder))
            }
        }
    }
}

// 参数列表
struct SchemeParamList: JSONJoy {
    
    var param_key: Int?    
    var param_value: String?
    var param_value_id: Int?
    
    init(_ decoder: JSONDecoder) {
        
        param_key = decoder["service_id"].integer
        param_value = decoder["param_value"].string
        param_value_id = decoder["param_value_id"].integer
        
    }
}

// 服务列表
struct Catalog: JSONJoy {
    
    var catalog_id: Int?
    var select_flag: Int?
    var binding_flag: Int?
    var service_level: ServiceLevel?
    
    var relevant_level: Int?
    var catalog_name: String?
    
    var service_list: Array<Service>?
    
    init(_ decoder: JSONDecoder) {
        
        catalog_id = decoder["catalog_id"].integer
        select_flag = decoder["select_flag"].integer
        binding_flag = decoder["binding_flag"].integer
        service_level = ServiceLevel(rawValue: decoder["service_level"].integer ?? 0)
        relevant_level = decoder["relevant_level"].integer
        
        catalog_name = decoder["catalog_name"].string
        
        
        if let addrs = decoder["service_list"].array {
            service_list = Array<Service>()
            for decoder in addrs {
                service_list?.append(Service(decoder))
            }
        }
    }
}

struct Service: JSONJoy{
    
    var service_id: Int?
    var provider_id: Int?
    var service_rating: Int?

    var service_name: String?
    var service_intro: String?
    var service_intro_img: String?

    var service_param_list: Array<SchemeParamList>?
    var service_price : ServicePrice?
    var service_provider: ServiceProvider?
    
    init(_ decoder: JSONDecoder) {
        
        service_id = decoder["service_id"].integer
        provider_id = decoder["provider_id"].integer
        service_rating = decoder["service_rating"].integer
        
        service_name = decoder["service_name"].string
        service_intro = decoder["service_intro"].string
        service_intro_img = decoder["service_intro_img"].string
        
        
        if let addrs = decoder["service_param_list"].array {
            service_param_list = Array<SchemeParamList>()
            for decodecccr in addrs {
                service_param_list?.append(SchemeParamList(decodecccr))
            }
        }
        
        service_price = ServicePrice(decoder["service_price"])
        service_provider = ServiceProvider(decoder["service_provider"])
    }
}

struct ServicePrice: JSONJoy {

    var price: Int?
    var unit: String?
    var billing_mode: String?
    var price_show: String?
    
    init(_ decoder: JSONDecoder) {
        
        price = decoder["price"].integer
        unit = decoder["unit"].string
        billing_mode = decoder["billing_mode"].string
        price_show = decoder["price_show"].string
        
    }
}

struct ServiceProvider : JSONJoy {
    
    var provider_id: Int?
    var provider_name: String?
    var provider_portrait_icon: String?
    
    init(_ decoder: JSONDecoder) {
        provider_id = decoder["provider_id"].integer
        provider_name = decoder["provider_name"].string
        provider_portrait_icon = decoder["provider_portrait_icon"].string
    }
}

enum ServiceLevel: Int {
    case Undefine
    case Coverflow = 1
    case Card
    case Switch
    case FlightTicket
}

