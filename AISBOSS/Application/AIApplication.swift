//
//  AIApplication.swift
//  AI2020OS
//
//  Created by tinkl on 30/3/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

import Cartography

/*!
*  @author tinkl, 15-03-30 15:03:35
*
*  AI2020OS Application Paramters
*/
struct AIApplication{
    
    // MARK: LEANCLOUD APPKEY
    internal static let AVOSCLOUDID  = "xkz4nhs9rmvw3awnolcu3effmdkvynztt1umggatbrx72krk"
    
    internal static let AVOSCLOUDKEY = "qqcxwtjlx3ctw32buizjkaw5elwf0s41u4xf8ct7glbox171"
    
    // MARK: XUNFEI APPID
    internal static let XUNFEIAPPID  = "551ba83b"
    
    // MARK: All the ViewController Identifiers
    struct MainStoryboard {
        
        struct MainStoryboardIdentifiers {
            static let AIMainStoryboard             = "AIMainStoryboard"
            static let AILoginStoryboard            = "AILoginStoryboard"
            static let AILoadingStoryboard          = "AILoadingStoryboard"
            static let AIMenuStoryboard             = "AIMenuStoryboard"
            static let AIMesageCenterStoryboard     = "AIMesageCenterStoryboard"
            static let AIComponentStoryboard        = "AIComponentStoryboard"
            static let AISettingsStoryboard         = "AISettingsStoryboard"
            static let AIOrderStoryboard            = "AIOrderStoryboard"
            static let AIOrderDetailStoryboard      = "AIOrderDetailStoryboard"
            static let AISearchStoryboard           = "AISearchStoryboard"
            static let AIConnectMeunStoryboard      = "AIConnectMeunStoryboard"
            static let AITagFilterStoryboard        = "AITagFilterStoryboard"
            static let AIVideoStoryboard            = "AIVideoStoryboard"
            static let UIMainStoryboard             = "UIMainStoryboard"
            static let UIBuyerStoryboard            = "UIBuyerStoryboard"
            
        }
        
        // MARK: View
        struct ViewControllerIdentifiers {
            static let listViewController           = "listViewController"
            static let favoritsTableViewController  = "AIFavoritsTableViewController"
            static let AIMenuViewController         = "AIMenuViewController"
            static let AIMessageCenterViewController = "AIMessageCenterViewController"
            static let AICalendarViewController     = "AICalendarViewController"
            static let AIComponentChoseViewController   = "AIComponentChoseViewController"
            static let AISearchServiceCollectionViewController = "AISearchServiceCollectionViewController"
            static let AIBuyerDetailViewController = "AIBuyerDetailViewController"
            static let AIPageBueryViewController    = "AIPageBueryViewController"
            static let AIServiceContentViewController   = "AIServiceContentViewController"
        }
        
        /*!
        *  @author tinkl, 15-09-09 15:09:38
        *
        *  Cell ID
        */
        struct CellIdentifiers {
            
            // MARK: HOME
            static let AIUIMainTopCell              = "UIMainTopCell"
            static let AIUIMainMediaCell            = "UIMainMediaCell"
            static let AIUIMainContentCell          = "UIMainContentCell"
            static let AIUIMainActionCell           = "UIMainActionCell"
            static let AIUIMainSpaceHloderCell      = "UIMainSpaceHloderCell"
            static let AIUISigntureTagsCell         = "UISigntureTagsCell"
            
            // MARK: Detail
            static let AISDDateCell                 = "AISDDateCell"
            static let AICoverFlowCell              = "AICoverFlowCell"
            static let AISDFightCell                = "AISDFightCell"
            static let AISDParamsCell               = "AISDParamsCell"
            static let AITitleServiceDetailCell     = "AITitleServiceDetailCell"
            static let AITableCellHolder            = "AITableCellHolder"
            static let AITableCellHolderParms       = "AITableCellHolderParms"
            static let AITableCellHolderParmsModel  = "AITableCellHolderParmsModel"
            
