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
// MARK: -
// MARK: AIRequirementViewController
// MARK: -
internal class AIRequirementViewController : UIViewController {

    
    // MARK: -> Internal class
    
    // MARK: -> Internal type alias
    
    // MARK: -> Internal static properties
    
    var orderPreModel : AIOrderPreModel?
    
    private var tabRequireViewC: UIViewController?
    
    private var tabAssignViewC: UIViewController?
    
    private var tabCollViewC: UIViewController?
    
    private var currentTagIndex: Int = 0
    // MARK: -> Internal properties
    
    @IBOutlet weak var rightContentView: UIView!
    
    @IBOutlet weak var TopUserInfoView: UIView!

    private var uid : Int = 1
    
    // MARK: -> Private type alias
    
    
    // MARK: -> Internal init methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init Status Bar
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
     
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifySwitchProfessionVC:", name: AIApplication.Notification.AIAIRequirementViewControllerNotificationName, object: nil)
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifyShowRequireMentVC:", name: AIApplication.Notification.AIAIRequirementShowViewControllerNotificationName, object: nil)
        
        // Init Top View
        
        let topView = OrderAndBuyerInfoView.createInstance()
        TopUserInfoView.addSubview(topView)
        topView.delegate = self
        
        topView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(TopUserInfoView)
        }
        
        // Init RightContent View
        
        withSwitchProfessionVC(1)
    }
    
    
    //MARK: 接口测试
    
    func testInterface() -> Void {
        let handler = AIRequirementHandler.defaultHandler()
        
        //
        
//        handler.queryBusinessInfo((orderPreModel?.proposal_id)!, roleType: 1, success: { (businessInfo) -> Void in
//            print("\(businessInfo)")
//            }) { (errType, errDes) -> Void in
//                print("\(errDes)")
//        }
        
        //
        
        handler.queryUnassignedRequirements((orderPreModel?.proposal_id)!, roleType: 1, success: { (requirements) -> Void in
            print("\(requirements)")
            }) { (errType, errDes) -> Void in
                print("\(errDes)")
        }
    }
    
    
    //MARK:-----------
    

    func notifyShowRequireMentVC(notify: NSNotification){
        SpringAnimation.springEaseIn(0.5) { () -> Void in
            self.rightContentView.subviews.first?.alpha = 1
        }
    }
    
    func notifySwitchProfessionVC(notify: NSNotification){
        
        if let objType = notify.object as? Int {
             withSwitchProfessionVC(objType)
        }
    }
    
    
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
                tabRequireViewC = viewController
                addSubViewController(viewController)
            }
            
            
        case 2 :
            
            let viewController2 = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIRrequirementStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIAssignmentContentViewController) as! AIAssignmentContentViewController
            
            if let vc = tabAssignViewC {
                addSubViewControllers([vc, viewController2])
            }else{
                let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIRrequirementStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIRequireContentViewController) as! AIRequireContentViewController
                viewController.editModel = true
                tabAssignViewC = viewController
                addSubViewControllers([viewController, viewController2])
            }
            
            rightContentView.subviews.first?.alpha = 0
            
            
        case 3 :
            
            
            if let vc = tabCollViewC {
                addSubViewController(vc)
            }else{
                let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIRrequirementStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AICollContentViewController) as! AICollContentViewController
                tabCollViewC = viewController
                addSubViewController(viewController)
            }
            
        case 4 :
            print("4")
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
        presentViewController(vc, animated: true, completion: nil)
    }
}
