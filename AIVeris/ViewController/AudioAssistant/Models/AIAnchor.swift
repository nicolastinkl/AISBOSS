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
    case Hold = "Hold"                 // 独占
    case UnHold = "UnHold"             // 解除独占
    static let allValues = [Before, Executing, After, Hold]
}


enum AIAnchorType : String {
    case Touch = "Touch"             // Touch事件
    case Normal = "Normal"           // 普通Anchor事件

    static let allValues = [Touch, Normal]
}

class CustomWindow: UIWindow {
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, withEvent: event)
        return view
    }
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
    
    
    
    
    
    
    class func handleAnchorWithType(type:AIAnchorType, selector:String, parameters:[AnyObject]) -> String {
        
        
        
        
        
        return ""
    }
    
    
    
    
    
    
    
}