            // MARK: TIME LINE
            static let AITIMELINESDTimesViewCell    = "AITIMELINESDTimesViewCell"
            static let AITIMELINESDContentViewCell  = "AITIMELINESDContentViewCell"
            
            // MARK: BUYER
            static let AITableFoldedCellHolder = "AITableFoldedCellHolder"
            static let AITableExpandedCellHolder = "AITableExpandedCellHolder"
            
            
        }
        
        /*!
        *  @author tinkl, 15-09-09 15:09:44
        *
        *  DIY View ID
        */
        struct ViewIdentifiers {
            static let AIOrderBuyView           = "AIOrderBuyView"
            static let AILoginViewController    = "AILoginViewController"
            static let AIMessageUnReadView      = "AIMessageUnReadView"
            static let AIHomeViewStyleMultiepleView = "AIHomeViewStyleMultiepleView"
            static let AIHomeViewStyleTitleView = "AIHomeViewStyleTitleView"
            static let AIHomeViewStyleTitleAndContentView = "AIHomeViewStyleTitleAndContentView"
            static let AIServiceDetailsViewCotnroller = "AIServiceDetailsViewCotnroller"
            static let AIErrorRetryView     = "AIErrorRetryView"
            static let AIServerScopeView    = "AIServerScopeView"
            static let AIServerTimeView     = "AIServerTimeView"
            static let AIServerAddressView  = "AIServerAddressView"
            static let AITableViewInsetMakeView =   "AITableViewInsetMakeView"
            static let AITabelViewMenuView  = "AITabelViewMenuView"
            static let AICalendarViewController =   "AICalendarViewController"
            static let AIScanViewController = "AIScanViewController"
            
        }
    }
    
    // MARK: Notification with IM or System Push.
    struct Notification{
        static let UIAIASINFOWillShowBarNotification    = "UIAIASINFOWillShowBarNotification"
        static let UIAIASINFOWillhiddenBarNotification  = "UIAIASINFOWillhiddenBarNotification"
        static let UIAIASINFOLoginNotification          = "UIAIASINFOLoginNotification"
        static let UIAIASINFOLogOutNotification         = "UIAIASINFOLogOutNotification"
        
        static let UIAIASINFOOpenAddViewNotification         = "UIAIASINFOOpenAddViewNotification"
        static let UIAIASINFOOpenRemoveViewNotification         = "UIAIASINFOOpenRemoveViewNotification"
        static let UIAIASINFOChangeDateViewNotification         = "UIAIASINFOChangeDateViewNotification"
        // FIXME: 视频拍摄完成文件地址
        static let NSNotirydidFinishMergingVideosToOutPutFileAtURL  = "NSNotirydidFinishMergingVideosToOutPutFileAtURL"
        
        static let NSNotiryAricToNomalStatus  = "NSNotiryAricToNomalStatus"
    }
    
    // MARK: System theme's color
    struct AIColor {
        static let MainTextColor     = "#41414C"
        static let MainTabBarBgColor = "#00cec0"
        static let MainYellowBgColor = "#f0ff00"
        static let MainGreenBgColor  = "#5fc30d"
        
        static let AIVIEWLINEColor   = "#E4E3E4"
        
        static let MainSystemBlueColor   = "#625885"//"#00CEC3"
        static let MainSystemBlackColor  = "#848484"
        static let MainSystemGreenColor  = "#00cec0"
    }
    
    struct AIViewTags {
        static let loadingProcessTag        = 101
        static let errorviewTag             = 102
        static let AIMessageUnReadViewTag   = 103
    }
    
    struct AIStarViewFrame {
        static let width:CGFloat            = 60.0
        static let height:CGFloat           = 9.0
    }
    
    
    
