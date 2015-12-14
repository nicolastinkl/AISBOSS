//
//  UIImageView+Localize.swift
//  localizeDemo
//
//  Created by admin on 12/14/15.
//  Copyright © 2015 __ASIAINFO__. All rights reserved.
//

import UIKit

extension UIImageView {
    var ailImageView: String? {
        get {
            return ""
        }
        set {
            self.image = UIImage(named: newValue?.localized ?? "")
        }
    }
}