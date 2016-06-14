//
//  AppDelegate.swift
//  AISBOSS
//
//  Created by tinkl on 4/8/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import UIKit
import CardDeepLinkKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //
    var didFinishGetSellerData : Bool = false
    var didFinishGetBuyerListData : Bool = false
    var didFinishGetBuyerProposalData : Bool = false
    
    //
    
    private lazy var router: CDDeepLinkRouter = CDDeepLinkRouter()
    var sellerData : NSDictionary?
    var buyerListData : ProposalOrderListModel?
    var buyerProposalData : AIProposalPopListModel?
    
   
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
//        return true
        //AVOS
        configAVOSCloud()
        AVAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        AVAnalytics.setChannel("App Store")
        
//       https://leancloud.cn/docs/ios_push_guide.html#保存_Installation 
//        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert,.Badge,.Sound], categories: nil))
//        application.registerForRemoteNotifications()
        
        
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        configDefaultUser()
        initNetEngine()
        
        // 设置状态栏隐藏
        application.statusBarHidden = true
        application.setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        // 设置状态栏高亮
        application.statusBarStyle = UIStatusBarStyle.LightContent
        application.setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
         
        
        // 检查录音权限
        AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in

            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
                try AVAudioSession.sharedInstance().setActive(true)
            }catch{
            }
        }) 

        showRootViewControllerReal()
        
        //fetchPreSellerAndBuyerData()
        
        Async.main(after: 2) { 
            //AIApplication.showAlertView()
        }
        
        // launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]
        
        router.registerBlock({ (deeplink) in
            debugPrint("deeplink1 \(deeplink.queryParameters)")
            
            // 1. Parser all the Property and unPackage.
            // 2. Send Notification to do somethings with logic.
            
                if let _ = deeplink.queryParameters {
                    //DeepLink Network Requseting.
                    NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIDeepLinkupdateDeepLinkView, object: nil)
                }
            
            }, route: "cddpl://.*")
        
        
        return true

    }
    
    /*
     @available(iOS, introduced=4.2, deprecated=9.0, message="Please use application:openURL:options:")
     */
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        router.handleURL(url) { (complte, error) in
            print("info : \(complte) \(error) ")
        }
        
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        router.handleURL(url) { (complte, error) in
            print("info : \(complte) \(error) ")
        }
        
        return true
    }
    
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        #if !DEBUG //debug 模式 才会启动
        if motion == .MotionShake {
            var roomNumber = "\(random() % 9999)"
            roomNumber = "\(AudioAssistantManager.fakeRoomNumber)" // test
            
            let notification = [AIRemoteNotificationParameters.AudioAssistantRoomNumber: roomNumber, AIRemoteNotificationKeys.NotificationType: AIRemoteNotificationParameters.AudioAssistantType, AIRemoteNotificationKeys.MessageKey: "您有远程协助请求", AIRemoteNotificationKeys.ProposalID: 2692, AIRemoteNotificationKeys.ProposalName: "Event Planning"]
            var userInfo = [NSObject: AnyObject]()
            userInfo["aps"] = notification
            AIRemoteNotificationHandler.defaultHandler().didReceiveRemoteNotificationUserInfo(userInfo)
        }
        #endif
    }
    
    /**
     Config Lean Cloud.
     */
    func configAVOSCloud(){
        
        AVOSCloudCrashReporting.enable()
        
        AVOSCloud.setApplicationId(AIApplication.AVOSCLOUDID,
                                   clientKey: AIApplication.AVOSCLOUDKEY)
        #if !DEBUG
        // debug 模式 设置开发状态
        AVPush.setProductionMode(false)
        #endif
 
        
        AVOSCloud.registerForRemoteNotification()


        AVAnalytics.setAnalyticsEnabled(true)
        
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
       
        if UIDevice.currentDevice().deviceType == .Simulator {
            let token = NSData(base64EncodedString: "simulatordevicetoken", options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
           AVOSCloud.handleRemoteNotificationsWithDeviceToken(token)
        }

        logError("\(error.userInfo)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        logInfo("\(userInfo)")
        
        AVAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)

        AIRemoteNotificationHandler.defaultHandler().didReceiveRemoteNotificationUserInfo(userInfo)
        
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
      
        AVOSCloud.handleRemoteNotificationsWithDeviceToken(deviceToken)

        logInfo("DeviceToken OK")
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let num = application.applicationIconBadgeNumber
        if num > 0 {
            let install = AVInstallation.currentInstallation()
            install.badge = 0
            install.saveEventually()
            application.applicationIconBadgeNumber=0
        }
        application.cancelAllLocalNotifications()
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func configDefaultUser () {
    
        
        var defaultUserID = "100000002410"
        var defaultUserType = "101"
        
        
        if let userID : String = NSUserDefaults.standardUserDefaults().objectForKey(kDefault_UserID) as? String {
            defaultUserID = userID
            
            if let type = NSUserDefaults.standardUserDefaults().objectForKey(kDefault_UserType) {
                defaultUserType = type as! String
            }
            print("Default UserID is " + userID)
        }
        else {
            NSUserDefaults.standardUserDefaults().setObject(defaultUserID, forKey: kDefault_UserID)
            NSUserDefaults.standardUserDefaults().setObject(defaultUserType, forKey: kDefault_UserType)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        // 配置语音协助定向推送
        if (defaultUserType == "100") {
            AIRemoteNotificationHandler.defaultHandler().addNotificationForUser(defaultUserID)
        }
        else
        {
            AIRemoteNotificationHandler.defaultHandler().removeNotificationForUser(defaultUserID)
        }
    }
    
    private func initNetEngine() {
        let timeStamp: Int = 0
        let token = "0"
        let RSA = "0"
   
        let userID  = (NSUserDefaults.standardUserDefaults().objectForKey("Default_UserID") ?? "100000002410") as! String

        if userID == "100000002410" {
            NSUserDefaults.standardUserDefaults().setObject(userID, forKey: "Default_UserID")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        let splitedarray = ["\(timeStamp)",token,userID,RSA] as [String]
        
        var headerContent : String = "";
        
        
        for(var i = 0; i < splitedarray.count ; i += 1) {
            let str = splitedarray[i]
            headerContent += str
            
            if i != 3 {
                headerContent += "&"
            }
            
        }


        let header = ["HttpQuery": headerContent]
        AINetEngine.defaultEngine().configureCommonHeaders(header)
    }
    
     
    func showRootViewControllerReal() {
        //创建Root
        let root = AIRootViewController()
        //创建导航控制器
        let nav = UINavigationController(rootViewController:root)
        nav.navigationBarHidden = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    

    func showRootViewController() {
        
    }
    
    func fetchBuyerData() {
        let bdk = BDKProposalService()
        // 列表数据
        bdk.getProposalList({ (responseData) -> Void in
            self.didFinishGetBuyerListData = true
            self.buyerListData = responseData
            
            if (self.didFinishGetSellerData && self.didFinishGetBuyerProposalData) {
                self.showRootViewController()
            }
            
            }) { (errType, errDes) -> Void in
                
                self.didFinishGetBuyerListData = true
                self.buyerListData = nil
                if (self.didFinishGetSellerData && self.didFinishGetBuyerProposalData) {
                    self.showRootViewController()
                }
        }
        
        bdk.getPoposalBubbles({ (responseData) -> Void in
            self.didFinishGetBuyerProposalData = true
            self.buyerProposalData = responseData
            
            if (self.didFinishGetSellerData && self.didFinishGetBuyerListData) {
                self.showRootViewController()
            }
            
            }) { (errType, errDes) -> Void in
                
                self.didFinishGetBuyerProposalData = true
                self.buyerProposalData = nil
                if (self.didFinishGetSellerData && self.didFinishGetBuyerListData) {
                    self.showRootViewController()
                }
        }
    }
    
    func fetchSellerData () {
        let dic = ["data": ["order_state": "0","order_role": "2"],
            "desc": ["data_mode": "0","digest": ""]]
        
        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.querySellerOrderList.description
        message.body.addEntriesFromDictionary(dic)
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            self.didFinishGetSellerData = true
            self.sellerData = response as? NSDictionary

            if (self.didFinishGetBuyerListData && self.didFinishGetBuyerProposalData) {
                self.showRootViewController()
            }
            
            }) { (AINetError, String) -> Void in
                self.didFinishGetSellerData = true
                self.sellerData = nil
                if (self.didFinishGetBuyerListData && self.didFinishGetBuyerProposalData) {
                    self.showRootViewController()
                }
        }
    }
    
    
    func fetchPreSellerAndBuyerData () {
        
        // Get Seller
        fetchSellerData()

        // Get Buyer
        fetchBuyerData()
        
    }
}

