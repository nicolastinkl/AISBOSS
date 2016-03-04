//
//  AIOrderDetailModel.swift
//  AI2020OS
//
//  Created by 郑鸿翔 on 15/5/30.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import SwiftyJSON

// 订单详情数据模型
struct OrderDetailModel : JSONJoy {
    var orderNum : Int?
    var orderState : Int?
    var orderStateName : String?
    var orderTime : String?
    var serviceName : String?
    var servicePrice : String?
    var providerId : Int?
    var providerName : String?
    
    init(){
    
    }
    var params: Array<ServiceParam>?
    
    
    init(_ decoder: JSONDecoder) {
        orderNum = decoder["order_number"].integer
        orderTime = decoder["order_time"].string
        orderState = decoder["order_state"].integer
        orderStateName = decoder["order_state_name"].string
        serviceName = decoder["service_name"].string
        servicePrice = decoder["service_price"].string
        providerId = decoder["provider_id"].integer
        providerName = decoder["provider_name"].string
        
        if let sparam = decoder["service_param_list"].array {
            params = Array<ServiceParam>()
            for serviceParam in sparam {
                params?.append(ServiceParam(serviceParam))
            }
        }
    }
    
    
    
}

// 服务参数数据模型
struct ServiceParam {
    var paramKey : Int?
    var paramValue : String?
    var paramName : String?

    init(){
    
    }
    
    init(_ decoder: JSONDecoder) {
        paramKey = decoder["param_key"].integer
        paramValue = decoder["param_value"].string
        paramName = decoder["param_name"].string
    }
}












