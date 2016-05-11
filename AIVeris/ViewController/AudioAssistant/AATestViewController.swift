//
//  AATestViewController.swift
//  AIVeris
//
//  Created by admin on 5/10/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AATestViewController: UIViewController {
    
    var isGray = false

    override func viewDidLoad() {
        super.viewDidLoad()
        AudioAssistantManager.sharedInstance.connectionToAudioAssiastantRoom()
        let tap = UITapGestureRecognizer(target: self, action: "viewTapped:")
        view.addGestureRecognizer(tap)
    }

    @IBAction func shareScreen(sender: AnyObject) {
        AudioAssistantManager.sharedInstance.doPublish()
    }
    
    @IBAction func changeColor(sender: AnyObject) {
        if isGray {
            view.backgroundColor = UIColor.whiteColor()
            isGray = false
        } else {
            view.backgroundColor = UIColor.grayColor()
            isGray = true
        }
    }
    
    @IBAction func viewTapped(sender: UITapGestureRecognizer) {
        let location = sender.locationInView(view)
        let spot = UIView()
        spot.backgroundColor = UIColor.blueColor()
        spot.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        view.addSubview(spot)
        spot.center = location
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
}

