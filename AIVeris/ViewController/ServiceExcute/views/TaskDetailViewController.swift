//
//  TaskDetailViewController.swift
//  AIVeris
//
//  Created by admin on 16/5/9.
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomButton.layer.cornerRadius = bottomButton.height / 2
        promptCheckIn.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(48))
        checkInLabel.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(80))
        bottomButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(72))
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
