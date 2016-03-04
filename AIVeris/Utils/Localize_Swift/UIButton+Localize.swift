//
//  UIButton+Localize.swift
//  localizeDemo
//
//  Created by admin on 12/14/15.
//  Copyright © 2015 __ASIAINFO__. All rights reserved.
//

import UIKit

extension UIButton {
 
    var ailButtonNormalTitle: String?{
        get {
            return titleForState(UIControlState.Normal)
        }
        set {
            setTitle(newValue?.localized, forState: UIControlState.Normal)
        }
    }
    
    var ailButtonHighlightedTitle: String? {
        get {
            return titleForState(UIControlState.Highlighted)
        }
        set {
            setTitle(newValue?.localized, forState: UIControlState.Highlighted)
        }
        
    }
    var ailButtonDisabledTitle: String? {
        get {
            return titleForState(UIControlState.Disabled)
        }
        set {
            setTitle(newValue?.localized, forState: UIControlState.Disabled)
        }
    }
    var ailButtonSelectedTitle: String? {
        get {
            return titleForState(UIControlState.Selected)
        }
        set {
            setTitle(newValue?.localized, forState: UIControlState.Selected)
        }
    }
    var ailButtonApplicationTitle: String? {
        get {
            return titleForState(UIControlState.Application)
        }
        set {
            setTitle(newValue?.localized, forState: UIControlState.Application)
        }
    }
    
    var ailButtonReservedTitle: String? {
        get {
            return titleForState(UIControlState.Reserved)
        }
        set {
            setTitle(newValue?.localized, forState: UIControlState.Reserved)
        }
    }
}
