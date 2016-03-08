//
//  AIRequirementViewController.swift
//  AIVeris
//
//  Created by tinkl on 3/8/16.
//  Base on Tof Templates
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

// MARK: -
// MARK: AIRequirementViewController
// MARK: -
internal class AIRequirementViewController : UIViewController {

    
    // MARK: -> Internal structs
    
    // MARK: -> Internal class
    
    // MARK: -> Internal type alias
    
    // MARK: -> Internal static properties
    
    // MARK: -> Internal properties
    
    @IBOutlet weak var rightContentView: UIView!
    
    private var uid : Int = 1
    
    // MARK: -> Private type alias
    
    
    // MARK: -> Internal init methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init Status Bar
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
     
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifySwitchProfessionVC:", name: AIApplication.Notification.AIAIRequirementViewControllerNotificationName, object: nil)
        
        
        // Init RightContent View
        
        withSwitchProfessionVC(1)
        
    }
    
    func notifySwitchProfessionVC(notify: NSNotification){
        
        if let objType = notify.object as? Int {
             withSwitchProfessionVC(objType)
        }
    }
    
    
    func withSwitchProfessionVC(type: Int){
        
        switch type {
        case 1 :
            
            let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIRrequirementStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIRequireContentViewController) as! AIRequireContentViewController
            
            self.addSubViewController(viewController)
            
        case 2 :
            let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIRrequirementStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIAssignmentContentViewController) as! AIAssignmentContentViewController
            
            self.addSubViewController(viewController)
            
        case 3 :
            let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIRrequirementStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AICollContentViewController) as! AICollContentViewController
            
            self.addSubViewController(viewController)
            
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
    
    
    // MARK: -> Internal methods    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func dissMissViewController(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
