//
//  AIRegistViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/5/26.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring

class AIRegistViewController: UIViewController {

    
    @IBOutlet weak var regionSelectContainerView: UIView!
    @IBOutlet weak var nextStepButton: DesignableButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var regionSelectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBar()
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func selectRegionAction(sender: UIButton) {
    }
    
    @IBAction func nextStepAction(sender: AnyObject) {
    }

    func setupNavigationBar(){
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.title = "Register"
    }

    func setupViews(){
        phoneNumberTextField.leftViewMode = UITextFieldViewMode.Always
        let frame = CGRect(x: 0, y: 0, width: 80, height: phoneNumberTextField.height)
        let leftView = UILabel(frame: frame)
        leftView.text = "+86"
        leftView.textAlignment = NSTextAlignment.Center
        leftView.textColor = UIColor.whiteColor()
        phoneNumberTextField.leftView = leftView
    }
}
