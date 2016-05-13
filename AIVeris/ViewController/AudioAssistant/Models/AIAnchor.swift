//
//  AIAnchor.swift
//  AIVeris
//
//  Created by 王坜 on 16/5/10.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit


enum AIAnchorType : String {
    case Before = "Before"             // 事前
    case Executing = "Executing"       // 事中
    case After = "After"               // 事后
    
    static let allValues = [Before, Executing, After]
}


struct AIAnchorKeys {
    static let Type = "Type"
    
    
}



class AIAnchor: NSObject {
    
    var type : AIAnchorType?         // 锚点类型
    var selector : String?           // 方法名
    var parameters : [AnyObject]?    // 参数列表
    
    
    
    
    
    
    class func handleAnchorWithType(type:AIAnchorType, selector:String, parameters:[AnyObject]) -> String {
        
        
        
        
        
        return ""
    }
    
    
    
    
    
    
    
}
