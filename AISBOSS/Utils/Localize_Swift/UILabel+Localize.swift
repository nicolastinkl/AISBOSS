//
//  UILabel+Localize.swift
//  localizeDemo
//
//  Created by admin on 12/14/15.
//  Copyright © 2015 __ASIAINFO__. All rights reserved.
//

import UIKit

extension UILabel {
    var ailLabel: String? {
        get {
            return text
        }
        set {
            text = newValue?.localized
        }
    }
}
