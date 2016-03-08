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
  
    
    private var uid : Int = 1
    
    // MARK: -> Private type alias
    
    // MARK: -> Private methods
    
    
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


//extension AIRequirementViewController : AIRequireProtocol {
//
//    
//    func withSwitchProfessionVC(type: Int) {
//        print("main type")
//    }
//    
//}

extension AIRequireProtocol where Self : AIRequirementViewController {

    func withSwitchProfessionVC(type: Int){
        print("select button : ")
        
        switch type {
        case 1 :
            print("1")
            
        case 2 :
            print("2")
        case 3 :
            print("3")
        case 4 :
            print("4")
        default:
            print("default")
            
            break
        }
        
        
    }
    
}
