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
    static let NotificationType = "NotificationType"                                // 通知类型
    static let ProposalID = "ProposalID"
    static let ProposalName = "ProposalName"
}


// MARK: Advanced directional push notification

/**
 * 推送常量
 *
 */
struct AIRemoteNotificationParameters {
    static let ProviderIdentifier = "ProviderIdentifier"      // 高级定向推送给当前的Provider,用于语音协助
    static let ProviderChannel = "ProviderChannel"            // 抢单用的频道，输入gai
    static let GrabOrderType = "GrabOrderType"
    static let AudioAssistantType = "AudioAssistantType"
    static let AudioAssistantRoomNumber = "AudioAssistantRoomNumber"
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
        pushQuery.whereKey(AIRemoteNotificationKeys.Channels, equalTo: AIRemoteNotificationParameters.ProviderChannel)
        
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
        push.setChannels(["ProviderChannel"])
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
        
        //如果是抢单通知
        let key = AIRemoteNotificationKeys.NotificationType
        let msgDic : Dictionary = userinfo["aps"] as! Dictionary<String , AnyObject>
        print("\(msgDic)")
        if let value = userinfo[key] as? String{
            if value == AIRemoteNotificationParameters.GrabOrderType {
                AIApplication.showAlertView()
            }
            else if value == AIRemoteNotificationParameters.AudioAssistantType {
                // 语音协助的 接受
                let topVC = topViewController()

                let roomNumber = userinfo[AIRemoteNotificationParameters.AudioAssistantRoomNumber] as! String
                let proposalID = userinfo[AIRemoteNotificationKeys.ProposalID] as! Int
                let proposalName = userinfo[AIRemoteNotificationKeys.ProposalName] as! String
                
                AudioAssistantManager.sharedInstance.connectionStatus = .Dialing
                
                let buyerDetailViewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIBuyerDetailViewController) as! AIBuyerDetailViewController
                
                let model = AIBuyerBubbleModel()
                model.proposal_id = proposalID
                model.proposal_name = proposalName
                buyerDetailViewController.bubbleModel = model
                buyerDetailViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                buyerDetailViewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
                buyerDetailViewController.isLaunchForAssistant = true
                buyerDetailViewController.roomNumber = String(format: "%d", roomNumber)
                
                topVC.presentViewController(buyerDetailViewController, animated: false, completion: {
                    let vc = AAProviderDialogViewController.initFromNib()
                    vc.roomNumber = roomNumber
                    vc.proposalID = proposalID
                    vc.proposalName = proposalName
                    buyerDetailViewController.providerDialogViewController = vc
                    buyerDetailViewController.presentViewController(vc, animated: true, completion: nil)
                })
            }
        }
    }
    
    
    func showBuyerDetailViewController(model : AIBuyerBubbleModel) {
        let topVC = topViewController()
        
        
        guard topVC.presentedViewController == nil else {
            return
        }
        

        
        
//        
//        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIBuyerDetailViewController) as! AIBuyerDetailViewController
//        
//        let model = AIBuyerBubbleModel()
//        model.proposal_id = proposalID
//        model.proposal_name = proposalName
//        viewController.bubbleModel = model
//        viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
//        viewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
//        viewController.isLaunchForAssistant = true
//        viewController.roomNumber = String(format: "%d", roomNumber)
//        
//        topVC.presentViewController(viewController, animated: true, completion: nil)
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

/// 返回当前最上面的viewcontroller
func topViewController() -> UIViewController {
    let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController!
    var presentedVC = rootVC
    
    while let vc = presentedVC?.presentedViewController {
        presentedVC = vc
    }
    
    return presentedVC!
}
