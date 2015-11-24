//
//  ProposalEnum.swift
//  AIVeris
//
//  Created by Rocky on 15/10/28.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

enum ServiceOrderState: String {
    case Completed = "Completed"
    case CompletedAndChecked = "CompletedAndChecked"
}


enum ProposalServiceViewTemplate : Int {
    // 机票
    case PlaneTicket = 1
    // 打车
    case Taxi
    // 酒店
    case Hotel
    // 单参数展示
    case SingleParam
    // 多参数文字展示
    case MutilParams
    // 多参数图文展示
    case MutilTextAndImage
    // 商品清单
    case Shopping
}