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

//把权限列表设置的view抽象出来，还能用于filter选择
class AIPopupChooseModel : AIBaseViewModel{
    var itemId : Int
    var itemTitle : String
    var itemIcon : String
    var isSelect : Bool
    
    init(itemId : Int, itemTitle : String , itemIcon : String , isSelect : Bool){
        self.itemId = itemId
        self.itemTitle = itemTitle
        self.itemIcon = itemIcon
        self.isSelect = isSelect
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

//MARK: - 服务实例模型
class IconServiceIntModel : AIBaseViewModel{
    var serviceInstId : Int
    var serviceIcon : String
    var serviceInstStatus : Int
    var executeProgress : Int
    var isSelected : Bool = false
    
    init(serviceInstId : Int , serviceIcon : String , serviceInstStatus : Int , executeProgress : Int){
        self.serviceInstId = serviceInstId
        self.serviceIcon = serviceIcon
        self.serviceInstStatus = serviceInstStatus
        self.executeProgress = executeProgress
    }
    
    ///判断是否需要派单
    class func isAllLanched(models : [IconServiceIntModel]) -> Bool {
        for model in models{
            let statusEnum = ServiceInstStatus(rawValue: model.serviceInstStatus)
            if statusEnum == ServiceInstStatus.Init {
                return true
            }
        }
        return false
    }
}


//MARK: - 枚举类型
enum TimelineStatus : Int {
    case Normal,Warning
}

enum ServiceInstStatus : Int {
    case Init,Assigned
}


//MARK: 基本信息模型

class AIBusinessInfoModel: AIBaseViewModel {
    //var serviceModels : IconServiceIntModel
    
}



