//
//  ServiceCardDetailIcon.swift
//  AIVeris
//  图标+文字的展现方式
//  Created by 刘先 on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class ServiceCardDetailIcon: ServiceParamlView {

    //MARK: - uiViews
    var titleLabel : UILabel!
    var timeIconImageView : UIImageView!
    var priceIconImageView : UIImageView!
    var calendarIconImageView : UIImageView!
    var timeLabelView : UILabel!
    var priceLabelView : UILabel!
    var calendarLabelView : UILabel!
    
    
    var dataSource : ServiceCellProductParamModel?

    //MARK: - Constants
    //sizes
    let ICON_SIZE : CGFloat = AITools.displaySizeFrom1080DesignSize(54)
    let VIEW_HEIGHT : CGFloat = AITools.displaySizeFrom1080DesignSize(187)
    let VIEW_LEFT_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(87)
    let VIEW_TOP_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(41)
    let ICON_TITLE_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(30)
    let ICONS_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(220)
    let ICON_LABEL_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(10)
    //fonts
    let TITLE_TEXT_FONT : UIFont = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(48))
    let ICON_DESC_FONT : UIFont = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(42))
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func loadDataWithModelArray(models: ServiceCellProductParamModel!) {
        dataSource = models
        layoutView()
        
    }
    
    //MARK: - load data
    override func loadData(json jsonString : String){
        buildModel(jsonString)
        
        layoutView()
        
    }
    
    func buildModel(jsonString : String){
        dataSource = ServiceCellProductParamModel(string: jsonString, error: nil)
    }
    
    func layoutView(){
        
        //self.backgroundColor = UIColor.redColor()
        buildTitle()
        buildIcon()
        buildIconDesc()
        fixFrame()
        
        titleLabel.text = dataSource?.product_name
        for var i = 0 ; i < dataSource?.param_list.count ; i++ {
            let paramModel = dataSource?.param_list[i] as! ServiceCellStadandParamModel
            if paramModel.param_key == "time" {
                timeIconImageView.image = UIImage(named: "icon_time_big")
                timeLabelView.text = paramModel.param_value
            }
            else if paramModel.param_key == "price" {
                priceIconImageView.image = UIImage(named: "icon_price_big")
                priceLabelView.text = paramModel.param_value
            }
            else if paramModel.param_key == "calendar" {
                calendarIconImageView.image = UIImage(named: "icon_calenda_big")
                calendarLabelView.text = paramModel.param_value
            }
        }
    }
    
    //MARK: - build views
    func buildTitle(){
        
        let titleFrame = CGRectMake(0, 0, 0, 21)
        titleLabel = UILabel(frame: titleFrame)
        titleLabel.font = TITLE_TEXT_FONT
        titleLabel.textColor = UIColor.whiteColor()
        self.addSubview(titleLabel)
        
        var heightAlisx:CGFloat = 0
        //print(dataSource?.product_name)
        if dataSource?.product_name.isEmpty == false {
            heightAlisx = 20
        }else{
            heightAlisx = 0
        }
        constrain(titleLabel){titleLabel in
            titleLabel.leadingMargin == titleLabel.superview!.leadingMargin + VIEW_LEFT_MARGIN
            titleLabel.trailingMargin >= titleLabel.superview!.trailingMargin
            
            if dataSource?.product_name != nil || dataSource?.product_name != "" {
                titleLabel.top == titleLabel.superview!.top  + 5
            }else{
                titleLabel.topMargin == titleLabel.superview!.top - 20
            }
            
            titleLabel.height == heightAlisx
        }
    }
    
    func buildIcon(){
        timeIconImageView = UIImageView(frame : CGRectZero)
        priceIconImageView = UIImageView(frame : CGRectZero)
        calendarIconImageView = UIImageView(frame : CGRectZero)
        
        self.addSubview(timeIconImageView)
        self.addSubview(priceIconImageView)
        self.addSubview(calendarIconImageView)
        
        constrain(titleLabel,priceIconImageView){
            titleLabel,priceIconImageView in
            priceIconImageView.top == titleLabel.bottom + ICON_TITLE_MARGIN
 
        }
        
        constrain(timeIconImageView,priceIconImageView,calendarIconImageView){
            timeIconImageView,priceIconImageView,calendarIconImageView in
            priceIconImageView.centerX == priceIconImageView.superview!.centerX
            
            timeIconImageView.width == ICON_SIZE
            timeIconImageView.height == ICON_SIZE
            priceIconImageView.width == ICON_SIZE
            priceIconImageView.height == ICON_SIZE
            calendarIconImageView.width == ICON_SIZE
            calendarIconImageView.height == ICON_SIZE
            distribute(by: ICONS_MARGIN, horizontally: timeIconImageView, priceIconImageView, calendarIconImageView)
            align(top: timeIconImageView, priceIconImageView, calendarIconImageView)
        }
        
    }
    
    func buildIconDesc(){
        timeLabelView = UILabel(frame: CGRectZero)
        priceLabelView = UILabel(frame: CGRectZero)
        calendarLabelView = UILabel(frame: CGRectZero)
        
        timeLabelView.numberOfLines = 3
        timeLabelView.lineBreakMode = NSLineBreakMode.ByWordWrapping
        priceLabelView.numberOfLines = 3
        priceLabelView.lineBreakMode = NSLineBreakMode.ByWordWrapping
        calendarLabelView.numberOfLines = 3
        calendarLabelView.lineBreakMode = NSLineBreakMode.ByWordWrapping
        

        
        timeLabelView.textColor = UIColor.whiteColor()
        priceLabelView.textColor = UIColor.whiteColor()
        calendarLabelView.textColor = UIColor.whiteColor()
        
        timeLabelView.font = ICON_DESC_FONT
        priceLabelView.font = ICON_DESC_FONT
        calendarLabelView.font = ICON_DESC_FONT
        
        timeLabelView.textAlignment = NSTextAlignment.Center
        priceLabelView.textAlignment = NSTextAlignment.Center
        calendarLabelView.textAlignment = NSTextAlignment.Center
        
        timeLabelView.contentMode = UIViewContentMode.Top
        priceLabelView.contentMode = UIViewContentMode.Top
        calendarLabelView.contentMode = UIViewContentMode.Top
        
        self.addSubview(timeLabelView)
        self.addSubview(priceLabelView)
        self.addSubview(calendarLabelView)
        
        let widthS:CGFloat = 45
        let widthSpace:CGFloat = 110
        constrain(timeLabelView,timeIconImageView){
            timeLabelView,timeIconImageView in
            timeLabelView.height == widthS
            //distribute(by: ICON_LABEL_MARGIN, vertically: timeIconImageView,timeLabelView)
            timeIconImageView.bottom ==  timeLabelView.top - ICON_LABEL_MARGIN
            timeLabelView.centerX == timeIconImageView.centerX
            timeLabelView.width == widthSpace
        }        
        
        constrain(priceLabelView,priceIconImageView){
            priceLabelView,priceIconImageView in
            priceLabelView.height == widthS
            priceLabelView.top == priceIconImageView.bottom + ICON_LABEL_MARGIN
            priceLabelView.centerX == priceIconImageView.centerX
            priceLabelView.width == widthSpace
        }
        
        constrain(calendarLabelView,calendarIconImageView){
            calendarLabelView,calendarIconImageView in
            calendarLabelView.height == widthS
            calendarLabelView.top == calendarIconImageView.bottom + ICON_LABEL_MARGIN
            calendarLabelView.centerX == calendarIconImageView.centerX
            calendarLabelView.width == widthSpace
        }
    }
    
    func fixFrame(){
        
         self.frame.size.height = VIEW_HEIGHT + ICON_LABEL_MARGIN
        
    }
}

//上面图标下面文字标签的view
class ServiceCardDetailIconLabelView : UIView{
    var iconView : UIImageView!
    var labelView : UILabel!
    
    func layoutView(){
        iconView = UIImageView(frame: CGRectZero)
        labelView = UILabel(frame: CGRectZero)
        
        constrain(iconView,labelView){
            iconView,labelView in
            
        }
    }
}
