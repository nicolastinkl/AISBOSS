//
//  AIRequirementViewController.swift
//  AIVeris
//
//  Created by tinkl on 3/8/16.
//  Base on Tof Templates
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

/// application public AIRequirementViewPublicValue value.
class AIRequirementViewPublicValue{
    
    
    // MARK: -> Internal static properties
    
    /// Default 基本信息模型 进入需求分析界面时，从服务器中获取的数据，包含三个部分。
    static var bussinessModel: AIBusinessInfoModel?

    /// Default Cell obj and Model obj.
    static var cellContentTransferValue: AIWrapperAIContentModelClass?

    /// Default pre order model.
    static var orderPreModel : AIOrderPreModel?
    
}


// MARK: -
// MARK: AIRequirementViewController
// MARK: -

internal class AIRequirementViewController : UIViewController {

    // MARK: -> Internal class
    
    var orderPreModel : AIOrderPreModel?
    
    var bussinessModel: AIBusinessInfoModel?
    
    private var tabRequireViewC: UIViewController?
    
    private var tabAssignViewC: UIViewController?
    
    private var tabCollViewC: UIViewController?
    
    private var currentTagIndex: Int = 0
    
    // MARK: -> Internal properties
    
    @IBOutlet weak var rightContentView: UIView!
    
    @IBOutlet weak var TopUserInfoView: UIView!
    
    @IBOutlet weak var LeftMenuInfoView: UIView!
    
    private var userInfoView: OrderAndBuyerInfoView?

    private var uid : Int = 1
    
    private var notifyChangeAIContentCellModel: [AIContentCellModel] = Array<AIContentCellModel>()
    
    // MARK: -> Private type alias
    
    
    // MARK: -> Internal init methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Voluation Model.
        
        AIRequirementViewPublicValue.orderPreModel = self.orderPreModel!
        
        // Init Status Bar.
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
             
        // Register NSNotificationCenter.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifySwitchProfessionVC:", name: AIApplication.Notification.AIAIRequirementViewControllerNotificationName, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifyShowRequireMentVC:", name: AIApplication.Notification.AIAIRequirementShowViewControllerNotificationName, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifyOperateCell:", name: AIApplication.Notification.AIAIRequirementNotifyOperateCellNotificationName, object: nil)        
        
        // Init Top View.
        
        userInfoView = OrderAndBuyerInfoView.createInstance()
        TopUserInfoView.addSubview(userInfoView!)
        userInfoView?.delegate = self
        
