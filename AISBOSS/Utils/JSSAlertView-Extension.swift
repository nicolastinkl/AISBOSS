//
//  JSSAlertView-Extension.swift
//  AIVeris
//
//  Created by admin on 12/8/15.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import UIKit

extension JSSAlertView {
    
    func comfirm(viewController: UIViewController, title: String, text: String, customIcon: UIImage?=nil, onComfirm: (()->Void)?=nil, onCancel: (()-> Void)?=nil) {
//        let customIcon = UIImage(named: "lemon")
        let alertview = JSSAlertView().show(viewController, title: title,text: text, buttonText: "Yes",cancelButtonText:"No", color: UIColorFromHex(0xe7ebf5, alpha: 1), iconImage: customIcon)
        
        if let comfirm = onComfirm {
            alertview.addAction(comfirm)
        }
        
        if let cancel = onCancel {
            alertview.addCancelAction(cancel)
        }
    }
}