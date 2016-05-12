//
//  AIRemoteNotificationHandler.swift
//  AIVeris
//
//  Created by 王坜 on 16/5/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

/**
 * 推送消息的字段名称
 *
 */
struct AIRemoteNotificationKeys {
    static let MessageKey = "alert"                         // APNS规定字段，不能修改
    static let ServiceOrderID = "ServiceOrderID"            // 待抢的服务单号
    static let Channels = "channels"                        // 频道字段，不能修改
    
}


// MARK: Advanced directional push notification

/**
 * 推送常量
 *
 */
struct AIRemoteNotificationParameters {
    static let ProviderIdentifier = "ProviderIdentifier"      // 高级定向推送给当前的Provider,用于语音协助
    static let ProviderChannel = "ProviderChannel"            // 抢单用的频道，输入gai
}


/**
 * 发送和接受远程推送通知
 *
 */
@objc class AIRemoteNotificationHandler : NSObject {

    //MARK: 单例方法
    
    /**
     * 单例构造方法
     *
     */
    
    class func defaultHandler () -> AIRemoteNotificationHandler {
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
    
    
    
    
    //MARK: 发送抢单通知
    
    /**
     * 发送抢单通知
     *
     */
    func sendGrabOrderNotification(notification : [String : AnyObject]) -> Bool {
        
        guard notification.isEmpty != true else {
            return false
        }
        
        // Create our Installation query
        let pushQuery = AVInstallation.query()
        pushQuery.whereKey("channels", equalTo: AIRemoteNotificationParameters.ProviderChannel)
        
        // Send push notification to query
        let push = AVPush()
        push.setQuery(pushQuery) // Set our Installation query
        push.setData(notification)
        push.sendPushInBackground()

        return true
    }
    
    
    //MARK: 发送语音协助通知
    
    /**
     * 发送语音协助通知
     *
     *
     */
    func sendAudioAssistantNotification(notification : [String : AnyObject], toUser : String) -> Bool {
        
        guard toUser.isEmpty != true else {
            return false
        }
        
        
        // Create our Installation query
        let pushQuery = AVInstallation.query()
        pushQuery.whereKey(AIRemoteNotificationParameters.ProviderIdentifier, equalTo: toUser)
        
        // Send push notification to query
        let push = AVPush()
        push.setQuery(pushQuery) // Set our Installation query
        push.setData(notification)
        push.sendPushInBackground()
        
        return true

    }
    
    
    //MARK: 处理远程通知
    
    /**
     * 处理远程通知
     *
     *
     */
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
    
    
    //MARK: 设置推送可用
    
    /**
     * 设置推送可用
     *
     *
     */
    func addNotificationForUser(user : String) {
        
        let installation = AVInstallation .currentInstallation()
        installation.setObject(user, forKey: AIRemoteNotificationParameters.ProviderIdentifier)
        installation.addUniqueObject(AIRemoteNotificationParameters.ProviderChannel, forKey: AIRemoteNotificationKeys.Channels)
        installation.saveInBackground()
    }
    
    
    //MARK: 取消推送功能
    
    /**
     * 取消推送功能
     *
     *
     */
    func removeNotificationForUser(user : String) {
        
        let installation = AVInstallation .currentInstallation()
        installation.removeObjectForKey(AIRemoteNotificationParameters.ProviderIdentifier)
        installation.removeObject(AIRemoteNotificationParameters.ProviderChannel, forKey: AIRemoteNotificationKeys.Channels)
        installation.saveInBackground()
    }
}