    // MARK: IM ObjectIDS
    struct AIIMOBJECTS {
        static let AIYUJINGID = "556c0a2ae4b09419962544b7"          //预警通知
        static let AIFUWUTUIJISNID = "556c0acce4b0941996254a49"     //服务推荐
        static let AITUIKUAN = "556c0b8fe4b0941996254f8f"           //退款通知
        static let AIXITONG = "556c0c06e4b0941996255223"            //系统通知
    }
    
    // MARK: The Application preferorm
    internal func SendAction(functionName:String,ownerName:AnyObject){
        /*!
        *  @author tinkl, 15-04-22 16:04:07
        *
        *   how to use it ?
        SendAction("minimizeView:", ownerName: self)
        */
        UIApplication.sharedApplication().sendAction(Selector(functionName), to: nil, from: ownerName, forEvent: nil)
    }
    
    /*!
    Application hook viewdidload
    */
    static func hookViewDidLoad(){
        swizzlingMethod(UIViewController.self,
            oldSelector: "viewDidLoad",
            newSelector: "viewDidLoadForChangeTitleColor")
    }
    
    /*!
    Application hookViewDesLoad
    */
    static func hookViewWillAppear(){
        swizzlingMethod(UIViewController.self,
            oldSelector: "viewDidAppear:",
            newSelector: "viewWillAppearForShowBottomBar:")
    }
    
    static func hookViewWillDisappear(){
        swizzlingMethod(UIViewController.self,
            oldSelector: "viewWillDisappear:",
            newSelector: "viewWillDisappearForHiddenBottomBar:")
    }
    
    static func swizzlingMethod(clzz: AnyClass, oldSelector: Selector, newSelector: Selector) {
        let oldMethod = class_getInstanceMethod(clzz, oldSelector)
        let newMethod = class_getInstanceMethod(clzz, newSelector)
        method_exchangeImplementations(oldMethod, newMethod)
    }
    
    // MARK: Application Unread ViewController.
    static func showMessageUnreadView(){
        
        if let loadingXibView = UIApplication.sharedApplication().keyWindow!.viewWithTag(AIApplication.AIViewTags.AIMessageUnReadViewTag) {
            loadingXibView.hidden = false
        }else
        {
            //            let unreadView = AIMessageUnReadView.currentView() as AIMessageUnReadView
            //            UIApplication.sharedApplication().keyWindow!.addSubview(unreadView)
            //            unreadView.tag = AIApplication.AIViewTags.AIMessageUnReadViewTag
            //            layout(unreadView) { view in
            //                view.width  == 80
            //                view.height == 74
            //                view.top >= view.superview!.top
            //                view.right >= view.superview!.right+10
            //            }
        }
        
    }
    
    /*!
        隐藏消息按钮
    */
    static func hideMessageUnreadView(){
        if let loadingXibView = UIApplication.sharedApplication().keyWindow!.viewWithTag(AIApplication.AIViewTags.AIMessageUnReadViewTag) {
            loadingXibView.hidden = true
        }
    }
    
    static func pushViewController(view:UIViewController){
        //        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //        if let rootViewController = appDelegate.rootNavigationController{
        //            rootViewController.pushViewController(view, animated: true)
        //        }
        
    }
    
    /*!
    全局分享按钮
    
    :param: url URL
    */
    static func shareAction(url:String){
        if let viewcontroller =  UIApplication.sharedApplication().keyWindow?.rootViewController{
            let textToShare = AIApplication.kSHARE
            
            if let myWebsite = NSURL(string: "http://www.codingexplorer.com/")
            {
                let objectsToShare = [textToShare, myWebsite]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                //New Excluded Activities Code
                activityVC.excludedActivityTypes = [UIActivityTypeMail,UIActivityTypeMessage,UIActivityTypeAirDrop, UIActivityTypeAddToReadingList,UIActivityTypePostToWeibo]
                
                viewcontroller.presentViewController(activityVC, animated: true, completion: nil)
            }
        }
    }
}

extension AIApplication {
    @nonobjc static let kSHARE = "AIApplication.share".localized
}
