//
//  TaskDetailViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/5/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    @IBOutlet weak var checkInLabel: UILabel!
    @IBOutlet weak var serviceTime: IconLabel!
    @IBOutlet weak var serviceLocation: IconLabel!
    @IBOutlet weak var QRCodeImage: ServiceQRCodeView!
    @IBOutlet weak var promptCheckIn: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    
    @IBOutlet weak var authorizationBg: UIImageView!
    @IBOutlet weak var promptAuthorization: UILabel!
    @IBOutlet weak var waitingIcon: UIImageView!
    @IBOutlet weak var waitingMask: UIVisualEffectView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomButton.layer.cornerRadius = bottomButton.height / 2
        promptCheckIn.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(48))
        checkInLabel.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(80))
        bottomButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(72))
        promptAuthorization.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(80))
        
        buildNavigationTitleLabel()
        
    }
    
    func buildNavigationTitleLabel(){
        let NAVIGATION_TITLE = AITools.myriadSemiCondensedWithSize(80 / 3)
        let frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        let titleLabel = UILabel(frame: frame)
        titleLabel.font = NAVIGATION_TITLE
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "Service detail"
        self.navigationItem.titleView = titleLabel
        let backImage = UIImage(named: "se_back")
        
        let leftButtonItem = UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AIContestSuccessViewController.backAction(_:)))
        leftButtonItem.tintColor = UIColor.lightGrayColor()
        self.navigationItem.leftBarButtonItem = leftButtonItem
    }
    
    func backAction(button : UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func showAuthorization() {
        promptAuthorization.hidden = false
        authorizationBg.hidden = false
    }
    
    private func hideAuthorization() {
        promptAuthorization.hidden = true
        authorizationBg.hidden = true
    }
    
    @IBAction func startWorkAction(sender: AnyObject) {
        let taskResultCommitlVC = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.TaskExecuteStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.TaskResultCommitViewController) as! TaskResultCommitViewController
        
        self.navigationController?.pushViewController(taskResultCommitlVC, animated: true)
        
    }
    

}
