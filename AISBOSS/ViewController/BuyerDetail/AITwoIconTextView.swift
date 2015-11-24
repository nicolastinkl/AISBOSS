//
//  AITowPlacesView.swift
//  AIVeris
//
//  Created by Rocky on 15/11/23.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AITwoIconAndTextView: UIView {
    
    static let FIRST_ICON_MARGIN_TOP_HAS_TITLE: CGFloat = 46
    static let TEXT_MARGIN_TO_ICON: CGFloat = 7
    static let ICON_WIDTH: CGFloat = 12
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var firstIcon: UIImageView!
    @IBOutlet weak var secondIcon: UIImageView!
    @IBOutlet weak var firstText: UILabel!
    @IBOutlet weak var secondText: UILabel!
    
    @IBOutlet weak var firstIconMarginTop: NSLayoutConstraint!
    @IBOutlet weak var iconWidth: NSLayoutConstraint!
    @IBOutlet weak var textMarginLeftToIcon: NSLayoutConstraint!
    
    override func awakeFromNib() {
        firstText.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(36))
        secondText.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(36))
    }
    
    static func createInstance() -> AITwoIconAndTextView {
        return NSBundle.mainBundle().loadNibNamed("AITwoIconTextView", owner: self, options: nil).first  as! AITwoIconAndTextView
    }
    
    private func showTitle() {
        firstIconMarginTop.constant = AITwoIconAndTextView.FIRST_ICON_MARGIN_TOP_HAS_TITLE
        firstIcon.setNeedsUpdateConstraints()
        
        title.hidden = false
    }
    
    private func showFirstIcon() {
        firstIcon.hidden = false
        textMarginLeftToIcon.constant = AITwoIconAndTextView.TEXT_MARGIN_TO_ICON
        firstText.setNeedsUpdateConstraints()
        
        iconWidth.constant = AITwoIconAndTextView.ICON_WIDTH
        firstIcon.setNeedsUpdateConstraints()
        
    }
    
    private func showSecondIcon() {
        secondIcon.hidden = false
    }
}
