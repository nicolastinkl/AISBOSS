//
//  TaskResultCommitViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/5/10.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class TaskResultCommitViewController: UIViewController {

    @IBOutlet weak var checkIcon: UIImageView!
    @IBOutlet weak var writeIcon: UIImageView!
    @IBOutlet weak var cameraIcon: UIImageView!
    @IBOutlet weak var questButton: UIButton!
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        questButton.layer.cornerRadius = questButton.height / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func questButtonClicked(sender: AnyObject) {
        BuildInCameraUtils.startCameraControllerFromViewController(self, delegate: self)
    }
}

extension TaskResultCommitViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension TaskResultCommitViewController: UINavigationControllerDelegate {
    
}
