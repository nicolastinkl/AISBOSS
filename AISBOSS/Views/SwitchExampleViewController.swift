//
//  ViewController.swift
//  SevenSwitchExample
//
//  Created by Benjamin Vogelzang on 6/21/14.
//  Copyright (c) 2014 Ben Vogelzang. All rights reserved.
//  Modify by Rocky on 9/16/15
//

import UIKit

class SwitchExampleViewController: UIViewController {
    @IBOutlet var ibSwitch: SevenSwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ibSwitch.onTintColor = UIColor(red: 0.20, green: 0.42, blue: 0.86, alpha: 1)
        ibSwitch.on = true
        
        // this will create the switch with default dimensions, you'll still need to set the position though
        // you also have the option to pass in a frame of any size you choose
        let mySwitch = SevenSwitch(frame: CGRectZero)
        mySwitch.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5)
        mySwitch.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(mySwitch)

        // turn the switch on
        mySwitch.on = true
        
        // Example of a bigger switch with images
        let mySwitch2 = SevenSwitch(frame: CGRectMake(0, 0, 100, 50))
        mySwitch2.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5 - 80)
        mySwitch2.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)
        mySwitch2.offImage = UIImage(named: "cross.png")
        mySwitch2.onImage = UIImage(named: "check.png")
        mySwitch2.onTintColor = UIColor(hue: 0.08, saturation: 0.74, brightness: 1.00, alpha: 1.00)
        mySwitch2.isRounded = false
        self.view.addSubview(mySwitch2)
        
        // turn the switch on with animation
        mySwitch2.setOn(true, animated: true)
        
        
        // Example of color customization
        let mySwitch3 = SevenSwitch(frame: CGRectZero)
        mySwitch3.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5 + 70)
        mySwitch3.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(mySwitch3)
        
        //self.view.backgroundColor = [UIColor colorWithRed:0.19f green:0.23f blue:0.33f alpha:1.00f];
        mySwitch3.thumbTintColor = UIColor(red: 0.19, green: 0.23, blue: 0.33, alpha: 1)
        mySwitch3.activeColor =  UIColor(red: 0.07, green: 0.09, blue: 0.11, alpha: 1)
        mySwitch3.inactiveColor =  UIColor(red: 0.07, green: 0.09, blue: 0.11, alpha: 1)
        mySwitch3.onTintColor =  UIColor(red: 0.45, green: 0.58, blue: 0.67, alpha: 1)
        mySwitch3.borderColor = UIColor.clearColor()
        mySwitch3.shadowColor = UIColor.blackColor()
        
        
        // Example of a bigger switch with lable
        let mySwitch4 = SevenSwitch(frame: CGRectMake(0, 0, 50, 25))
        mySwitch4.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5 + 150)
        mySwitch4.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)
        mySwitch4.onLabel.text = "ON"
        mySwitch4.onLabel.textColor = UIColor.whiteColor()
        mySwitch4.offLabel.text = "OFF"
        mySwitch4.offLabel.textColor = UIColor.whiteColor()
        mySwitch4.onTintColor = UIColor(red:0.33, green:0.28, blue:0.58, alpha:1)
        mySwitch4.inactiveColor =  UIColor(red:0.78, green:0.78, blue:0.8, alpha:1)
        mySwitch4.isRounded = false
        self.view.addSubview(mySwitch4)
        
        // turn the switch on with animation
        mySwitch4.setOn(true, animated: true)
    }
    
    func switchChanged(sender: SevenSwitch) {
        print("Changed value to: \(sender.on)")
    }
}
