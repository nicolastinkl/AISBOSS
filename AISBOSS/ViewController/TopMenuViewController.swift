//
//  TopMenuViewController.swift
//  AITrans
//
//  Created by 刘先 on 15/6/25.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

import UIKit

class TopMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let width = self.view.frame.size.width
        println("topMenu Frame \(width)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeTopMenuAction(sender: UISwipeGestureRecognizer) {
        //self.view.hidden = true
        var basTopMenuFrame = self.view.frame
        basTopMenuFrame.origin.y -= basTopMenuFrame.size.height
        self.view.frame = basTopMenuFrame
        self.view.alpha = 0.5
        
//        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 500, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//                var basTopMenuFrame = self.view.frame
//                basTopMenuFrame.origin.y -= basTopMenuFrame.size.height
//                self.view.frame = basTopMenuFrame
//                self.view.alpha = 0.5
//            }, completion: nil)
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
