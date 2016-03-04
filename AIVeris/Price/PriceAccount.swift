//
//  PriceAccount.swift
//  AIVeris
//
//  Created by Rocky on 15/10/13.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

protocol PriceAccount {
    func inToAccount(item: PriceItem)
    func outOfAccount(item: PriceItem)
    func getTotalAmount() -> Float
}

class SimpleAccumulativeAccount : PriceAccount {
    private var totalPrice: Float = 0
    private var recordPriceItems: [Int: PriceItem] = [Int: PriceItem]()
    
    func inToAccount(item: PriceItem) {
        if recordPriceItems[item.id] == nil {
            totalPrice += item.priceValue
            recordPriceItems[item.id] = item
        }
    }
    
    func outOfAccount(item: PriceItem) {
        if recordPriceItems[item.id] != nil {
            totalPrice -= item.priceValue
            recordPriceItems[item.id] = nil
        }
    }
    
    func getTotalAmount() -> Float {
        return totalPrice
    }
}


