//
//  AITitleAndIconTextView.swift
//  AIVeris
//
//  Created by Rocky on 15/11/24.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class AITitleAndIconTextView: UIView {

    static let TITLE_MARGIN_TOP: CGFloat = 46
    static let TEXT_MARGIN_TO_ICON: CGFloat = 7
    static let ICON_WIDTH: CGFloat = 16
    static let PADDING_BOTTOM: CGFloat = 10
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var firstIcon: UIImageView!
    @IBOutlet weak var firstText: UILabel!
    
    @IBOutlet weak var title_magin_top: NSLayoutConstraint!
    @IBOutlet weak var icon_magin_top: NSLayoutConstraint!
    
    private var paramsCount = 5
    private var iconTextDic: [[UIImageView: UILabel]]!
    
    
    override func awakeFromNib() {
        title.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(48))
        firstText.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(31))
    }
    
    static func createInstance() -> AITwoIconAndTextView {
        return NSBundle.mainBundle().loadNibNamed("AITwoIconTextView", owner: self, options: nil).first  as! AITwoIconAndTextView
    }
    
    func loadData(data: String) {
        
    }
    
    private func createIconTextPair() {
        var preIcon = UILabel(frame: CGRect(x: firstIcon.origin.x, y: firstIcon.origin.y + firstIcon.height + icon_magin_top.constant, width: firstIcon.width, height: firstIcon.height))
    }
    
    

}
