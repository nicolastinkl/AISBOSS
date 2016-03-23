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
    func queryBusinessInfo(proposalID : NSNumber, roleType : NSNumber, success : ()-> Void, fail : (errType: AINetError, errDes: String) -> Void)  {
        
        let message = AIMessage()
        let body : NSDictionary = ["data" : ["role_type" : roleType, "proposal_id" : proposalID], "data_mode" : "0", "digest" : ""]
        message.body = body as! NSMutableDictionary
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
    
    
    func parseBusinessInfo(requirements : AIQueryBusinessInfos, success : ()-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        
        
        
        
        
        
        
    }
    
    
    
    //MARK: 原始需求列表
    
    func queryOriginalRequirements(proposalID : NSNumber, roleType : NSNumber, success : ()-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let body : NSDictionary = ["data" : ["role_type" : roleType, "proposal_id" : proposalID], "data_mode" : "0", "digest" : ""]
        message.body = body as! NSMutableDictionary
        message.url = AIApplication.AIApplicationServerURL.queryBusinessInfo.description as String
        
        weak var weakSelf = self
        
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                let dic = response as! [NSObject : AnyObject]
                let originalRequirements = try AICommonRequirements(dictionary: dic)
                
                weakSelf!.parseOriginalRequirements(originalRequirements, success: success, fail: fail)
                
            } catch {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
            
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }

    }
    
    
    func parseOriginalRequirements(requirements : AICommonRequirements, success : ()-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        

        
    }
    
    
    //MARK: 直接保存为待分配状态
    
    
    func saveAsTask(requirementID : NSNumber, requirementType : String, success : ()-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let body : NSDictionary = ["data" : ["requirement_id" : requirementID, "requirement_type" : requirementType], "data_mode" : "0", "digest" : ""]
        message.body = body as! NSMutableDictionary
        message.url = AIApplication.AIApplicationServerURL.queryBusinessInfo.description as String
     
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in

            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }
    }
    
    
    //MARK: 查询待分配标签列表接口

    func queryUnassignedRequirements(proposalID : NSNumber, roleType : NSNumber, success : ()-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let body : NSDictionary = ["data" : ["role_type" : roleType, "proposal_id" : proposalID], "data_mode" : "0", "digest" : ""]
        message.body = body as! NSMutableDictionary
        message.url = AIApplication.AIApplicationServerURL.queryBusinessInfo.description as String
        
        weak var weakSelf = self
        
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                let dic = response as! [NSObject : AnyObject]
                let originalRequirements = try AICommonRequirements(dictionary: dic)
                
                weakSelf!.parseOriginalRequirements(originalRequirements, success: success, fail: fail)
                
            } catch {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
            
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }
        
    }
    
    
    func parseUnassignedRequirements(requirements : AICommonRequirements, success : ()-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        
        
        
    }

    
    //MARK: 转化为标签
    
    func saveTagsAsTask(requirementID : NSNumber, requirementType : String, tags : [NSNumber], success : ()-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let body : NSDictionary = ["data" : ["requirement_id" : requirementID, "tags_list" : tags], "data_mode" : "0", "digest" : ""]
        message.body = body as! NSMutableDictionary
        message.url = AIApplication.AIApplicationServerURL.queryBusinessInfo.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }
    }
    
    
    //MARK: 增肌新标签
    
    
    
    func addNewTag(requirementID : NSNumber, tagName : String, tagType : String, tagContent : String, success : ()-> Void, fail : (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        let body : NSDictionary = ["data" : ["requirement_id" : requirementID, "tag_name" : tagName, "tag_type" : tagType, "tag_content" : tagContent], "data_mode" : "0", "digest" : ""]
        message.body = body as! NSMutableDictionary
        message.url = AIApplication.AIApplicationServerURL.queryBusinessInfo.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }
    }
    
    //MARK: 保存新增备注
    
    
    
    
    

    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
