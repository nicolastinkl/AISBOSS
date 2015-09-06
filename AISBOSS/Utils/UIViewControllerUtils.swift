//
//  UIViewControllerUtils.swift
//  AI2020OS
//
//  Created by tinkl on 1/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
/*!
*  @author tinkl, 15-04-01 17:04:36
*
*  solve : The "hook" mechanism change NavigationBar's or tabbar's background.
*  NOTICE:Changing this property’s value provides visual feedback in the user interface, including the running of any associated animations. The selected item displays the tab bar item’s selectedImage image, using the tab bar’s selectedImageTintColor value. To prevent system coloring of an item, provide images using the UIImageRenderingModeAlwaysOriginal rendering mode.
*/
extension UIViewController {
    
    func viewDidLoadForChangeTitleColor() {
        self.viewDidLoadForChangeTitleColor()
        //setNeedsStatusBarAppearanceUpdate()
        if self.isKindOfClass(UINavigationController.classForCoder()) {
            self.changeNavigationBarTextColor(self as! UINavigationController)
        }
    }
    
    func changeNavigationBarTextColor(navController: UINavigationController) {
        let nav = navController as UINavigationController
        let dic = NSDictionary(object: UIColor.applicationMainColor(),
            forKey:NSForegroundColorAttributeName)
        nav.navigationBar.titleTextAttributes = dic as? [String : AnyObject]
        nav.navigationBar.tintColor = UIColor.applicationMainColor()
        //nav.navigationBar.lt_setBackgroundColor(
        //UIColor.applicationMainColor().colorWithAlphaComponent(0))
        //nav.setNavigationBarHidden(true, animated: true)
        self.title = ""
        UINavigationBar.appearance().shadowImage = UIColor.clearColor().clearImage()
    }
    
    func viewWillDisappearForHiddenBottomBar(animated: Bool){
        self.viewWillDisappearForHiddenBottomBar(animated)
        
//        if self.isKindOfClass(AIHomeViewController.classForCoder()) ||
//            self.isKindOfClass(AIDiscoveryViewController.classForCoder()) ||
//            self.isKindOfClass(AITimelineViewController.classForCoder()) ||
//            self.isKindOfClass(AIFavoritesViewController.classForCoder()) ||
//            self.isKindOfClass(AISelfViewController.classForCoder()) {
//                AIApplication.hideMessageUnreadView()
//        }
    }
    
    func viewWillAppearForShowBottomBar(animated: Bool){
        self.viewWillAppearForShowBottomBar(animated)
        
//        if self.isKindOfClass(AIHomeViewController.classForCoder()) ||
//            self.isKindOfClass(AIDiscoveryViewController.classForCoder()) ||
//            self.isKindOfClass(AITimelineViewController.classForCoder()) ||
//            self.isKindOfClass(AIFavoritesViewController.classForCoder()) ||
//            self.isKindOfClass(AISelfViewController.classForCoder()){
//                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//                appDelegate.rootNavigationController = self.navigationController
//                if let token = AILocalStore.accessToken() {
//                    AIApplication.showMessageUnreadView()
//                }
//        }
    }
    
    func showMenuViewController(){
        
//        let menuViewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIMenuStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIMenuViewController) as AIMenuViewController
//        menuViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
//        menuViewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
//        self.showDetailViewController(menuViewController, sender: self)
        
    }
    
    /*!
        the local coding scope.
    */
    override func localCode(closeure:()->()){
        closeure()
    }
    
    // 显示搜索主界面
    func showSearchMainViewController() {
        
//        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AISearchStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AISearchServiceCollectionViewController) as SearchServiceViewController
//        viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
//        viewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
//        self.showDetailViewController(viewController, sender: self)
        
    }
    
}
