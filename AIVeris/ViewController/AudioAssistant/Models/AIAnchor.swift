//
//  AIAnchor.swift
//  AIVeris
//
//  Created by 王坜 on 16/5/10.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

enum AIAnchorType {
    case Before              // 事前
    case executing           // 事中
    case After               // 事后
    
}

class CustomWindow: UIWindow {
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, withEvent: event)
        return view
    }
}



class AIAnchor: NSObject {
    
    var type : AIAnchorType?         // 锚点类型
    var selector : String?           // 方法名
    var parameters : [AnyObject]?    // 参数列表
    
    
    
    
    
    
    class func handleAnchorWithType(type:AIAnchorType, selector:String, parameters:[AnyObject]) -> String {
        
        
        
        
        
        return ""
    }
    
    
    
    
    
    
    
}
