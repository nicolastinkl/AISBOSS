//
//  AITaskNoteEditViewController.swift
//  AIVeris
//
//  Created by admin on 3/21/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AITaskNoteEditViewController: UIViewController {

    @IBOutlet weak var textView: KMPlaceholderTextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationToAppTheme()
        //textView.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AITaskNoteEditViewController: AITaskNavigationDelegate {
   	func cancelButtonPressed(sender: UIButton) {
        print("cancel button pressed")
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
        print("save button pressed")
    }
}
