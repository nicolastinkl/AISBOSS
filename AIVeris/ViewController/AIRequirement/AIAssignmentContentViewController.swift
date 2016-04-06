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

    private let kDefaultAlpha: CGFloat = 0.5
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var tarButton: DesignableButton!
    
    private var timer: NSTimer?
    
    private var focalPointView: MDCSpotlightView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentLabel.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(52))
        
        tarButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(52))
        
        focalPointView = MDCSpotlightView(focalView: contentImageView)
        focalPointView!.bgColor = UIColor.whiteColor()
        focalPointView!.frame = CGRectMake(contentImageView.x, contentImageView.y, contentImageView.width + 13, contentImageView.height + 13)
        focalPointView!.layer.cornerRadius = focalPointView!.frame.size.width/2
        focalPointView!.layer.masksToBounds  = true
        focalPointView!.setNeedsDisplay()
        view.insertSubview(focalPointView!, atIndex: 0)
        focalPointView!.alpha = kDefaultAlpha
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "TimerEvent", userInfo: nil, repeats: true)
     
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        focalPointView!.center = contentImageView.center
    }
    
    func TimerEvent(){
        
        if let focalView = focalPointView {
            let alpha = focalView.alpha
            if alpha == 0.5 {
                UIView.animateWithDuration(0.8, animations: { () -> Void in
                    self.focalPointView!.alpha = 0.0
                })
            }else{
                UIView.animateWithDuration(0.8, animations: { () -> Void in
                    self.focalPointView!.alpha = 0.5
                })
            }
        }
    }
    
    @IBAction func dismissViewControllerToMain(sender: AnyObject) {
         NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIAIRequirementShowViewControllerNotificationName, object: nil)
        
        /*timer?.invalidate()
        SpringAnimation.springWithCompletion(0.5, animations: { () -> Void in
            self.view.alpha = 0
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIAIRequirementShowViewControllerNotificationName, object: nil)            
            }) { (complate) -> Void in
            self.view.removeFromSuperview()
                
        }*/
        
    }
    
    
}

