//
//  ViewDimention.swift
//  AIVeris
//
//  Created by Rocky on 15/10/21.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

class PurchasedViewDimention {
    static let CONVERT_FACTOR: CGFloat = 2.5
    static let PROPOSAL_PADDING_LEFT = 40 / CONVERT_FACTOR
    static let PROPOSAL_PADDING_RIGHT = 40 / CONVERT_FACTOR
    static let PROPOSAL_HEAD_HEIGHT: CGFloat = 130 / CONVERT_FACTOR
    static let PROPOSAL_TITLE_HEIGHT = 56 / CONVERT_FACTOR
    static let PROPOSAL_TITLE_MARGIN_TOP = 43 / CONVERT_FACTOR
    static let PROPOSAL_STATU_MARGIN_TOP = 46 / CONVERT_FACTOR
    static let PROPOSAL_STATU_HEIGHT = 46 / CONVERT_FACTOR
    static let PROPOSAL_STATU_TEXT_HEIGHT = 34 / CONVERT_FACTOR
    static let LOGO_MARGIN_TOP: CGFloat = 36 / CONVERT_FACTOR
    static let LOGO_WIDTH: CGFloat = 62 / CONVERT_FACTOR
    static let LOGO_HEIGHT: CGFloat = 62 / CONVERT_FACTOR
    static let SERVICE_STATU_HEIGHT = 40 / CONVERT_FACTOR
    static let ICON_WIDTH: CGFloat = 52 / CONVERT_FACTOR
    static let ICON_HEIGHT: CGFloat = 52 / CONVERT_FACTOR
    static let SERVICE_COLLAPSED_HEIGHT: CGFloat = 90
}

class PurchasedViewColor {
    static let BACKGROUND = UIColor(red:0.33, green:0.33, blue:0.58, alpha:1)
    static let DEFAULT = UIColor.whiteColor()
    static let TITLE = UIColor.whiteColor()
    static let STATU = UIColor.whiteColor()
    static let STATU_BACKGROUND = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
    static let DIVIDER = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
    static let SERVICE_STATU = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
}

class PurchasedViewFont {
    static let NORMAL_FONT_NAME = "Myriad Pro"
    static let TITLE = AITools.myriadSemiCondensedWithSize(56 / PurchasedViewDimention.CONVERT_FACTOR)
    static let STATU = AITools.myriadLightSemiCondensedWithSize(34 / PurchasedViewDimention.CONVERT_FACTOR)
    static let SERVICE_TITLE = AITools.myriadLightSemiCondensedWithSize(49 / PurchasedViewDimention.CONVERT_FACTOR)
    static let SERVICE_STATU = AITools.myriadLightSemiCondensedWithSize(34 / PurchasedViewDimention.CONVERT_FACTOR)
    static let SERVICE_DESCRIPTION = AITools.myriadLightSemiCondensedWithSize(38 / PurchasedViewDimention.CONVERT_FACTOR)
    static let ORDER_TIME_VALUE = AITools.myriadLightSemiCondensedWithSize(60 / PurchasedViewDimention.CONVERT_FACTOR)
    static let ORDER_ALERT_LABEL = AITools.myriadSemiCondensedWithSize(34 / PurchasedViewDimention.CONVERT_FACTOR)
    static let ESHOP_OFFER_NAME = AITools.myriadLightSemiCondensedWithSize(45 / PurchasedViewDimention.CONVERT_FACTOR)

}