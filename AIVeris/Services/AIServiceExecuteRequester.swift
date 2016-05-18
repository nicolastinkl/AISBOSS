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
    
    func grabOrder(orderId : String, serviceId : String, customerId : String, success : (businessInfo : AIBusinessInfoModel)-> Void, fail : (errType: AINetError, errDes: String) -> Void)  {
        
        let message = AIMessage()
        let body  = ["data" : ["order_id" : orderId, "service_id" : serviceId, "customer_id" : customerId], "desc":["data_mode" : "0", "digest" : ""]]
        
        //        let body = ["data" : ["order_id" : "100000029231", "proposal_id" : "2043", "customer_id" : "100000002410"], "desc":["data_mode" : "0", "digest" : ""]]
        
        message.body.addEntriesFromDictionary(body as [NSObject : AnyObject])
        message.url = AIApplication.AIApplicationServerURL.grabOrder.description as String
        
        weak var weakSelf = self
        
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                let dic = response as! [NSObject : AnyObject]
                let originalRequirements = try AIQueryBusinessInfos(dictionary: dic)
                
                //weakSelf!.parseBusinessInfo(originalRequirements, success: success, fail: fail)
                
            } catch {
                fail(errType: AINetError.Format, errDes: AINetErrorDescription.FormatError)
            }
            
            
        }) { (error: AINetError, errorDes: String!) -> Void in
            fail(errType: error, errDes: errorDes)
        }
        
    }
    
    func parseGrabOrderResultToViewModel(){
        
    }

}