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

class AIAnchorOperation: NSOperation {
    var anchor: AIAnchor
    
    init(anchor: AIAnchor) {
        self.anchor = anchor
        super.init()
        self.completionBlock = {
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIRemoteAssistantConnectionStatusChangeNotificationName, object: nil)
        }
    }
    var time: UInt32 = 0
    private var _isFinished: Bool = false
    
    override var asynchronous: Bool {
        return false
    }
    
    override var finished: Bool {
        get {
            return cancelled ? true : _isFinished
        }
        set {
            willChangeValueForKey("finished")
            _isFinished = newValue
            didChangeValueForKey("finished")
        }
    }
    
    // MARK: - NSOperation
    override func main() {
        if time > 0 {
            let global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            dispatch_async(global, { [weak self] in
                sleep((self?.time)!)
                self?.finished = true
            })
        }
    }
}

extension UIButton: AIAnchorProtocal {
    func anchor() -> AIAnchor {
        let result = AIAnchor()
        result.className = "";
        result.viewComponentName = superview?.instanceClassName()
        return result
    }
}

protocol AIAnchorProtocal {
    func anchor() -> AIAnchor
}

class AIAnchor: NSObject {
    
    var className: String?
    var connectionId: String!
    var locationX : CGFloat?
    var locationY : CGFloat?
    var logoIndex : NSInteger?
    var pageIndex : NSInteger?
    var parameters: [AnyObject]?     // 参数列表
    var rootViewControllerName : String?
    var rowIndex : NSInteger?
    var scrollOffsetX : CGFloat?
    var scrollOffsetY : CGFloat?
    var scrollTableName : String?
    var sectionIndex : NSInteger?
    var selector: String?            // 方法名
    var step: String?                // 锚点步骤
    var type: String?                // 锚点类型
    var viewComponentName : String?
    class func anchorFromJSONString(jsonString : String) -> AIAnchor {
        
        let anchor = AIAnchor()
        
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
            
            do {
                
                let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
                if let model = jsonObject as? [String : AnyObject] {
                    anchor.className = model["className"] as? String
                    anchor.connectionId = model["connectionId"] as? String
                    anchor.locationX  = model["locationX"] as? CGFloat
                    anchor.locationY  = model["locationY"] as? CGFloat
                    anchor.logoIndex  = model["logoIndex"] as? NSInteger
                    anchor.pageIndex  = model["pageIndex"] as? NSInteger
                    anchor.parameters = model["parameters"] as? [AnyObject]
                    anchor.rootViewControllerName = model["rootViewControllerName"] as? String
                    anchor.rowIndex = model["rowIndex"] as? NSInteger
                    anchor.scrollOffsetX  = model["scrollOffsetX"] as? CGFloat
                    anchor.scrollOffsetY  = model["scrollOffsetY"] as? CGFloat
                    anchor.scrollTableName  = model["scrollTableName"] as? String
                    anchor.sectionIndex = model["sectionIndex"] as? NSInteger
                    anchor.selector = model["selector"] as? String
                    anchor.step = model["step"] as? String
                    anchor.type = model["type"] as? String
                    anchor.viewComponentName = model["viewComponentName"] as? String
                }
            }
            catch let JSONError as NSError {
                print("json parse error --" + "\(JSONError)")
            }
        }
        
        return anchor
    }
    
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
    
    

    
    func toJSONString() -> String {
        return JSONSerializer.toJson(self)
    }
}

extension AIAnchor : Reflectable {}

extension AIAnchor {
    func send() {
        AudioAssistantManager.sharedInstance.sendAnchor(self)
    }
}

