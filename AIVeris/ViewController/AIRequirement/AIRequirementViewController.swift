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
  
    @IBOutlet weak var rightHoldView: UIView!
    
    private var uid : Int = 1
    
    // MARK: -> Private type alias
    
    
    // MARK: -> Internal init methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        
    }
    
    
    // MARK: -> Internal methods    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func dissMissViewController(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}

extension AIRequireProtocol where Self : AIRequirementViewController {

    // MARK: -> Private methods
    
    func withSwitchProfessionVC(type: Int){
        
        switch type {
        case 1 :
            
            self.addSubViewController(UIViewController(), toView: self.rightHoldView)
            
        case 2 :
            
            self.addSubViewController(UIViewController(nibName: "", bundle: nil), toView: self.rightHoldView)
            
        case 3 :
            print("3")
        case 4 :
            print("4")
        default:
            break
        }
    }
    
    
    // MARK: -> Internal methods
    func addSubViewController(viewController: UIViewController, toView: UIView? = nil, belowSubview: UIView? = nil) {
        self.addChildViewController(viewController)
        var parentView = self.view
        if let view = toView {
            parentView = view
        }
        if let subview = belowSubview {
            parentView.insertSubview(viewController.view, belowSubview: subview)
        } else {
            parentView.addSubview(viewController.view)
        }
        viewController.didMoveToParentViewController(self)
        viewController.view.pinToEdgesOfSuperview()
    }
    
}
