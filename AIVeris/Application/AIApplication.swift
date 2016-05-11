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
    
    internal static let KURL_ReleaseURL =  "http://171.221.254.231:3000"  //正式地址
    internal static let KURL_DebugURL   =  "http://171.221.254.231:3000"  //测试地址
    
    // MARK: XUNFEI APPID
    internal static let XUNFEIAPPID  = "551ba83b"
    
    struct IPHONEOS {
        static let IS_IPHONE6PLUS = UIScreen.mainScreen().bounds.size.width > 375
    }
    
    // MARK: Advanced directional push notification 
    
    struct DirectionalPush {
        static let ProviderIdentifier = "ProviderIdentifier"      // 高级定向推送给当前的Provider,用于语音协助
        static let ProviderChannel = "ProviderChannel"            // 抢单用的频道，输入gai
    }
    
    
    // MARK JSON RESPONSE
    
    struct JSONREPONSE {
        internal static let unassignedNum   =  "unassignedNum"  //未读执行条数
    }
    
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
            static let UIRrequirementStoryboard     = "UIRrequirementStoryboard"
            static let AIAlertStoryboard            = "AIAlertStoryboard"
            
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
            static let AIRequirementViewController  = "AIRequirementViewController"
            static let AIRequireContentViewController   = "AIRequireContentViewController"
            static let AIAssignmentContentViewController = "AIAssignmentContentViewController"
            static let AICollContentViewController = "AICollContentViewController"
            static let AIAlertViewController = "AIAlertViewController"
            static let AIGladOrderViewController    =   "AIGladOrderViewController"
            static let AIContestSuccessViewController = "AIContestSuccessViewController"
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
        static let UIAIASINFOmotifyParamsNotification =     "UIAIASINFOmotifyParamsNotification"
        // FIXME: 视频拍摄完成文件地址
        static let NSNotirydidFinishMergingVideosToOutPutFileAtURL  = "NSNotirydidFinishMergingVideosToOutPutFileAtURL"
        //一键清除订单
        static let UIAIASINFORecoverOrdersNotification = "UIAIASINFORecoverOrdersNotification"

        
        static let AIDatePickerViewNotificationName  = "AIDatePickerViewNotificationName"
        static let AISinglePickerViewNotificationName  = "AISinglePickerViewNotificationName"
        static let AIAIRequirementViewControllerNotificationName    = "AIAIRequirementViewControllerNotificationName"
        static let AIAIRequirementShowViewControllerNotificationName    = "AIAIRequirementShowViewControllerNotificationName"
        static let AIAIRequirementNotifyOperateCellNotificationName    = "AIAIRequirementNotifyOperateCellNotificationName"
        static let AIAIRequirementNotifyClearNumberCellNotificationName    = "AIAIRequirementNotifyClearNumberCellNotificationName"
        static let AIAIRequirementNotifynotifyGenerateModelNotificationName    = "AIAIRequirementNotifynotifyGenerateModelNotificationName"
        static let AIRequireContentViewControllerCellWrappNotificationName    = "AIRequireContentViewControllerCellWrappNotificationName"
        
        static let AIRequirementViewShowAssignToastNotificationName    = "AIRequirementViewShowAssignToastNotificationName"
        
        
        
        //服务执行页选择一个服务实例的通知 add by liux at 20160330
        static let AIRequirementSelectServiceInstNotificationName = "AIRequirementSelectServiceInstNotificationName"
        
        //关闭弹出框UI的通知
        static let AIRequirementClosePopupNotificationName = "AIRequirementClosePopupNotificationName"
        
        //更新查询需求分析数据的通知
        static let AIRequirementReloadDataNotificationName = "AIRequirementReloadDataNotificationName"
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
    
    struct AIImagePlaceHolder {
        static let AIDefaultPlaceHolder = "http://tinkl.qiniudn.com/tinklUpload_scrollball_5.png"
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

    
    /**
     根据不同环境获取服务器Api地址.    
     */
    internal enum AIApplicationServerURL: CustomStringConvertible {
        
        // 获取服务方案
        case getServiceScheme
        // 添加服务Note (文本和语音)
        case addWishListNote
        // 删除服务Note (文本和语音)
        case delWishListNote
        // 保持服务参数
        case saveServiceParameters
        // 提交Proposal订单
        case submitProposalOrder
        // 查询卖家订单列表
        case querySellerOrderList
        // 更新参数设置状态
        case updateParamSettingState
        // 删除服务类别
        case delServiceCategory
        // 查询客户Proposal列表
        case queryCustomerProposalList
        // 查询客户订单列表
        case queryCustomerOrderList
        // 查找客户Proposal详情
        case findCustomerProposalDetail
        // 查找服务详情
        case findServiceDetail
        case findServiceDetailNew
        // 更新心愿单tag状态
        case updateWishListTagChosenState
        //查询热门搜索
        case queryHotSearch
        // 获取Api具体地址.
        case recoverOrders
        // 获取Api具体地址.
        case submitOrderByService
        // 查询价格
        case findServicePrice
        
        // 查询需求管理初始化信息
        case queryBusinessInfo
        
        // 原始需求列表
        case queryOriginalRequirements
        
        // 直接保存为待分配状态
        case saveAsTask
        
        // 查询待分配标签列表接口
        case queryUnassignedRequirements
        
        // 转化为标签
        case saveTagsAsTask
        
        // 转化为备注
        case addNewTag
        
        // 保存新增备注
        case addNewNote
        
        //MARK: 增加新的任务节点
        case addNewTask
        
        //MARK: 设置权限
        case setServiceProviderRights
        
        //MARK: 派单
        case assginTask
        
        //MARK: 查询子服务默认标签列表
        case queryServiceDefaultTags
        
        //MARK: 将需求共享给其它子服务
        case distributeRequirement
        
        //MARK: 查询所有的任务节点
        case queryTaskList
        
        // 一键恢复订单
        var description: String {
            
            let serverStatus = NSUserDefaults.standardUserDefaults().integerForKey(kDefault_ServerURLStatus)
            if serverStatus == 0{
                   // debug
            }else if serverStatus == 1{
                // release
            }
            
            switch self {
            case .getServiceScheme: return AIApplication.KURL_ReleaseURL+"/getServiceScheme"
            case .addWishListNote: return AIApplication.KURL_ReleaseURL+"/addWishListNote"
            case .delWishListNote: return AIApplication.KURL_ReleaseURL+"/delWishListNote"
            case .saveServiceParameters: return AIApplication.KURL_ReleaseURL+"/saveServiceParameters"
            case .submitProposalOrder: return AIApplication.KURL_ReleaseURL+"/submitProposalOrder"
            case .querySellerOrderList: return AIApplication.KURL_ReleaseURL+"/querySellerOrderList"
            case .updateParamSettingState: return AIApplication.KURL_ReleaseURL+"/updateParamSettingState"
            case .delServiceCategory: return AIApplication.KURL_ReleaseURL+"/delServiceCategory"
            case .queryCustomerProposalList: return AIApplication.KURL_ReleaseURL+"/queryCustomerProposalList"
            case .queryCustomerOrderList: return AIApplication.KURL_ReleaseURL+"/queryCustomerOrderList"
            case .findCustomerProposalDetail: return AIApplication.KURL_ReleaseURL+"/findCustomerProposalDetailNew"
            case .findServiceDetail: return AIApplication.KURL_ReleaseURL+"/findServiceDetail"
            case .updateWishListTagChosenState: return AIApplication.KURL_ReleaseURL+"/updateWishListTagChosenState"
            case .queryHotSearch: return "http://171.221.254.231:8282/sboss/queryHotSearch"
            case .recoverOrders: return AIApplication.KURL_ReleaseURL+"/recoverOrders"
            case .submitOrderByService:   return AIApplication.KURL_ReleaseURL + "/submitOrderByService"
            case .findServiceDetailNew: return AIApplication.KURL_ReleaseURL+"/findServiceDetailNew"
            case .findServicePrice: return AIApplication.KURL_ReleaseURL + "/findServicePrice"
              
            // 原始需求列表
            case .queryBusinessInfo: return AIApplication.KURL_ReleaseURL + "/queryCustomerInfoSubserverList"
            case .queryOriginalRequirements: return AIApplication.KURL_ReleaseURL + "/queryOriginalRequirements"
            case .saveAsTask: return AIApplication.KURL_ReleaseURL + "/updateDistributionState"
            case .queryUnassignedRequirements: return AIApplication.KURL_ReleaseURL + "/queryUnDistributeRequirementList"
            case .saveTagsAsTask: return AIApplication.KURL_ReleaseURL + "/saveAnalysisTag"
            case .addNewNote: return AIApplication.KURL_ReleaseURL + "/saveAnalysisNote"
            case .addNewTag : return AIApplication.KURL_ReleaseURL + "/addWishTag"
            case .addNewTask : return AIApplication.KURL_ReleaseURL + "/saveAnalysisTaskNode"
            case .setServiceProviderRights : return AIApplication.KURL_ReleaseURL + "/updateAccessPermission"
            case .assginTask : return AIApplication.KURL_ReleaseURL + "/submitWorkOrder"
            case .queryServiceDefaultTags : return AIApplication.KURL_ReleaseURL + "/queryDistributionTagList"
            case .distributeRequirement : return AIApplication.KURL_ReleaseURL + "/distributeRequirement"
            case .queryTaskList: return AIApplication.KURL_ReleaseURL + "/queryTaskNodeList"


            }
            
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
    
    
    static func showAlertView(){
        
        let viewAlert = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIAlertStoryboard, bundle: nil).instantiateInitialViewController()// .instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIAlertViewController) as! AIAlertViewController
        
        if let rootVc = UIApplication.sharedApplication().keyWindow?.rootViewController {
            if rootVc.isKindOfClass(UINavigationController.self) {
                //rootVc.pop
            }else{
                
            }
            rootVc.presentPopupViewController(viewAlert!, animated: true)
        }
    }
    
    static func showGladOrderView(){
        let viewAlert = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIAlertStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIGladOrderViewController) as! AIGladOrderViewController
        
        if let rootVc = UIApplication.sharedApplication().keyWindow?.rootViewController {
            logInfo("\(rootVc.dynamicType)")

            if rootVc.isKindOfClass(UINavigationController.self) {
                //rootVc.pop
            }else{
                
            }
            rootVc.presentPopupViewController(viewAlert, animated: true)
        }
        
    }
    
    
    
}

/*
增加class泛型工具 一般在引用传递时使用.
*/
class AIWrapper<T> {
    var wrappedValue: T
    init(theValue: T) {
        wrappedValue = theValue
    }
}


