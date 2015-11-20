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
    let ICON_SIZE : CGFloat = AITools.displaySizeFrom1080DesignSize(62)
    let VIEW_HEIGHT : CGFloat = AITools.displaySizeFrom1080DesignSize(300)
    let VIEW_LEFT_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(40)
    let VIEW_TOP_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(10)
    let ICON_TITLE_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(68)
    let ICONS_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(200)
    let ICON_LABEL_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(64)
    //fonts
    let TITLE_TEXT_FONT : UIFont = AITools.myriadSemiCondensedWithSize(56/2.5)
    let ICON_DESC_FONT : UIFont = AITools.myriadLightSemiCondensedWithSize(48/2.5)
    
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
        
        timeIconImageView.image = UIImage(named: "icon_time_big")
        priceIconImageView.image = UIImage(named: "icon_price_big")
        calendaIconImageView.image = UIImage(named: "icon_calenda_big")
        
        timeLabelView.text = "64 hours"
        priceLabelView.text = "$99/hours"
        calendaLabelView.text = "every 4 weeks"
    }
    
    func layoutView(){
        //self.backgroundColor = UIColor.redColor()
        buildTitle()
        buildIcon()
        buildIconDesc()
        fixFrame()
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
            titleLabel.leadingMargin == titleLabel.superview!.leadingMargin
            titleLabel.trailingMargin >= titleLabel.superview!.trailingMargin
            titleLabel.topMargin == titleLabel.superview!.topMargin
            titleLabel.height == 20
        }
    }
    
    func buildIcon(){
        timeIconImageView = UIImageView(frame : CGRectZero)
        priceIconImageView = UIImageView(frame : CGRectZero)
        calendaIconImageView = UIImageView(frame : CGRectZero)
        
        self.addSubview(timeIconImageView)
        self.addSubview(priceIconImageView)
        self.addSubview(calendaIconImageView)
        
        constrain(titleLabel,priceIconImageView){
            titleLabel,priceIconImageView in
            priceIconImageView.topMargin == titleLabel.bottomMargin + ICON_TITLE_MARGIN
        }
        
        layout(timeIconImageView,priceIconImageView,calendaIconImageView){
            timeIconImageView,priceIconImageView,calendaIconImageView in
            priceIconImageView.centerX == priceIconImageView.superview!.centerX
            
            timeIconImageView.width == ICON_SIZE
            timeIconImageView.height == ICON_SIZE
            priceIconImageView.width == ICON_SIZE
            priceIconImageView.height == ICON_SIZE
            calendaIconImageView.width == ICON_SIZE
            calendaIconImageView.height == ICON_SIZE
            distribute(by: ICONS_MARGIN, horizontally: timeIconImageView, priceIconImageView, calendaIconImageView)
            align(top: timeIconImageView, priceIconImageView, calendaIconImageView)
        }
        
    }
    
    func buildIconDesc(){
        timeLabelView = UILabel(frame: CGRectZero)
        priceLabelView = UILabel(frame: CGRectZero)
        calendaLabelView = UILabel(frame: CGRectZero)
        
        timeLabelView.textColor = UIColor.whiteColor()
        priceLabelView.textColor = UIColor.whiteColor()
        calendaLabelView.textColor = UIColor.whiteColor()
        
        timeLabelView.font = ICON_DESC_FONT
        priceLabelView.font = ICON_DESC_FONT
        calendaLabelView.font = ICON_DESC_FONT
        
        self.addSubview(timeLabelView)
        self.addSubview(priceLabelView)
        self.addSubview(calendaLabelView)
        
        
        layout(timeLabelView,timeIconImageView){
            timeLabelView,timeIconImageView in
            timeLabelView.height == 21
            timeLabelView.topMargin == timeIconImageView.bottomMargin + ICON_LABEL_MARGIN
            timeLabelView.centerX == timeIconImageView.centerX
        }
        
        layout(priceLabelView,priceIconImageView){
            priceLabelView,priceIconImageView in
            priceLabelView.height == 21
            priceLabelView.topMargin == priceIconImageView.bottomMargin + ICON_LABEL_MARGIN
            priceLabelView.centerX == priceIconImageView.centerX
        }
        
        layout(calendaLabelView,calendaIconImageView){
            calendaLabelView,calendaIconImageView in
            calendaLabelView.height == 21
            calendaLabelView.topMargin == calendaIconImageView.bottomMargin + ICON_LABEL_MARGIN
            calendaLabelView.centerX == calendaIconImageView.centerX
        }
    }
    
    func fixFrame(){
        self.frame.size.height = VIEW_HEIGHT
    }
}

//上面图标下面文字标签的view
class ServiceCardDetailIconLabelView : UIView{
    var iconView : UIImageView!
    var labelView : UILabel!
    
    func layoutView(){
        iconView = UIImageView(frame: CGRectZero)
        labelView = UILabel(frame: CGRectZero)
        
        layout(iconView,labelView){
            iconView,labelView in
            
        }
    }
}
