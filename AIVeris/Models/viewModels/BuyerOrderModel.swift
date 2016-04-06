//
//  BuyerOrderModel.swift
//  AIVeris
//
//  Created by Rocky on 16/3/23.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class BuyerOrderModel : AIBaseModel {
    
    //custom info:
    var buyerId: Int?
    var avatarUrl: String?
    var messageNumber: Int?
    var buyerName: String?
    
    // order info:
    var serviceName: String?
    var orderNumber: String?
    var completion: Float?
    var price: String?


    class func getInstance(jsonModel : AIQueryBusinessInfos) -> BuyerOrderModel{
        
        let customer = jsonModel.customer
        let buyerModel = BuyerOrderModel()
        
        if let id = customer.customer_id {
            buyerModel.buyerId = Int(id)
        }
        
        buyerModel.avatarUrl = customer.customized_portrait_url
        
        if let msgNum = customer.user_message_count {
            buyerModel.messageNumber = Int(msgNum)
        }
        
        buyerModel.buyerName = customer.user_name
        
        buyerModel.serviceName = jsonModel.service?.service_name
        buyerModel.orderNumber = jsonModel.order_number
        
        if let percentage = jsonModel.service_progress?.percentage {
            buyerModel.completion = Float(percentage)
        }
        
        buyerModel.price = jsonModel.service?.service_price

        
        return buyerModel
    }

}

