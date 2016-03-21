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
    
    
    func queryOriginalRequirement(params : [String : NSObject])  {
        
        
     
    }
    
    
    
    
    
    
    
    
    
    
    
}
