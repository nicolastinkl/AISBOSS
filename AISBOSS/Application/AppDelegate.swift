//
//  AppDelegate.swift
//  AISBOSS
//
//  Created by tinkl on 4/8/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? 

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //AVOS
        AVOSCloud.setApplicationId(AIApplication.AVOSCLOUDID,
            clientKey: AIApplication.AVOSCLOUDKEY)
        
        // DEBUG
        AVAnalytics.setCrashReportEnabled(true)
        
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        initNetEngine()
        //创建Root
        let root = AIRootViewController()
        
        // 设置状态栏隐藏
        application.statusBarHidden = true
        application.setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        // 设置状态栏高亮
        application.statusBarStyle = UIStatusBarStyle.LightContent
        application.setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        //创建导航控制器
        let nav = UINavigationController(rootViewController:root)
        nav.navigationBarHidden = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
          
        return true

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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    private func initNetEngine() {
        let timeStamp: Int = 0
        let token = "0"
        let RSA = "0"
        
        let headerContent = "\(timeStamp)&" + token + "&" + "0" + "&" + RSA
        
        let header = ["HttpQuery": headerContent]
        AINetEngine.defaultEngine().configureCommonHeaders(header)
    }


}

