//
//  AIRemoteNotificationHandler.swift
//  AIVeris
//
//  Created by 王坜 on 16/5/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIRemoteNotificationHandler: NSObject {

    
    //MARK: 单例方法
    
    /**
     * 单例构造方法
     *
     */
    
    internal class func defaultHandler () -> AIRemoteNotificationHandler {
        struct AISingleton{
            static var predicate : dispatch_once_t = 0
            static var instance : AIRemoteNotificationHandler? = nil
        }
        dispatch_once(&AISingleton.predicate,{
            AISingleton.instance = AIRemoteNotificationHandler()
            }
        )
        return AISingleton.instance!
    }
    
    
    private override init() {}
    
    
    func didReceiveRemoteNotificationUserInfo(userinfo : [NSObject : AnyObject]) {
        let alertViewController = UIAlertController(title: "新消息", message: "用户Traston想购买您的打车服务，是否查看？", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            alertViewController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "NO", style: .Cancel) { (action) in
            alertViewController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertViewController.addAction(okAction)
        alertViewController.addAction(cancelAction)
        let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        rootViewController?.presentViewController(alertViewController, animated: true, completion: nil)
    }
    
    
}
