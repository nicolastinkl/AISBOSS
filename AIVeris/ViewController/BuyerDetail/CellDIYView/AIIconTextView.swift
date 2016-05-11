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
    
    func loadData(json jonsStr: String) {
        let jsonData = jonsStr.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let model = try ServiceCellStandardParamListModel(data: jsonData)
            
            loadData(model: model)
        } catch {
            
        }
        
    }
    
    func loadData(model data: ServiceCellStandardParamListModel) {
        let list = data.param_list
        if list != nil && list.count > 0 {
            createIconTextPair(list)
        }
    }
    
    private func createIconTextPair(paramList: [AnyObject]) {
        
        var preIcon = firstIcon
        var preLabel = firstText
        
        for index in 0 ..< paramList.count {
            let model = paramList[index] as! ServiceCellStadandParamModel
            
            if index == 0 {
                preIcon.asyncLoadImage(model.param_icon)
                preLabel.text = model.param_value
            } else {
                let icon = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                icon.contentMode = firstIcon.contentMode
                addSubview(icon)
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                label.font = firstText.font
                label.textColor = firstText.textColor
                addSubview(label)
                
                constrain(preIcon, icon) {preIcon, icon in
                    icon.width == preIcon.width
                    icon.height == preIcon.height
                    icon.leading == preIcon.leading
                    icon.top == preIcon.bottom + iconMaginTop.constant
                }
                
                constrain(preLabel, icon, label) {preLabel, icon, label in
                    label.width == preLabel.width
                    label.height == preLabel.height
                    label.leading == preLabel.leading
                    label.top == icon.top + textTopToIcon.constant
                }
                
                frame.size.height += (firstIcon.height + iconMaginTop.constant)
                
                preIcon = icon
                preLabel = label
            }
        }
    }
    
}
