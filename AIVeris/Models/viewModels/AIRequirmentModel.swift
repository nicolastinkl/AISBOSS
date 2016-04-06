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
    
    var limitId : String
    var limitName: String
    var limitIcon : String
    var hasLimit : Bool
    
    init(limitId : String , limitName : String, limitIcon : String , hasLimit : Bool){
        self.limitId = limitId
        self.limitName = limitName
        self.limitIcon = limitIcon
        self.hasLimit = hasLimit
    }
    
    //根据拥有权限的id列表输出当前权限是否拥有
    func handleHasLimitWith(ownRightList : NSArray) -> Bool{
        for ownRight in ownRightList{
            let ownRightString = (ownRight as! NSNumber).stringValue
            if self.limitId == ownRightString{
                return true
            }
        }
        return false
    }
}

//把权限列表设置的view抽象出来，还能用于filter选择
class AIPopupChooseModel : AIBaseViewModel{
    var itemId : String
    var itemTitle : String
    var itemIcon : String
    var isSelect : Bool
    
    init(itemId : String, itemTitle : String , itemIcon : String , isSelect : Bool){
        self.itemId = itemId
        self.itemTitle = itemTitle
        self.itemIcon = itemIcon
        self.isSelect = isSelect
    }
    
}

///派单界面服务实例模型
class AssignServiceInstModel : AIBaseViewModel {
    var serviceInstId : Int!
    var serviceName : String!
    var ratingLevel : Float?
    var serviceInstStatus : ServiceInstStatus!
    var customerUserId : Int!
    var limits : [AILimitModel]?
    
    override init() {
        ratingLevel = 10
        limits = [AILimitModel]()
        customerUserId = 0
        super.init()
    }
    
    init(serviceInstId : Int,serviceName : String,ratingLevel : Float,serviceInstStatus : ServiceInstStatus , limits : [AILimitModel]) {
        self.serviceInstId = serviceInstId
        self.serviceName = serviceName
        self.ratingLevel = ratingLevel
        self.serviceInstStatus = serviceInstStatus
        self.limits = limits
    }
    
    class func getInstanceArray(jsonModel : AIQueryBusinessInfos) -> [AssignServiceInstModel]{
        var assignServiceInstModels = [AssignServiceInstModel]()
        for serviceInstJSONModel : AIServiceProvider in jsonModel.rel_serv_rolelist as! [AIServiceProvider]{
            let assignServiceInst = AssignServiceInstModel()
            //TODO 这里需要的是serviceInstId
            assignServiceInst.serviceInstId = serviceInstJSONModel.relservice_id.integerValue
            assignServiceInst.serviceName = serviceInstJSONModel.relservice_name
            assignServiceInst.ratingLevel = serviceInstJSONModel.service_rating_level?.floatValue
            assignServiceInst.customerUserId = serviceInstJSONModel.reluser_id.integerValue
            let jsonModelProgress = serviceInstJSONModel.relservice_progress as NSDictionary
            let statusInt = jsonModelProgress.objectForKey("status") as! Int
            
            let status = ServiceInstStatus(rawValue: statusInt)
            assignServiceInst.serviceInstStatus = status
            //给limits赋值
            
            for limitJSONModel : AIServiceRights in jsonModel.right_list as! [AIServiceRights] {
                let limit = AILimitModel(limitId: limitJSONModel.right_id, limitName: limitJSONModel.right_value, limitIcon: "", hasLimit: false)
                let ownRightList = serviceInstJSONModel.own_right_id as NSArray
                
                limit.hasLimit = limit.handleHasLimitWith(ownRightList)
                assignServiceInst.limits?.append(limit)
            }
            assignServiceInstModels.append(assignServiceInst)
        }
        
        return assignServiceInstModels
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
    var serviceInstId : Int!
    var serviceIcon : String!
    var serviceInstStatus : ServiceInstStatus!
    var executeProgress : Int!
    var isSelected : Bool = false
    
    override init() {
        super.init()
    }
    
    init(serviceInstId : Int , serviceIcon : String , serviceInstStatus : ServiceInstStatus , executeProgress : Int){
        self.serviceInstId = serviceInstId
        self.serviceIcon = serviceIcon
        self.serviceInstStatus = serviceInstStatus
        self.executeProgress = executeProgress
    }
    
    class func getInstanceArray(jsonModel : AIQueryBusinessInfos) -> [IconServiceIntModel]{
        var iconServiceInstArray = [IconServiceIntModel]()
        for serviceInst : AIServiceProvider in jsonModel.rel_serv_rolelist as! [AIServiceProvider]{
            let iconServiceInst = IconServiceIntModel()
            iconServiceInst.serviceIcon = serviceInst.provider_portrait_url
            iconServiceInst.serviceInstId = serviceInst.relservice_id.integerValue
            let jsonModelProgress = serviceInst.relservice_progress as NSDictionary
            let statusInt = jsonModelProgress.objectForKey("status") as! Int
            
            let status = ServiceInstStatus(rawValue: (statusInt + 0))
            iconServiceInst.serviceInstStatus = status
            let progress = (jsonModelProgress.objectForKey("percentage") as! Int) * 100
            iconServiceInst.executeProgress = progress
            iconServiceInstArray.append(iconServiceInst)
        }
        return iconServiceInstArray
    }
    
    ///判断是否需要派单
    class func isAllLanched(models : [IconServiceIntModel]) -> Bool {
        for model in models{
            if model.serviceInstStatus == ServiceInstStatus.Init {
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
    case Init = -1 ,Assigned = 100, Error = 101,Finished = 102
}



