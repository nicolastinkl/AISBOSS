//
//  AILoginViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/5/25.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring

class AILoginViewController: UIViewController {
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var appNameCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var appNameViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var userIdTextField: DesignableTextField!
    @IBOutlet weak var passwordTextField: DesignableTextField!
    @IBOutlet weak var logoImageCenterXConstraint: NSLayoutConstraint!

    
    @IBAction func loginAction(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userIdTextField.delegate = self
        userIdTextField.keyboardType = UIKeyboardType.DecimalPad
        userIdTextField.returnKeyType = UIReturnKeyType.Done
        passwordTextField.delegate = self
        passwordTextField.secureTextEntry = true
        passwordTextField.returnKeyType = UIReturnKeyType.Go
        
        passwordTextField.addTarget(self, action: #selector(AILoginViewController.passwordInputAction(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        self.navigationController?.navigationBarHidden = true
    }
    
    func passwordInputAction(target : UITextField){
        if target.text?.length >= 6{
            loginButton.backgroundColor = UIColor.brownColor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
}

extension AILoginViewController : UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        SpringAnimation.spring(0.5) {
            self.logoImageTopConstraint.constant = -20
            self.logoImageCenterXConstraint.constant = -170
            self.appNameCenterXConstraint.constant = 70
            self.appNameViewTopConstraint.constant = -80
            self.view.layoutIfNeeded()
            self.logoImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.3, 0.3)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        SpringAnimation.spring(0.5) {
            self.logoImageTopConstraint.constant = 80
            self.logoImageCenterXConstraint.constant = 0
            self.appNameCenterXConstraint.constant = 0
            self.appNameViewTopConstraint.constant = 0
            self.view.layoutIfNeeded()
            self.logoImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
        }
    }
    
    
}
