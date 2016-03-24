//
//  BuyerOrderModel.swift
//  AIVeris
//
//  Created by Rocky on 16/3/23.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class BuyerOrderModel : AIBaseModel {
    var buyerId: String?
    var avatarUrl: String?
    var messageNumber: Int?
    var buyerName: String?
    
    // order
    var serviceName: String?
    var orderId: String?
    var completion: Float?
    var price: Float?
}

