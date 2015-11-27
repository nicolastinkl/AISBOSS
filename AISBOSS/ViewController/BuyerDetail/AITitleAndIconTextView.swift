//
//  AITitleAndIconTextView.swift
//  AIVeris
//
//  Created by Rocky on 15/11/24.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class AITitleAndIconTextView: ServiceParamlView {

    static let TITLE_HEIGHT: CGFloat = 17
    static let ICON_VERTICAL_SPACE: CGFloat = 8
  
    @IBOutlet weak var firstTitle: UILabel!
    @IBOutlet weak var firstIcon: UIImageView!
    @IBOutlet weak var firstText: UILabel!
    
    @IBOutlet weak var titleMaginTop: NSLayoutConstraint!
    @IBOutlet weak var iconMaginTop: NSLayoutConstraint!
    @IBOutlet weak var textTopToIcon: NSLayoutConstraint!
    @IBOutlet weak var textMaginRight: NSLayoutConstraint!
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    
    private var iconTextDic: [[UIImageView: UILabel]]!
    
    override func awakeFromNib() {
        firstTitle.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(48))
        firstText.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(31))
    }
    
    static func createInstance() -> AITitleAndIconTextView {
        return NSBundle.mainBundle().loadNibNamed("AITitleAndIconTextView", owner: self, options: nil).first  as! AITitleAndIconTextView
    }
    
    override func loadData(json jonsStr: String) {
        let jsonData = jonsStr.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let model = try ServiceCellProductParamModel(data: jsonData)
            
            loadData(model: model)
        } catch {
            
        }
        
    }
    
    func loadData(model data: ServiceCellProductParamModel) {        
        
        if data.param_list != nil && data.param_list.count > 0 {
            createIconTextPair(data.param_list)
        }
    }
    
    private func createIconTextPair(paramList: [AnyObject]) {
        
        var preIcon = firstIcon
        var preLabel = firstText
        
        for var index = 0; index < paramList.count; ++index {
            let model = paramList[index] as! ServiceCellStadandParamModel
            
            if index == 0 {
                frame.size.height += AITitleAndIconTextView.TITLE_HEIGHT
                
                if model.product_name != nil && model.product_name != "" {
                    firstTitle.hidden = false
                    firstTitle.text = model.product_name
                    iconMaginTop.constant = AITitleAndIconTextView.ICON_VERTICAL_SPACE
                    firstIcon.setNeedsUpdateConstraints()
                }
            } else {
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
                    icon.top == preIcon.bottom + AITitleAndIconTextView.ICON_VERTICAL_SPACE
                }

                layout(preLabel, icon, label) {preLabel, icon, label in
                    label.width == preLabel.width
                    label.height == preLabel.height
                    label.leading == preLabel.leading
                    label.top == icon.top + textTopToIcon.constant
                }
                
                frame.size.height += (firstIcon.height + iconMaginTop.constant)
                
                preIcon = icon
                preLabel = label
            }
            
            preIcon.asyncLoadImage(model.param_icon)

            if model.param_name.hasPrefix("address") {
                preLabel.text = model.param_value
            } else {
                preLabel.textColor = UIColor.whiteColor()
                let str = model.param_name + " " + model.param_value
                let attStr = NSMutableAttributedString(string: str)
                
                attStr.addAttribute(NSFontAttributeName, value: AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(31)), range: NSMakeRange(0, model.param_name.length))
                attStr.addAttribute(NSFontAttributeName, value: AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(31)), range: NSMakeRange(model.param_name.length + 1, model.param_value.length))
                
                preLabel.attributedText = attStr
                
     //           preLabel.text = model.param_name + " " + model.param_value
            }
        }
    }
}
