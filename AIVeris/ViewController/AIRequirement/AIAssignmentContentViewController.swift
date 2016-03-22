//
//  AIAssignmentContentViewController.swift
//  AIVeris
//
//  Created by tinkl on 3/8/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring



class AIAssignmentContentViewController: UIViewController {
    
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var tarButton: DesignableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentLabel.font = AITools.myriadLightSemiCondensedWithSize(17)
        tarButton.titleLabel?.font = AITools.myriadLightWithSize(17)
        
    }
    
    @IBAction func dismissViewControllerToMain(sender: AnyObject) {
        
        SpringAnimation.springWithCompletion(0.5, animations: { () -> Void in
            self.view.alpha = 0
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIAIRequirementShowViewControllerNotificationName, object: nil)            
            }) { (complate) -> Void in
            self.view.removeFromSuperview()
                
        }
        
    }
    
}

