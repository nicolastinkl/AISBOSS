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
        
        contentLabel.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(52))
        
        tarButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(52))
        
        /*MDCSpotlightView *focalPointView = [[MDCSpotlightView alloc] initWithFocalView:self];
        focalPointView.bgColor= [UIColor whiteColor];
        focalPointView.frame = CGRectMake(0, 0, size + 13, size + 13);
        focalPointView.center = CGPointMake(self.width/2, self.height/2);
        focalPointView.layer.cornerRadius = focalPointView.frame.size.width/2;
        focalPointView.layer.masksToBounds  = YES;
        [focalPointView setNeedsDisplay];
        [self insertSubview:focalPointView atIndex:0];
        focalPointView.alpha = kDefaultAlpha;*/
        
    }
    
    @IBAction func dismissViewControllerToMain(sender: AnyObject) {
        
        SpringAnimation.springWithCompletion(0.5, animations: { () -> Void in
            self.view.alpha = 0
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIAIRequirementShowViewControllerNotificationName, object: nil)            
            }) { (complate) -> Void in
            self.view.removeFromSuperview()
                
        }
        
    }
    
    
    
    /*
    
    
    - (void)TimerEvent
    {
    MDCSpotlightView *focalPointView = self.timer.userInfo[@"focalPointView"];
    
    if (focalPointView != nil) {
    CGFloat alpha = focalPointView.alpha;
    if ( alpha == 0.5) {
    [UIView animateWithDuration:0.8 animations:^{
    focalPointView.alpha = 0.0f;
    } completion:^(BOOL finished) {
    
    }];
    }else{
    [UIView animateWithDuration:0.8 animations:^{
    focalPointView.alpha = 0.5;
    } completion:^(BOOL finished) {
    
    }];
    }
    
    }
    
    }

    */
    
}

