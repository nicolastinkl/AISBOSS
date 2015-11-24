//
//  AIIconTextView.swift
//  AIVeris
//
//  Created by Rocky on 15/11/24.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class AIIconTextView: UIView {
    
    @IBOutlet weak var firstIcon: UIImageView!
    @IBOutlet weak var firstText: UILabel!
    
    @IBOutlet weak var iconMaginTop: NSLayoutConstraint!
    @IBOutlet weak var textTopToIcon: NSLayoutConstraint!
    @IBOutlet weak var textMaginRight: NSLayoutConstraint!
    
    private var paramsCount = 1
    private var iconTextDic: [[UIImageView: UILabel]]!
    
    
    override func awakeFromNib() {
        firstText.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(31))
    }
    
    static func createInstance() -> AIIconTextView {
        return NSBundle.mainBundle().loadNibNamed("AIIconTextView", owner: self, options: nil).first  as! AIIconTextView
    }
    
    func loadData(data: String) {
        createIconTextPair()
    }
    
    private func createIconTextPair() {
        
        if paramsCount < 2 {
            return
        }
        
        var preIcon = firstIcon
        var preLabel = firstText
        
        for var index = 1; index < paramsCount; ++index {
            let icon = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            icon.contentMode = firstIcon.contentMode
            addSubview(icon)
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            label.font = firstText.font
            label.textColor = firstText.textColor
            addSubview(label)
            
            layout(preIcon, icon) {preIcon, icon in
                icon.width == preIcon.width
                icon.height == preIcon.height
                icon.leading == preIcon.leading
                icon.top == preIcon.bottom + iconMaginTop.constant
            }
            
            layout(preLabel, icon, label) {preLabel, icon, label in
                label.width == preLabel.width
                label.height == preLabel.height
                label.leading == preLabel.leading
                label.top == icon.top + textTopToIcon.constant
            }
            
            icon.image = UIImage(named: "location_icon_white")
            label.text = "1901A, Wanda Plaza, Haidian District"
            frame.size.height += (firstIcon.height + iconMaginTop.constant)
            
            preIcon = icon
            preLabel = label
        }
    }
}
