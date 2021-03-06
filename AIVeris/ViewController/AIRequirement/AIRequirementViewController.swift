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
import AIAlertView

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
    
    private var tabToastVC: AIAssignmentContentViewController = {
    
         let viewController2 = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIRrequirementStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIAssignmentContentViewController) as! AIAssignmentContentViewController
        return viewController2
    }()
    
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
        
        // Init UI Settings.
        springAnimationSpale(0)
        
        // Voluation Model.
        
        AIRequirementViewPublicValue.orderPreModel = self.orderPreModel!
        
        // Init Status Bar.
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
             
        // Register NSNotificationCenter.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIRequirementViewController.notifySwitchProfessionVC(_:)), name: AIApplication.Notification.AIAIRequirementViewControllerNotificationName, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIRequirementViewController.notifyShowRequireMentVC(_:)), name: AIApplication.Notification.AIAIRequirementShowViewControllerNotificationName, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIRequirementViewController.notifyOperateCell(_:)), name: AIApplication.Notification.AIAIRequirementNotifyOperateCellNotificationName, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIRequirementViewController.requestDataInterface), name: AIApplication.Notification.AIRequirementReloadDataNotificationName, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIRequirementViewController.showAssignToast), name: AIApplication.Notification.AIRequirementViewShowAssignToastNotificationName, object: nil)
        
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
   
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func showAssignToast(){
        
        addToastViewController(tabToastVC)
        
        rightContentView.subviews.first?.alpha = 0
    }
    
    
    func springAnimationSpale(alpha: CGFloat){
        
        self.rightContentView.alpha = alpha
        self.TopUserInfoView.alpha = alpha
        self.LeftMenuInfoView.alpha = alpha
        

    }
    
    /**
     数据请求
     */
    func requestDataInterface() {
        

        view.showLoading()

        
        let handler = AIRequirementHandler.defaultHandler()
        
        handler.queryBusinessInfo(orderPreModel?.proposal_id ?? 0, customID: orderPreModel?.customer.user_id ?? 0, orderID: orderPreModel?.order_id ?? 0, success: { (businessInfo) -> Void in
            
            // Reload 
            self.bussinessModel = businessInfo
            
            self.view.hideLoading()
            
            AIRequirementViewPublicValue.bussinessModel = businessInfo

            if let priceModel = businessInfo.customerModel {
                let newPriceModel = priceModel
                newPriceModel.price = self.orderPreModel?.service.service_price
                self.userInfoView?.model = newPriceModel
            }
            
            if let viewReqeuire = self.tabRequireViewC as? AIRequireContentViewController {
                viewReqeuire.startingRequest()
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIAIRequirementNotifynotifyGenerateModelNotificationName, object: nil, userInfo: ["data":AIWrapper(theValue: businessInfo)])
            
            SpringAnimation.springEaseIn(0.2, animations: { () -> Void in
                self.springAnimationSpale(1)
            })

            
            }) { (errType, errDes) -> Void in
                self.view.hideLoading()
                self.springAnimationSpale(0)
                AIAlertView().showError("error", subTitle: "网络请求失败")
        }
    }
    
    //MARK:-----------
    
    func  notifyOperateCell(notify: NSNotification){
        if let dic = notify.userInfo {
            if let cellModel = dic.values.first as? AIWrapperAIContentModelClass {
                self.notifyChangeAIContentCellModel.append(cellModel.cellmodel!)
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
            
            let viewController2 = tabToastVC
            var countVC: Int = 0
            if let vc = tabAssignViewC {
                let newvc = vc as! AIRequireContentViewController
                countVC = newvc.dataSource?.count ?? 0
            }
            
            /**第二次切换时显示列表*/
            if notifyChangeAIContentCellModel.count == 0 && countVC == 10000 {
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
                    //newvc.dataSource = self.notifyChangeAIContentCellModel
                    
                    addSubViewController(newvc)
                    
                }else{
                    let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIRrequirementStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIRequireContentViewController) as! AIRequireContentViewController
                    viewController.editModel = true
                    viewController.orderPreModel = self.orderPreModel
                    tabAssignViewC = viewController
                    //viewController.dataSource = self.notifyChangeAIContentCellModel
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
    
    func addToastViewController(viewController: UIViewController, toView: UIView? = nil) {
        self.addChildViewController(viewController)
        if self.rightContentView != nil {
            viewController.view.frame = self.rightContentView.frame // reload frame.
            self.rightContentView.addSubview(viewController.view)
            viewController.didMoveToParentViewController(self)
            viewController.view.pinToEdgesOfSuperview(offset: 20)
            
        }
    }
    
    
    
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
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        if let tabCollViewC = tabCollViewC as? AICollContentViewController {
            tabCollViewC.removeAllObserver()
        }
        
        if let tabAssignViewC = tabAssignViewC as? AIRequireContentViewController {
            tabAssignViewC.removeAllObserver()
        }
        
        if let tabRequireViewC = tabRequireViewC as? AIAssignmentContentViewController {
            tabRequireViewC.removeAllObserver()
        }
        
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
