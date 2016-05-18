//
//  AAProviderDialogViewControllerViewController.swift
//  AIVeris
//
//  Created by admin on 5/17/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AAProviderDialogViewController: UIViewController {
    
    @IBOutlet weak var dialogToolBar: DialogToolBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dialogToolBar?.delegate = self
    }

}

extension AAProviderDialogViewController: DialogToolBarDelegate {
    func dialogToolBar(dialogToolBar: DialogToolBar, clickHangUpButton sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}