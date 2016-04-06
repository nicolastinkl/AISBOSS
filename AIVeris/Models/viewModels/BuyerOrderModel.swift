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
    var buyerId: String?
    var avatarUrl: String?
    var messageNumber: Int?
    var buyerName: String?
    
    // order info:
    var serviceName: String?
    var orderId: String?
    var completion: Float?
    var price: Float?
    
    //service_progress info:
    

    class func getInstanceArray(jsonModel : AIQueryBusinessInfos) -> BuyerOrderModel{
        
        let buyerModel = BuyerOrderModel()
        buyerModel.buyerId = ""
        
        
        return buyerModel
    }

}

