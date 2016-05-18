//
//  AADialogViewController.swift
//  AIVeris
//
//  Created by admin on 5/17/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AACustomerDialogViewController: UIViewController {
    @IBOutlet weak var dialogToolBar: DialogToolBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        dialogToolBar?.delegate = self
        dia()
    }
    
    func dia() {
        AIRemoteNotificationHandler.defaultHandler().sendAudioAssistantNotification(<#T##notification: [String : AnyObject]##[String : AnyObject]#>, toUser: "200000002501")
    }
}

extension AACustomerDialogViewController: DialogToolBarDelegate {
    func dialogToolBar(dialogToolBar: DialogToolBar, clickHangUpButton sender: UIButton) {
       dismissViewControllerAnimated(true, completion: nil)
    }
}
