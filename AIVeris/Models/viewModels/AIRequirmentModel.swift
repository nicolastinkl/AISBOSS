//
//  AIRequirmentModel.swift
//  AIVeris
//
//  Created by 刘先 on 16/3/11.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

//MARK: - view模型
///权限设置模型
class AILimitModel : AIBaseViewModel {
    
    var limitId : Int
    var limitName: String
    var limitIcon : String
    var hasLimit : Bool
    
    init(limitId : Int , limitName : String, limitIcon : String , hasLimit : Bool){
        self.limitId = limitId
        self.limitName = limitName
        self.limitIcon = limitIcon
        self.hasLimit = hasLimit
    }
}

///派单界面服务实例模型
class AssignServiceInstModel : AIBaseViewModel {
    var serviceInstId : Int
    var serviceName : String
    var ratingLevel : Float?
    var limits : [AILimitModel]?
    
    init(serviceInstId : Int,serviceName : String,ratingLevel : Float,limits : [AILimitModel]) {
        self.serviceInstId = serviceInstId
        self.serviceName = serviceName
        self.ratingLevel = ratingLevel
        self.limits = limits
    }
}

class AITimelineModel : AIBaseViewModel {
    var timestamp : NSTimeInterval
    var id : Int
    var title : String
    var desc : String
    var status : TimelineStatus?
    
    init(timestamp : NSTimeInterval , id : Int, title : String , desc : String, status : Int){
        self.timestamp = timestamp
        self.id = id
        self.title = title
        self.desc = desc
        self.status = TimelineStatus(rawValue: status)
    }
}

//MARK: - 枚举类型
enum TimelineStatus : Int {
    case Normal,Warning
}