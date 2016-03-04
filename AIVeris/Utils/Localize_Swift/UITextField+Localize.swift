//
//  UITextField+Localize.swift
//  AIVeris
//
//  Created by admin on 12/15/15.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import UIKit

extension UITextField {
    var ailTextField: String? {
        get {
            return text
        }
        set {
            text = newValue?.localized
        }
    }
    
    var ailTextFieldPlaceholder: String? {
        get {
            return placeholder
        }
        set {
            placeholder = newValue?.localized
        }
    }
}
