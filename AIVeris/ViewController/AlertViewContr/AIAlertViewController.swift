//
//  AIAlertViewController.swift
//  AIVeris
//
// Copyright (c) 2016 ___ASIAINFO___
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import UIKit
import Spring

class AIAlertViewController: UIViewController,UINavigationControllerDelegate {
    
    

    @IBOutlet weak var customerDescView: UIView!
    @IBOutlet weak var timerControl: DDHTimerControl!
    
    var timerEndDate : NSDate!
    var timer : NSTimer?
    
    let TIMER_TEXT_FONT = AITools.myriadSemiCondensedWithSize(70 / 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    @IBAction func arvatarDidTapped(sender: AnyObject) {
    }
    @IBAction func backgroundDidTapped(sender: AnyObject) {
        dismissPopupViewController(true, completion: nil)
    }
    
    @IBAction func answerAction(sender: AnyObject) {
        //AIApplication.showGladOrderView()
        //点抢单按钮后就不再倒计时
        if timer != nil{
            timer!.invalidate()
            timer = nil
        }
        
        
        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIAlertStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIContestSuccessViewController) as! AIContestSuccessViewController
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func initViews(){
        timerControl.color = UIColor(hex: "#49bf1f")
        //timerControl.highlightColor = UIColor.redColor()
        timerControl.minutesOrSeconds = 59
        timerControl.titleLabel.text = ""
        timerControl.userInteractionEnabled = false
        timerEndDate = NSDate(timeIntervalSinceNow: 60)
        if let timer = timer {
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(AIAlertViewController.changeTimer(_:)), userInfo: nil, repeats: true)
        
        customerDescView.setCornerOnTop()
        customerDescView.clipsToBounds = true
        
        self.navigationController?.delegate = self
    }
    
    func changeTimer(timer : NSTimer){
        let timerInterval = timerEndDate.timeIntervalSinceNow
        timerControl.minutesOrSeconds = NSInteger(timerInterval) % 60
        //倒计时结束的时候
        if timerControl.minutesOrSeconds == 0{
            self.timer!.invalidate()
            self.timer = nil
            self.dismissPopupViewController(true, completion: nil)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customerDescView.setCornerOnTop()
    }
    
    //MARK: - delegate
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        let navigationBar = navigationController.navigationBar
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = UIColor.clearColor()
        navigationBar.translucent = true
        
    }
    
}