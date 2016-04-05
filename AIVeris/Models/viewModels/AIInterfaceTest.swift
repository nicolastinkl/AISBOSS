//
//  AIInterfaceTest.swift
//  AIVeris
//
//  Created by 王坜 on 16/3/30.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//



class AIInterfaceTest: NSObject {

    
    
    //MARK: 单例方法
    
    class func testInstance () -> AIInterfaceTest {
        struct Singleton {
            static var predicate : dispatch_once_t = 0
            static var instance : AIInterfaceTest? = nil
        }
        
        dispatch_once(&Singleton.predicate) { () -> Void in
            Singleton.instance = AIInterfaceTest()
        }
        
        return Singleton.instance!
    }
    
    
    func startText () -> Void {
        
        //AIRequirementHandler.defaultHandler().queryBusinessInfo(<#T##proposalID: NSNumber##NSNumber#>, roleType: <#T##NSNumber#>, success: <#T##(businessInfo: AIQueryBusinessInfos) -> Void#>, fail: <#T##(errType: AINetError, errDes: String) -> Void#>)
        
        
        
        
        
        
        
        
    }
    
    
    
    
}
