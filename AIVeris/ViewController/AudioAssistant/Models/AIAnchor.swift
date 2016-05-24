//
//  AIAnchor.swift
//  AIVeris
//
//  Created by 王坜 on 16/5/10.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit



struct AIAnchorStep {
    static let Before = "Before"             // 事前
    static let Executing = "Executing"       // 事中
    static let After = "After"               // 事后
    static let Lock = "Lock"                 // 独占
    static let UnLock = "UnLock"             // 解除独占
    static let allValues = [Before, Executing, After, Lock, UnLock]
}


struct AIAnchorType {
    static let Touch = "Touch"             // Touch事件
    static let Normal = "Normal"           // 普通Anchor事件
    static let Lock = "Lock"               // Lock事件

    static let allValues = [Touch, Normal, Lock]
}


struct AIAnchorKeys {
    static let Type = "Type"
    static let ClassName = "ClassName"
    static let UIComponent = "UIComponent"
    static let Selector = "Selector"
    static let RowIndex = "RowIndex"
    static let PageIndex = "PageIndex"
}



struct AIAnchorUIComponent {
    static let DTableCell = "Table"
    static let DTableCellConfigure = "TableCellConfigure"
    static let DTableCellSwipe = "DTableCellSwipe"
}




protocol Reflectable {
    func propertys()->[String]
}


extension Reflectable
{
    func propertys()->[String]{
        var s = [String]()
        for c in Mirror(reflecting: self).children
        {
            if let name = c.label{
                s.append(name)
            }
        }
        return s
    }
    
    
}


protocol AnchorProcess {
    func processAnchor(anchor : AIAnchor)
}

class AIAnchor: NSObject {
    
    var type : String?                // 锚点类型
    var step : String?                // 锚点步骤
    var viewQuery: String?
    var className : String?
    var selector : String?            // 方法名
    var parameters : [AnyObject]?     // 参数列表
    
    
    //
    var rootViewControllerName : String?
    var viewComponentName : String?
    var rowIndex : NSInteger?
    var sectionIndex : NSInteger?
    var pageIndex : NSInteger?
    var locationX : CGFloat?
    var locationY : CGFloat?
    //
    var logoIndex : NSInteger?
    // 
    var scrollOffsetX : CGFloat?
    var scrollOffsetY : CGFloat?
    var scrollTableName : String?
    
    class func lock() -> AIAnchor {
        let anchor = AIAnchor()
        anchor.type = AIAnchorType.Lock
        anchor.step = AIAnchorStep.Lock
        
        AudioAssistantManager.sharedInstance.sendAnchor(anchor)
        
        return anchor
    }
    
    class func unLock() -> AIAnchor {
        let anchor = AIAnchor()
        anchor.type = AIAnchorType.Lock
        anchor.step = AIAnchorStep.UnLock
        AudioAssistantManager.sharedInstance.sendAnchor(anchor)
        return anchor
    }
    
    class func touchAnchor(anchor : [String : AnyObject]) -> AIAnchor {
        let anchor = AIAnchor()
        anchor.type = AIAnchorType.Touch
        AudioAssistantManager.sharedInstance.sendAnchor(anchor)

        return anchor
    }
    
    
    class func touchAnchorWithClassName(className : String?, selector : String?, parameters : [AnyObject]?) -> AIAnchor {
        let anchor = AIAnchor()
        anchor.type = AIAnchorType.Touch
        AudioAssistantManager.sharedInstance.sendAnchor(anchor)
        anchor.className = className
        anchor.selector = selector
        anchor.parameters = parameters
        return anchor
    }
    
    
    
    class func beforeAnchorWithClassName(className : String?, selector : String?, parameters : [AnyObject]?) -> AIAnchor {
        let anchor = AIAnchor()
        anchor.type = AIAnchorType.Normal
        anchor.step = AIAnchorStep.Before
        anchor.className = className
        anchor.selector = selector
        anchor.parameters = parameters
        AudioAssistantManager.sharedInstance.sendAnchor(anchor)
        return anchor
        
    }
    
    class func executingAnchorWithClassName(className : String?, selector : String?, parameters : [AnyObject]?) -> AIAnchor {
        let anchor = AIAnchor()
        anchor.type = AIAnchorType.Normal
        anchor.step = AIAnchorStep.Executing
        anchor.className = className
        anchor.selector = selector
        anchor.parameters = parameters
        AudioAssistantManager.sharedInstance.sendAnchor(anchor)
        return anchor
        
    }
    
    
    class func afterAnchorWithClassName(className : String?, selector : String?, parameters : [AnyObject]?) -> AIAnchor {
        let anchor = AIAnchor()
        anchor.type = AIAnchorType.Normal
        anchor.step = AIAnchorStep.After
        anchor.className = className
        anchor.selector = selector
        anchor.parameters = parameters
        AudioAssistantManager.sharedInstance.sendAnchor(anchor)
        
        return anchor
        
    }
    
    
    class func anchorFromJsonString(jsonString : String) -> AIAnchor {
        
        let anchor = AIAnchor()
        
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {

            do {
                
                let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
                if let model = jsonObject as? [String : AnyObject] {

                    anchor.type = model["type"] as? String
                    anchor.step = model["step"] as? String
                    anchor.className = model["className"] as? String
                    anchor.viewQuery = model["viewQuery"] as? String
                    anchor.selector = model["selector"] as? String
                    anchor.parameters = model["parameters"] as? [AnyObject]
                }
            }
            catch let JSONError as NSError {
                print("json parse error --" + "\(JSONError)")
            }
        }

        return anchor
    }
    
    
    func toJsonString() -> String {
        return JSONSerializer.toJson(self)
    }
    
    
    
    
    
    
}

extension AIAnchor : Reflectable {
    
}

extension AIAnchor {
    func send() {
        AudioAssistantManager.sharedInstance.sendAnchor(self)
    }
}

