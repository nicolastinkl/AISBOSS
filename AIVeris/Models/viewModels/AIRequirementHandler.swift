//
//  AIRequirementHandler.swift
//  AIVeris
//
//  Created by 王坜 on 16/3/21.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//


class AIRequirementHandler: NSObject {

    //MARK: 变量
    
    struct AINetErrorDescription {
        static let FormatError = "AIOrderPreListModel JSON Parse error."
    }
    
    
    //MARK: 单例方法
    
    class func defaultHandler () -> AIRequirementHandler {
        struct AISingleton{
            static var predicate : dispatch_once_t = 0
            static var instance : AIRequirementHandler? = nil
        }
        dispatch_once(&AISingleton.predicate,{
            AISingleton.instance = AIRequirementHandler()
            }
        )
        return AISingleton.instance!
    }
    
    //MARK: 基本信息查询
    /**
    orderID 	    订单id
    customID	    买家id
    proposalID      方案ID
    */
    
    func queryBusinessInfo(proposalID : NSNumber, customID : NSNumber, orderID : NSNumber, success : (businessInfo : AIBusinessInfoModel)-> Void, fail : (errType: AINetError, errDes: String) -> Void)  {
        
        let message = AIMessage()
        let body  = ["data" : ["order_id" : orderID, "proposal_id" : proposalID, "customer_id" : customID], "desc":["data_mode" : "0", "digest" : ""]]
        
//        let body = ["data" : ["order_id" : "100000029231", "proposal_id" : "2043", "customer_id" : "100000002410"], "desc":["data_mode" : "0", "digest" : ""]]
        
        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.queryBusinessInfo.description as String
        
        weak var weakSelf = self
        
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                let dic = response as! [NSObject : AnyObject]
                let originalRequirements = try AIQueryBusinessInfos(dictionary: dic)
                
                weakSelf!.parseBusinessInfo(originalRequirements, success: success, fail: fail)
               
            } catch {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
            
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }

     
    }
    
    
    func parseBusinessInfo(requirements : AIQueryBusinessInfos, success : (businessInfo : AIBusinessInfoModel)-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        
        ///  左侧服务图片列表
        let iconServiceInst = IconServiceIntModel.getInstanceArray(requirements)
        let assignServiceInstModels = AssignServiceInstModel.getInstanceArray(requirements)
        let parsedBusinessInfo = AIBusinessInfoModel()
        
        parsedBusinessInfo.serviceModels = iconServiceInst
        parsedBusinessInfo.assignServiceInstModels = assignServiceInstModels
        parsedBusinessInfo.customerModel = BuyerOrderModel.getInstance(requirements)
        parsedBusinessInfo.baseJsonValue = requirements
        
        success(businessInfo: parsedBusinessInfo)
    }
    
    
    
    //MARK: 原始需求列表
    /**
    customID	      买家用户id
    orderID     	  服务ID

    */
    func queryOriginalRequirements(customID : Int, orderID : Int, success : (requirements : [AIContentCellModel])-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let body : NSDictionary = ["data" : ["customer_id" : customID, "customerOrderId" : orderID], "desc":["data_mode" : "0", "digest" : ""]]
        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.queryOriginalRequirements.description as String
        
        //weak var weakSelf = self
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            if let responseJSON: AnyObject = response{
                
                let dic = responseJSON as! [NSString : AnyObject]
                let jsondata = JSONDecoder(dic)
                var arrayContent = Array<AIContentCellModel>()
                
                for dicData in jsondata["requirement_list"].array ?? [] {
                    let dataContent = AIContentCellModel(dicData)
                    arrayContent.append(dataContent)
                }
                success(requirements: arrayContent)
                
            }else{
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
            
            /*
            do {
                let dic = response as! [NSObject : AnyObject]
                let originalRequirements = try AIOriginalRequirementsList(dictionary: dic)
                
                weakSelf!.parseOriginalRequirements(originalRequirements, success: success, fail: fail)
                
            } catch {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
            */
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }

    }
    
    
    func parseOriginalRequirements(requirements : AIOriginalRequirementsList, success : (requirements : AIOriginalRequirementsList)-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        
        success(requirements: requirements)
        
    }
    
    /**
     转化状态
     
     - parameter type: type
     
     - returns: type right
     */
    func getReType(type: String) -> String{
        if type == "notes"{
            return "WishNote"
        }else if type == "tags"{
            return "WishTag"
        }else if type == "task"{
            return "TaskNode"
        }else if type == "userData"{
            return "UserData"
        }
        
        return ""
    }
    
    //MARK: 直接保存为待分配状态
    
    /**
    providerID	        复合服务提供者ID
    customID	        买家ID
    orderID   	        订单ID
    requirementType	    原始需求条目类型
    requirementID	    原始需求ID
    toType	            订单ID
    requirementList		传入需要转化的原始需求id
    */

    
    func saveAsTask(providerID : String, customID : String, orderID : String, requirementID : String, requirementType : String, toType : String, requirementList : NSArray, success : (unassignedNum : NSNumber)-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        let body : NSDictionary = ["data" : ["comp_user_id" : providerID, "customer_id" : customID, "order_id" : orderID, "requirement_type" : getReType(requirementType), "requirement_id" : requirementID, "analysis_type" : getReType(toType), "analysis_ids" : requirementList], "desc":["data_mode" : "0", "digest" : ""]]
        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.saveAsTask.description as String
     
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            let code : NSNumber = response["result_code"] as! NSNumber
            if code == NSNumber(integer: 1) {
//                let unassignedNum : NSNumber = response["distribution_count"] as! NSNumber
//                success(unassignedNum: unassignedNum)
                success(unassignedNum: NSNumber(integer: 1))
            }else{
                success(unassignedNum: NSNumber(integer: 0))
            }

            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }
    }
    
    
    //MARK: 查询待分配标签列表接口
    /**
    orderId	服务方案ID列表  order_Id
    analyser_id	分析者Id           comp_user_id
    customer_id	客户Id             customer.customer_id

    */

    func queryUnassignedRequirements(orderId : NSNumber, providerID : NSNumber, customID : NSNumber, success : (requirements : [AIContentCellModel])-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let body : NSDictionary = ["data" : [
            "custOrder_id" : orderId,
            "analyser_id" : providerID,
            "customer_id" : customID,
            "isHandled":true],
            "desc":["data_mode" : "0", "digest" : ""]]
       /*
        body   = ["data" : [
        "custOrder_id" : 100000029231,
        "analyser_id" : 1,
        "customer_id" : 1,
        "isHandled":true],
        "desc":["data_mode" : "0", "digest" : ""]]
        */
        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.queryUnassignedRequirements.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            if let responseJSON: AnyObject = response{

                let dic = responseJSON as! [NSString : AnyObject]
                let jsondata = JSONDecoder(dic)
                var arrayContent = Array<AIContentCellModel>()
                
                for dicData in jsondata["requirement_list"].array ?? [] {
                    let dataContent = AIContentCellModel(dicData)
                    arrayContent.append(dataContent)
                }
                success(requirements: arrayContent)
                
                
            }else{
                 fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
            
            /*
            do {
                //let originalRequirements = try AIOriginalRequirementsList(dictionary: dic)
            
                //weakSelf!.parseOriginalRequirements(originalRequirements, success: success, fail: fail)
                
            } catch {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }*/
            
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }
        
    }
    
    
    func parseUnassignedRequirements(requirements : AIOriginalRequirementsList, success : (requirements : AIOriginalRequirementsList)-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        
        success(requirements: requirements)
        
    }

    
    //MARK: 转化为标签
    /**
    comp_user_id	    复合服务提供者ID
    customer_id	        买家ID
    order_id	        订单ID
    requirement_type	原始需求条目类型
    requirement_id	    原始需求ID
    analysis_type	    订单ID
    analysis_ids
    */
    
    func saveTagsAsTask(comp_user_id : String, customer_id : String, order_id : String, requirement_id : String, requirement_type : String, analysis_type : String, analysis_ids : NSArray, success : (unassignedNum : NSNumber)-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let body : NSDictionary = ["data" : ["comp_user_id" : comp_user_id, "customer_id" : customer_id, "order_id" : order_id, "requirement_type" : requirement_type, "requirement_id" : requirement_id, "analysis_type" : analysis_type, "analysis_ids" : analysis_ids], "desc":["data_mode" : "0", "digest" : ""]]
        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.saveTagsAsTask.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            let code : NSNumber = response["result_code"] as! NSNumber
            if code == NSNumber(integer: 1) {
                let unassignedNum : NSNumber = response["distribution_count"] as! NSNumber
                success(unassignedNum: unassignedNum)
            }
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }
    }
    
    
    //MARK: 增加新标签
    /**
    tag_type	标签类型
    tag_content	标签内容
    service_id
    */
    
    
    func addNewTag(service_id : String, tag_type : String, tag_content : String, success : (newTag : AIDefaultTag)-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let body : NSDictionary = ["data" : ["service_id" : service_id, "tag_type" : tag_type, "tag_content" : tag_content], "desc":["data_mode" : "0", "digest" : ""]]
        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.addNewTag.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            let tag = AIDefaultTag()
            tag.tag_id = response["tag_id"] as! NSNumber
            tag.tag_content = response["tag_content"] as! String
            success(newTag: tag)
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }
    }
    
    //MARK: 保存新增备注
    /**
    comp_user_id	复合服务提供者ID
    customer_id	买家ID
    order_id	订单ID
    requirement_type	原始需求条目类型
    requirement_id	原始需求ID
    analysis_type	订单ID
    note_content	备注文本
    */
    
    func addNewNote(comp_user_id : String, customer_id : String, order_id : String, requirement_id : String, requirement_type : String, analysis_type : String, note_content : String, success : (unassignedNum : NSNumber)-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let body : NSDictionary = ["data" : ["comp_user_id" : comp_user_id, "customer_id" : customer_id, "order_id" : order_id, "requirement_type" : requirement_type, "requirement_id" : requirement_id, "analysis_type" : analysis_type, "note_content" : note_content], "desc":["data_mode" : "0", "digest" : ""]]
        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.addNewNote.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            let code : NSNumber = response["result_code"] as! NSNumber
            if code == NSNumber(integer: 1) {
                let unassignedNum : NSNumber = response["distribution_count"] as! NSNumber
                success(unassignedNum: unassignedNum)
            }
            else
            {
                fail(errType: AINetError.Failed, errDes: "save error")
            }
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }
    }
    
    
    //MARK: 增加新的任务节点
    /**
    comp_user_id	复合服务提供者ID
    customer_id	买家ID
    order_id	订单ID
    requirement_type	原始需求条目类型
    requirement_id	原始需求ID
    analysis_type	订单ID
    task_desc	节点描述
    offset_time	偏移的时间量
    node_id	参考节点ID
    arrangement_id	参考节点所属流程ID
    
    
    
    */
    
    func addNewTask(comp_user_id : String,
        customer_id : String,
        order_id : String,
        requirement_id : String,
        requirement_type : String,
        analysis_type : String,
        task_desc : String,
        offset_time : String,
        node_id : String,
        arrangement_id : String,
        success : (unassignedNum : NSNumber)-> Void,
        fail : (errType: AINetError, errDes: String) -> Void) {
            
        let message = AIMessage()
        let body : NSDictionary = ["data" : ["comp_user_id" : comp_user_id, "customer_id" : customer_id, "order_id" : order_id, "requirement_type" : requirement_type, "requirement_id" : requirement_id, "analysis_type" : analysis_type, "task_desc" : task_desc, "offset_time" : offset_time, "node_id" : node_id, "arrangement_id" : arrangement_id], "desc":["data_mode" : "0", "digest" : ""]]
        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.addNewTask.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            let code : NSNumber = response["result_code"] as! NSNumber
            if code == NSNumber(integer: 1) {
                let unassignedNum : NSNumber = response["distribution_count"] as! NSNumber
                success(unassignedNum: unassignedNum)
            }
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }
    }
    
    
    
    //MARK: 设置权限
    /**
    providerID	服务提供者id
    customID	用户Id
    rightsList	权限内容列表

    */

    func setServiceProviderRights(providerID : NSNumber, customID : NSNumber, serviceInstId : NSNumber , rightsList : [NSNumber], success : ()-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let body : NSDictionary = ["data" : ["provider_id" : providerID, "permission_list" : rightsList, "customer_id" : customID , "service_inst_id" : serviceInstId], "desc":["data_mode" : "0", "digest" : ""]]
        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.setServiceProviderRights.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            success()
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }
    }
    
    
    
    //MARK: 派单
    /**
    work_order_param_list	工作单ID列表
    service_inst_id         服务实例ID
    
    provider_user_id        接受者ID
    
    */

    func assginTask(taskList : [NSDictionary], success : ()-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let body : NSDictionary = ["data" : ["work_order_param_list" : taskList], "desc":["data_mode" : "0", "digest" : ""]]
        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.assginTask.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            success()
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }
    }
    
    
    
    
    
    
    //MARK: 查询子服务默认标签列表
    /**
     serviceID 服务id
     */
    
    func queryServiceDefaultTags(serviceID : String, success : (tagsModel : OriginalTagsModel)-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let body : NSDictionary = ["data" : ["service_id" : serviceID], "desc":["data_mode" : "0", "digest" : ""]]
        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.queryServiceDefaultTags.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in

            let tagList : NSArray = NSArray(array: response as! NSArray)
 
            var returnTags = [RequirementTag]()
            
            for i in 0 ... tagList.count - 1 {
              
                do {
                    let tag : AIDefaultTag = try AIDefaultTag(dictionary: tagList[i] as! [NSObject : AnyObject])
                    let rTag = RequirementTag(id: tag.tag_id.integerValue,selected:false, textContent: tag.tag_content)
                    //rTag.id
                    returnTags.append(rTag)
                } catch {
                    
                }
                
                
            }
            
            var tagsModel = OriginalTagsModel()
            tagsModel.tagList = returnTags
    
            success(tagsModel: tagsModel)
 
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }
    }
     
    //MARK: 将需求共享给其它子服务
    /**
    serviceID 服务id
    */
    
    func distributeRequirementRequset(wish_result_id : String,wish_item_type: String,wish_item_id:String,service_inst_id: Array<String>, success : ()-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        
        let body : NSDictionary = ["data" : ["wish_result_id" : wish_result_id,"wish_item_type":wish_item_type,"wish_item_id":wish_item_id,"service_inst_id":service_inst_id], "desc":["data_mode" : "0", "digest" : ""]]

        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.distributeRequirement.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
                success()            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }
    }
    
    //MARK: 查询任务节点
    /**
    service_inst_list    服务实例ID列表
    
    */
    func queryTaskList(serviceInstanceID : String, serviceIcon : String, success : (task : DependOnService)-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        
        let body : NSDictionary = ["data" : ["service_inst_list" : [serviceInstanceID]], "desc":["data_mode" : "0", "digest" : ""]]
        
        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.queryTaskList.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            var task = DependOnService(id: serviceInstanceID, icon: serviceIcon, desc: "", tasks: [TaskNode](), selected: false)
            
            
            if let list = response["task_node_list"] as? [NSDictionary] {
                
                if list.count > 0 {
                    for i in 0 ... list.count - 1 {
                        
                        let node : NSDictionary = list[i]
                        
                        let date : NSNumber = node["timestamp"] as! NSNumber
                        let insID : String = "\(node["service_inst_id"])"
                        let arrageID : String = node["arrangement_id"] as! String
                        
                        let taskNode = TaskNode(date: NSDate(timeIntervalSinceNow: date.doubleValue), desc: node["node_desc"] as! String, id: node["task_node_id"]!.integerValue, insID: insID, arrageID : arrageID)
                        
                        task.tasks.append(taskNode)
                        task.desc = node["node_summary"] as! String
                        
                    }
                }
 
            }

            success(task: task)
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }

    }
    
    
    
    
    
    
    
    
    

}
