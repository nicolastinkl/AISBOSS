//
//  AIRequirementHandler.swift
//  AIVeris
//
//  Created by 王坜 on 16/3/21.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//


class AIRequirementHandler: NSObject {

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
    
    
    func queryOriginalRequirement(proposalID : NSNumber, roleType : NSNumber)  {
        
        let message = AIMessage()
        let body = ["data" : ["role_type" : roleType, "proposal_id" : proposalID], "data_mode" : "0", "digest" : ""]
        message.url = AIApplication.AIApplicationServerURL.queryBusinessInfo.description as String
        AINetEngine.defaultEngine().postMessage(<#T##message: AIMessage!##AIMessage!#>, success: <#T##net_success_block!##net_success_block!##(AnyObject!) -> Void#>, fail: <#T##net_fail_block!##net_fail_block!##(AINetError, String!) -> Void#>)
        
        //NSDictionary *body = @{@"data":@{@"sheme_id":@(401)},@"desc":@{@"data_mode":@"0",@"digest":@""}};
        
        
     
    }
    
    
    
    
    
    
    
    
    
    
    
}
