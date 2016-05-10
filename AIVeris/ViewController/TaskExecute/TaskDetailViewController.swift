//
//  TaskDetailViewController.swift
//  AIVeris
//
//  Created by admin on 16/5/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    @IBOutlet weak var serviceTime: IconLabel!
    @IBOutlet weak var serviceLocation: IconLabel!
    @IBOutlet weak var QRCodeImage: ServiceQRCodeView!
    @IBOutlet weak var promptCheckIn: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomButton.layer.cornerRadius = bottomButton.height / 2

        serviceTime.label.text = "dfasfasdfafad"
        serviceTime.icon.image = UIImage(named: "airplane")
        
        serviceLocation.label.text = "ga bvqujencuqewncwech vqeirchnqwcc evcqcqewcewccewc qveqcwecq3exqtbhynymu"
        serviceLocation.icon.image = UIImage(named: "ai_custom_diy")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
