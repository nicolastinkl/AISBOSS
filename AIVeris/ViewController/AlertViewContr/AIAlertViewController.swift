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
import AIAlertView

class AIAlertViewController: UIViewController,UINavigationControllerDelegate {
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var serviceDescLabel: UILabel!
    @IBOutlet weak var userIconImageView: DesignableImageView!
    @IBOutlet weak var serviceIconImageView: DesignableImageView!
    @IBOutlet weak var customerDescView: UIView!
    @IBOutlet weak var timerControl: DDHTimerControl!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    
    var timerEndDate : NSDate!
    var timer : NSTimer?
    
    var serviceInstId : String?
    
    let TIMER_TEXT_FONT = AITools.myriadSemiCondensedWithSize(70 / 3)
    
    
    // MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        //网络请求
        //requestDataInterface()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        customerDescView.setCornerOnTop()
    }
    
    
    // MARK: - IBAction
    @IBAction func answerAction(sender: AnyObject) {
        //AIApplication.showGladOrderView()
        //点抢单按钮后就不再倒计时
        if timer != nil{
            timer!.invalidate()
            timer = nil
        }
        
        //TODO: 等BDK完成后调用
        //requestGrabOrderInterface()
        
        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIAlertStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIContestSuccessViewController) as! AIContestSuccessViewController
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func arvatarDidTapped(sender: AnyObject) {
        
    }
    @IBAction func backgroundDidTapped(sender: AnyObject) {
        dismissPopupViewController(true, completion: nil)
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
    
    /**
     数据请求
     */
    func requestDataInterface() {
    
        AIServiceExecuteRequester.defaultHandler().queryGrabOrderDetail("1", success: { (businessInfo) in
            self.loadData(businessInfo)
            }) { (errType, errDes) in
                AIAlertView().showError("error", subTitle: "网络请求失败")
        }
    }
    
    func requestGrabOrderInterface(){
        let userId = NSUserDefaults.standardUserDefaults().objectForKey(kDefault_UserID) as! String
        AIServiceExecuteRequester.defaultHandler().grabOrder(serviceInstId: serviceInstId!, providerId: userId, success: { (businessInfo) in
            let result = businessInfo.grabResult
            if result == GrabResultEnum.Success{
                let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIAlertStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIContestSuccessViewController) as! AIContestSuccessViewController
                
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else{
                AIAlertView().showInfo("Sorry", subTitle: "You failed!")
                self.dismissPopupViewController(true, completion: nil)
            }
        }) { (errType, errDes) in
                AIAlertView().showError("error", subTitle: "网络请求失败")
        }
    }
    
    func loadData(viewModel : AIGrabOrderDetailViewModel){
        userNameLabel.text = viewModel.customerName
        userIconImageView.sd_setImageWithURL(NSURL(string: viewModel.customerIcon))
        serviceNameLabel.text = viewModel.serviceName
        serviceDescLabel.text = viewModel.serviceIntroContent
        serviceIconImageView.sd_setImageWithURL(NSURL(string: viewModel.serviceThumbnailIcon))
        //订单参数的赋值暂时写死取两个
        userPhoneNumberLabel.text = viewModel.customerParamArray![0].labelText
        userLocationLabel.text = viewModel.customerParamArray![1].labelText
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