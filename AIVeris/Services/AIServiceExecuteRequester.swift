//
//  AIServiceExecuteRequester.swift
//  AIVeris
//
//  Created by 刘先 on 16/5/18.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIServiceExecuteRequester: NSObject {
    
    //MARK: 变量
    struct AINetErrorDescription {
        static let FormatError = "AIOrderPreListModel JSON Parse error."
    }
    
    
    //MARK: 单例方法
    
    class func defaultHandler () -> AIServiceExecuteRequester {
        struct AISingleton{
            static var predicate : dispatch_once_t = 0
            static var instance : AIServiceExecuteRequester? = nil
        }
        dispatch_once(&AISingleton.predicate,{
            AISingleton.instance = AIServiceExecuteRequester()
            }
        )
        return AISingleton.instance!
    }
    
    //MARK: 提交抢单请求
    /**
     orderID 	    订单id
     customID	    买家id
     proposalID      方案ID
     */
    
    func grabOrder(serviceInstId serviceInstId : String, providerId : String, success : (businessInfo : AIGrabOrderSuccessViewModel)-> Void, fail : (errType: AINetError, errDes: String) -> Void)  {
        let message = AIMessage()
        let body  = ["data" : ["service_inst_id" : serviceInstId, "provider_id" : providerId], "desc":["data_mode" : "0", "digest" : ""]]
        
        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.grabOrder.description as String
        weak var weakSelf = self
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                let dic = response as! [NSObject : AnyObject]
                let originalRequirements = try AIGrabOrderResultModel(dictionary: dic)
                
                weakSelf!.parseGrabOrderResultToViewModel(originalRequirements, success: success, fail: fail)
                
            } catch {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
            
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes)
        }
        
    }
    
    func parseGrabOrderResultToViewModel(originalRequirements : AIGrabOrderResultModel ,success : (businessInfo : AIGrabOrderSuccessViewModel)-> Void, fail : (errType: AINetError, errDes: String) -> Void){
        let result = originalRequirements.result.integerValue
        let businessInfo = AIGrabOrderSuccessViewModel(grabResult: result)
        businessInfo.setOrderInfoByJSONModel(originalRequirements)
        success(businessInfo: businessInfo)
    }
    
    
    //MARK: 查询带抢订单信息
    /**
     orderID 	    订单id
     customID	    买家id
     proposalID      方案ID
     */
    func queryGrabOrderDetail(serviceInstId : String, success : (businessInfo : AIGrabOrderDetailViewModel)-> Void, fail : (errType: AINetError, errDes: String) -> Void)  {
        let message = AIMessage()
        let body  = ["data" : ["service_inst_id" : serviceInstId ], "desc":["data_mode" : "0", "digest" : ""]]
        //        let body = ["data" : ["order_id" : "100000029231", "proposal_id" : "2043", "customer_id" : "100000002410"], "desc":["data_mode" : "0", "digest" : ""]]
        
        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.queryGrabOrderDetail.description as String
        
        weak var weakSelf = self
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            do {
                let dic = response as! [NSObject : AnyObject]
                let originalRequirements = try AIGrabOrderDetailModel(dictionary: dic)
                weakSelf!.parseGrabOrderDetailToViewModel(originalRequirements, success: success, fail: fail)
            } catch {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes)
        }
    }
    
    func parseGrabOrderDetailToViewModel(originalRequirements : AIGrabOrderDetailModel ,success : (businessInfo : AIGrabOrderDetailViewModel)-> Void, fail : (errType: AINetError, errDes: String) -> Void){
        let businessInfo = AIGrabOrderDetailViewModel.getInstanceByJSONModel(originalRequirements)
        success(businessInfo: businessInfo)
    }
    
    //MARK: 初始化任务实例
    /**
     serviceInstId 	    任务实例id
     */
    func initTask(serviceInstId : String, success : ()-> Void, fail : (errType: AINetError, errDes: String) -> Void)  {
        let message = AIMessage()
        let body  = ["data" : ["service_inst_id" : serviceInstId ], "desc":["data_mode" : "0", "digest" : ""]]
        
        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.grabOrder.description as String
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            do {
                //let dic = response as! [NSObject : AnyObject]
                success()
            } catch {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes)
        }
    }

}