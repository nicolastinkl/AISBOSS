//
//  AIAnchor.swift
//  AIVeris
//
//  Created by 王坜 on 16/5/10.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit



enum AIAnchorStep : String {
    case Before = "Before"             // 事前
    case Executing = "Executing"       // 事中
    case After = "After"               // 事后
    case Lock = "Lock"                 // 独占
    case UnLock = "UnLock"             // 解除独占
    static let allValues = [Before, Executing, After, Lock, UnLock]
}


enum AIAnchorType : String {
    case Touch = "Touch"             // Touch事件
    case Normal = "Normal"           // 普通Anchor事件
    case Lock = "Lock"               // Lock事件

    static let allValues = [Touch, Normal]
}


struct AIAnchorKeys {
    static let Type = "Type"
    
    
}



class AIAnchor: NSObject {
    
    var type : AIAnchorType?         // 锚点类型
    var step : AIAnchorStep?        // 锚点步骤
    var className : String?
    var selector : String?           // 方法名
    var parameters : [AnyObject]?    // 参数列表
    
    
    
    
    class func lock() -> AIAnchor {
        let anchor = AIAnchor()
        anchor.type = AIAnchorType.Lock
        anchor.step = AIAnchorStep.Lock
        
        return anchor
    }
    
    class func unLock() -> AIAnchor {
        let anchor = AIAnchor()
        anchor.type = AIAnchorType.Lock
        anchor.step = AIAnchorStep.UnLock
        
        return anchor
    }
    
    
    class func touchAnchorWithClassName(className : String, selector : String, parameters : [AnyObject]) -> AIAnchor {
        let anchor = AIAnchor()
        anchor.type = AIAnchorType.Touch
        
        return anchor
    }
    
    
    
    class func normalAnchorWithClassName(className : String, selector : String, parameters : [AnyObject]) -> AIAnchor {
        let anchor = AIAnchor()
        anchor.type = AIAnchorType.Normal
        
        return anchor
        
    }
    
    
    
    
    
    
    
}
