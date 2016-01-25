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
    case Taxi //2
    // 酒店
    case Hotel //3
    // 单参数展示
    case SingleParam //4
    // 多参数文字展示
    case MutilParams //5
    // 多参数图文展示
    case MutilTextAndImage //6
    // 商品清单
    case Shopping //7
    // 文本标签
    case LabelTag //8 text
}