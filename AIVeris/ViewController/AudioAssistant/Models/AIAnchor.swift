//
//  AIAnchor.swift
//  AIVeris
//
//  Created by 王坜 on 16/5/10.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

typealias AIAnchorStep = String
typealias AIAnchorType = String

//enum AIAnchorStep : String {
//    case Before = "Before"             // 事前
//    case Executing = "Executing"       // 事中
//    case After = "After"               // 事后
//    case Hold = "Hold"                 // 独占
//    case UnHold = "UnHold"             // 解除独占
//    static let allValues = [Before, Executing, After, Hold]
//}

extension AIAnchorStep {
    static let Normal = "Normal"
}

class CustomWindow: UIWindow {
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, withEvent: event)
        return view
    }
}
//
//enum AIAnchorType : String {
//    case Touch = "Touch"             // Touch事件
//    case Normal = "Normal"           // 普通Anchor事件
//
//    static let allValues = [Touch, Normal]
//}


struct AIAnchorKeys {
    static let Type = "Type"
    
    
}




struct AIAnchor: JSONJoy {
    
    var type : AIAnchorType?         // 锚点类型
    var step : AIAnchorStep?        // 锚点步骤
    var className : String?
    var selector : String?           // 方法名
    var parameters : [AnyObject]?    // 参数列表
    
    
    init(_ decoder: JSONDecoder)  {
        type = decoder["type"].string
        step = decoder["step"].string
        className = decoder["className"].string
        selector = decoder["selector"].string
        parameters =  decoder["parameters"].array
    }
    
    init() {}
    
    
    static func handleAnchorWithType(type:AIAnchorType, selector:String, parameters:[AnyObject]) -> String {
        
        
        
        
        
        return ""
    }
    
    
    
    
    
    
    
}