        userInfoView?.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(TopUserInfoView)
        }
        
        // Init RightContent View.
        
        withSwitchProfessionVC(1)
        
        // Init Request networking.
        
        requestDataInterface()
        
    }
    
    /**
     数据请求
     */
    func requestDataInterface() {
        
        self.view.showProgressViewLoading()
        
        let handler = AIRequirementHandler.defaultHandler()
        
        handler.queryBusinessInfo(orderPreModel?.proposal_id ?? 0, customID: orderPreModel?.customer.user_id ?? 0, orderID: orderPreModel?.order_id ?? 0, success: { [weak self](businessInfo) -> Void in
            
            // Reload 
            self!.bussinessModel = businessInfo
            
            self!.view.hideProgressViewLoading()
            
            AIRequirementViewPublicValue.bussinessModel = businessInfo

            self!.userInfoView?.model = businessInfo.customerModel
            
            if let viewReqeuire = self!.tabRequireViewC as? AIRequireContentViewController {
                viewReqeuire.startingRequest()
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIAIRequirementNotifynotifyGenerateModelNotificationName, object: nil, userInfo: ["data":AIWrapper(theValue: businessInfo)])
            
            
            }) { [weak self] (errType, errDes) -> Void in
                print("\(errDes)")
                self!.view.hideProgressViewLoading()
        }

        
    }
    
    //MARK:-----------
    
    func  notifyOperateCell(notify: NSNotification){
        if let dic = notify.userInfo {
            if let cellModel = dic.values.first as? AIWrapperAIContentModelClass {
                self.notifyChangeAIContentCellModel.append(cellModel.cellmodel)
            }
        }
    }

    func notifyShowRequireMentVC(notify: NSNotification){
        
        withSwitchProfessionVC(1)
        
    }
    
    func notifySwitchProfessionVC(notify: NSNotification){
        
        if let objType = notify.object as? Int {
             withSwitchProfessionVC(objType)
        }
    }
    
    /**
     切换参数
     
     - parameter type: <#type description#>
     */
    func withSwitchProfessionVC(type: Int){
        
        if currentTagIndex == type {
            return
        }
        
        currentTagIndex = type
        switch type {
        case 1 :
            
            if let vc = tabRequireViewC {
                addSubViewController(vc)
            }else{
                let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIRrequirementStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIRequireContentViewController) as! AIRequireContentViewController
                viewController.orderPreModel = self.orderPreModel
                tabRequireViewC = viewController
                addSubViewController(viewController)
            }
            
            
        case 2 :
            
            let viewController2 = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIRrequirementStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIAssignmentContentViewController) as! AIAssignmentContentViewController
            
            if notifyChangeAIContentCellModel.count == 0 {
                if let vc = tabAssignViewC {
                    addSubViewControllers([vc, viewController2])
                }else{
                    let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIRrequirementStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIRequireContentViewController) as! AIRequireContentViewController
                    viewController.editModel = true
                    viewController.orderPreModel = self.orderPreModel
                    tabAssignViewC = viewController
                    addSubViewControllers([viewController, viewController2])
                }
                
                rightContentView.subviews.first?.alpha = 0
                
            }else{
                
                if let vc = tabAssignViewC {
                    let newvc = vc as! AIRequireContentViewController
                    newvc.dataSource = self.notifyChangeAIContentCellModel
                    addSubViewController(newvc)
                    
                }else{
                    let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIRrequirementStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIRequireContentViewController) as! AIRequireContentViewController
                    viewController.editModel = true
                    viewController.orderPreModel = self.orderPreModel
                    tabAssignViewC = viewController
                    viewController.dataSource = self.notifyChangeAIContentCellModel
                    addSubViewController(viewController)
                }
                rightContentView.subviews.first?.alpha = 1
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIAIRequirementNotifyClearNumberCellNotificationName, object: nil)
            
        case 3 :
            
            
            if let vc = tabCollViewC {
                addSubViewController(vc)
            }else{
                let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIRrequirementStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AICollContentViewController) as! AICollContentViewController
                tabCollViewC = viewController
                addSubViewController(viewController)
            }
            
        case 4 :
            print("")
        default:
            break
        }
    }
    
    // MARK: -> Internal methods
    func addSubViewController(viewController: UIViewController, toView: UIView? = nil) {
        self.addChildViewController(viewController)
        if self.rightContentView != nil {
            _ = self.rightContentView.subviews.filter({ (cview) -> Bool in
                cview.removeFromSuperview()
                return false
            })
            viewController.view.frame = self.rightContentView.frame // reload frame.
            self.rightContentView.addSubview(viewController.view)
            viewController.didMoveToParentViewController(self)
            viewController.view.pinToEdgesOfSuperview(offset: 20)
            
        }
    }
    
    
    func addSubViewControllers(viewController: [UIViewController], toView: UIView? = nil) {
        
        for subView in rightContentView.subviews {
            subView.removeFromSuperview()
        }

        for viewc in viewController {
            
            addChildViewController(viewc)
            
            if rightContentView != nil {
                
                viewc.view.frame = rightContentView.frame // reload frame.
                rightContentView.addSubview(viewc.view)
                viewc.didMoveToParentViewController(self)
                viewc.view.pinToEdgesOfSuperview(offset: 20)
                
            }
        }
    }
    
    
    
    // MARK: -> Internal methods    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func dissMissViewController(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}

extension AIRequirementViewController: OrderAndBuyerInfoViewDelegate {
    func buyerIconClicked() {
        let vc = BuyerRequirmentMessageViewController(nibName: "BuyerRequirmentMessageViewController", bundle: nil)
        vc.buyerAndOrderModel = userInfoView?.model
        presentViewController(vc, animated: true, completion: nil)
    }
}
