//
//  ServiceCardDetailIcon.swift
//  AIVeris
//  图标+文字的展现方式
//  Created by 刘先 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class ServiceCardDetailIcon: UIView {

    //MARK: - uiViews
    var titleLabel : UILabel!
    var timeIconImageView : UIImageView!
    var priceIconImageView : UIImageView!
    var calendaIconImageView : UIImageView!
    var timeLabelView : UILabel!
    var priceLabelView : UILabel!
    var calendaLabelView : UILabel!
    
    
    var dataSource : NSDictionary?

    //MARK: - Constants
    //sizes
    let VIEW_LEFT_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(98)
    let VIEW_TOP_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(56)
    let ICON_TITLE_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(40)
    let ICONS_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(194)
    let ICON_LABEL_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(34)
    //fonts
    let TITLE_TEXT_FONT : UIFont = AITools.myriadRegularWithSize(17)
    let ICON_DESC_FONT : UIFont = AITools.myriadRegularWithSize(17)
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - load data
    func loadData(){
        layoutView()
    }
    
    func layoutView(){
        buildTitle()
        buildIcon()
        buildIconDesc()
    }
    
    //MARK: - build views
    func buildTitle(){
        let text = "Service Coverage"
        let titleFrame = CGRectMake(0, 0, 0, 21)
        titleLabel = UILabel(frame: titleFrame)
        titleLabel.text = text
        titleLabel.font = TITLE_TEXT_FONT
        titleLabel.textColor = UIColor.whiteColor()
        self.addSubview(titleLabel)
        
        layout(titleLabel){titleLabel in
            titleLabel.leadingMargin == titleLabel.superview!.leadingMargin + VIEW_LEFT_MARGIN
            titleLabel.trailingMargin == titleLabel.superview!.trailingMargin
            titleLabel.topMargin == titleLabel.superview!.topMargin + VIEW_TOP_MARGIN
            titleLabel.height == 21
        }
    }
    
    func buildIcon(){
        timeIconImageView = UIImageView(frame : CGRectZero)
        priceIconImageView = UIImageView(frame : CGRectZero)
        calendaIconImageView = UIImageView(frame : CGRectZero)
        
        layout(timeIconImageView,priceIconImageView,calendaIconImageView){
            timeIconImageView,priceIconImageView,calendaIconImageView in
            priceIconImageView.centerY == priceIconImageView.superview!.centerY
            
            timeIconImageView.width == 60
            timeIconImageView.height == 60
            priceIconImageView.width == 60
            priceIconImageView.height == 60
            calendaIconImageView.width == 60
            calendaIconImageView.height == 60
            distribute(by: ICONS_MARGIN, horizontally: timeIconImageView, priceIconImageView, calendaIconImageView)
            align(baseline: timeIconImageView, priceIconImageView, calendaIconImageView)
        }
        
        constrain(titleLabel,timeIconImageView){
            titleLabel,timeIconImageView in
            titleLabel.bottomMargin == timeIconImageView.topMargin + ICON_TITLE_MARGIN
        }
    }
    
    func buildIconDesc(){
        
    }
}
