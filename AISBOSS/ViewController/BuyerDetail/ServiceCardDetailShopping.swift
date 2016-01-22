//
//  ServiceCardDetailShopping.swift
//  AIVeris
//
//  Created by 刘先 on 15/11/20.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class ServiceCardDetailShopping: ServiceParamlView {
    //MARK: - uiViews
    var shoppingViewContainer : UIView!
    var titleLabel : UILabel!
    var subTitleLabel : UILabel!
    var divideLineView : UIView!
    
    var timeIconImageView : UIImageView!
    var priceIconImageView : UIImageView!
    var calendarIconImageView : UIImageView!
    var timeLabelView : UILabel!
    var priceLabelView : UILabel!
    var calendarLabelView : UILabel!
    
    
    var dataSource : ServiceCellProductParamModel?
    
    //MARK: - Constants
    //sizes
    //sizes
    let ICON_SIZE : CGFloat = AITools.displaySizeFrom1080DesignSize(54)
    let VIEW_HEIGHT : CGFloat = AITools.displaySizeFrom1080DesignSize(187)
    let VIEW_LEFT_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(87)
    let VIEW_TOP_MARGIN_Super : CGFloat = AITools.displaySizeFrom1080DesignSize(41)
    let ICON_TITLE_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(30)
    let ICONS_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(220)
    let ICON_LABEL_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(10)
    let ICON_LABEL_MARGIN_SUPER : CGFloat = 50
    
    let VIEW_TOP_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(20)
    let MAIN_TITLE_LEFT_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(87)
    let DIVIDE_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(20)
    let SUB_TITLE_LEFT_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(90)
    let MAIN_TITLE_HEIGHT : CGFloat = AITools.displaySizeFrom1080DesignSize(113 - 24)
    
    let TITLE_SHOPPING_MARGIN : CGFloat = 1
    let SHOPPING_LIST_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(34)
    let TITLE_TOP_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(24)
    let TITLE_HEIGHT : CGFloat = AITools.displaySizeFrom1080DesignSize(60)
    
    let SHOPPING_ITEM_HEIGHT : CGFloat = AITools.displaySizeFrom1080DesignSize(126)

    
    //fonts
    let ICON_DESC_FONT : UIFont = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(42))
    
    let TITLE_TEXT_FONT : UIFont = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(42))
    let MAIN_TITLE_TEXT_FONT : UIFont = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(48))
    
    override func loadData(json jsonString : String){
        buildModel(jsonString)
        layoutView()
    }
    
    func layoutView(){
        buildTitle()
        if self.dataSource?.param_list.count > 0 {
            buildIcon()
            buildIconDesc()
        }
        buildSubTitle()
        buildShoppingListContainer()
        fixFrame()
        
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
        
        timeLabelView.textColor = UIColor.whiteColor()
        priceLabelView.textColor = UIColor.whiteColor()
        calendarLabelView.textColor = UIColor.whiteColor()
        
        timeLabelView.font = ICON_DESC_FONT
        priceLabelView.font = ICON_DESC_FONT
        calendarLabelView.font = ICON_DESC_FONT
        
        self.addSubview(timeLabelView)
        self.addSubview(priceLabelView)
        self.addSubview(calendarLabelView)
        
        
        constrain(timeLabelView,timeIconImageView){
            timeLabelView,timeIconImageView in
            timeLabelView.height == 21
            //distribute(by: ICON_LABEL_MARGIN, vertically: timeIconImageView,timeLabelView)
            timeIconImageView.bottom ==  timeLabelView.top - ICON_LABEL_MARGIN
            timeLabelView.centerX == timeIconImageView.centerX
        }
        
        
        constrain(priceLabelView,priceIconImageView){
            priceLabelView,priceIconImageView in
            priceLabelView.height == 21
            priceLabelView.top == priceIconImageView.bottom + ICON_LABEL_MARGIN
            priceLabelView.centerX == priceIconImageView.centerX
        }
        
        constrain(calendarLabelView,calendarIconImageView){
            calendarLabelView,calendarIconImageView in
            calendarLabelView.height == 21
            calendarLabelView.top == calendarIconImageView.bottom + ICON_LABEL_MARGIN
            calendarLabelView.centerX == calendarIconImageView.centerX
        }
    }
    
    
    
    override func loadDataWithModelArray(models: ServiceCellProductParamModel!) {
        dataSource = models
        layoutView()
        
    }
    
    func buildModel(jsonString : String){
        //dataSource = ServiceCellShoppingModel(string: jsonString, error: nil)
    }    
    
    func addIconCollectionView(iconCollectionView: UIView){
        
    }
    
    
    //MARK: - build views
    func buildTitle(){
        let Titles = dataSource?.product_name
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.text = Titles
        titleLabel.font = MAIN_TITLE_TEXT_FONT
        titleLabel.textColor = UIColor.whiteColor()
        self.addSubview(titleLabel)
        
        divideLineView = UIView(frame: CGRectZero)
        divideLineView.alpha = 0.38
        divideLineView.backgroundColor = UIColor.whiteColor()
        self.addSubview(divideLineView)
        
        constrain(titleLabel, divideLineView){
            titleLabel, divideLineView in
            titleLabel.topMargin == titleLabel.superview!.topMargin + VIEW_TOP_MARGIN
            titleLabel.leadingMargin == titleLabel.superview!.leadingMargin + MAIN_TITLE_LEFT_MARGIN
            titleLabel.superview!.trailingMargin >= titleLabel.trailingMargin
            titleLabel.height == MAIN_TITLE_HEIGHT
            
            divideLineView.height == 0.5
            divideLineView.leadingMargin == divideLineView.superview!.leadingMargin + DIVIDE_MARGIN
            divideLineView.superview!.trailingMargin == divideLineView.trailingMargin + DIVIDE_MARGIN
//            divideLineView.topMargin == divideLineView.superview!.topMargin + 50
            distribute(by: ICON_LABEL_MARGIN_SUPER + 15, vertically : titleLabel, divideLineView)
        }
    }
    
    func buildSubTitle(){
        let text = dataSource?.product_sub_name
        subTitleLabel = UILabel(frame: CGRectZero)
        subTitleLabel.text = text
        subTitleLabel.font = TITLE_TEXT_FONT
        subTitleLabel.textColor = UIColor.whiteColor()
        self.addSubview(subTitleLabel)
        
        constrain(subTitleLabel,divideLineView){
            subTitleLabel,divideView in
            subTitleLabel.top == divideView.top + TITLE_TOP_MARGIN
            subTitleLabel.leadingMargin == subTitleLabel.superview!.leadingMargin + SUB_TITLE_LEFT_MARGIN
            subTitleLabel.superview!.trailingMargin >= subTitleLabel.trailingMargin
            subTitleLabel.height == TITLE_HEIGHT
            //distribute(by: 0, vertically : divideView, subTitleLabel)
        }
    }
    
    func buildShoppingListContainer(){
        
        shoppingViewContainer = UIView(frame: CGRectZero)
        self.addSubview(shoppingViewContainer)
        for var index = 0; index < dataSource?.item_list.count; index++ {
            
            let cellView = SCDShoppingListCellView(frame: CGRectZero)
            let serviceItemModel = dataSource?.item_list[index] as! ServiceCellShoppingItemModel
            cellView.loadData(serviceItemModel)
            shoppingViewContainer.addSubview(cellView)
            
            constrain(cellView){
                cellView in
                cellView.leadingMargin == cellView.superview!.leadingMargin
                cellView.trailingMargin == cellView.trailingMargin
                cellView.height == SHOPPING_ITEM_HEIGHT
                cellView.topMargin == cellView.superview!.topMargin + CGFloat(index) * SHOPPING_ITEM_HEIGHT
            }
        }
        
        let containerHeight = CGFloat((dataSource?.item_list.count)!) * SHOPPING_ITEM_HEIGHT
        shoppingViewContainer.frame.size.height = containerHeight
        
        constrain(shoppingViewContainer){
            shoppingViewContainer in
            //shoppingViewContainer.height == containerHeight
            shoppingViewContainer.leadingMargin == shoppingViewContainer.superview!.leadingMargin
            shoppingViewContainer.trailingMargin == shoppingViewContainer.superview!.trailingMargin
            shoppingViewContainer.bottomMargin == shoppingViewContainer.superview!.bottomMargin
        }
        
        constrain(shoppingViewContainer,subTitleLabel){
            shoppingViewContainer,subTitleLabel in

            distribute(by: TITLE_SHOPPING_MARGIN,vertically : subTitleLabel,shoppingViewContainer)
        }
    }
    
    func fixFrame(){
        let containerHeight = CGFloat((dataSource?.param_list.count)!) * SHOPPING_ITEM_HEIGHT
        self.frame.size.height = TITLE_HEIGHT + containerHeight + TITLE_TOP_MARGIN + VIEW_TOP_MARGIN + MAIN_TITLE_HEIGHT + 15 + ICON_LABEL_MARGIN_SUPER
    }
    
   

}


class SCDShoppingListCellView : UIView {
    
    //MARK: - uiViews
    var imageView : UIImageView!
    var descLabel : UILabel!
    
    
    var dataSource : ServiceCellShoppingItemModel?

    //MARK: - Constants
    //sizes
    let IMAGE_LABEL_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(24)
    let IMAGE_SIZE : CGFloat = AITools.displaySizeFrom1080DesignSize(84)
    let LABEL_TRAILLING : CGFloat = AITools.displaySizeFrom1080DesignSize(30)
    let VIEW_LEFT_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(90)
    let MAX_LABEL_TEXT_WIDTH : CGFloat = AITools.displaySizeFrom1080DesignSize(740)
    let LABEL_LINE_SPACING : CGFloat = AITools.displaySizeFrom1080DesignSize(20)

    //fonts
    let LABEL_TEXT_FONT : UIFont = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(31))
    
    func loadData(shoppingItemModel : ServiceCellShoppingItemModel){
        dataSource = shoppingItemModel
        
        layoutView()
        
        let url = dataSource?.item_icon
        imageView.sd_setImageWithURL(url!.toURL(), placeholderImage: UIImage(named: "Placehold"))
        let text = dataSource?.item_intro
        descLabel.text = text
        
  //      adjustRowMargin(descLabel,lineSpacing : LABEL_LINE_SPACING)
    }
    
    
    func layoutView(){
        imageView = UIImageView(frame: CGRectZero)
        self.addSubview(imageView)
        
        descLabel = UILabel(frame: CGRectZero)
        descLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        descLabel.numberOfLines = 0
        descLabel.textColor = UIColor.whiteColor()
        descLabel.font = LABEL_TEXT_FONT
        descLabel.preferredMaxLayoutWidth = MAX_LABEL_TEXT_WIDTH
        
        self.addSubview(descLabel)
        
        constrain(imageView, descLabel) {
            imageView, descLabel in
            imageView.width == IMAGE_SIZE
            imageView.height == IMAGE_SIZE
            imageView.centerY == imageView.superview!.centerY
            imageView.leadingMargin == imageView.superview!.leadingMargin + VIEW_LEFT_MARGIN
            
            distribute(by: IMAGE_LABEL_MARGIN, horizontally: imageView, descLabel)
            
            descLabel.top == imageView.top + 5
            
            descLabel.superview!.trailingMargin == descLabel.trailingMargin + LABEL_TRAILLING
        }
    }
    
    func adjustRowMargin(labelView : UILabel,lineSpacing : CGFloat){
        let text = labelView.text!
        let attributeString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        attributeString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, text.length))
        labelView.attributedText = attributeString
        labelView.sizeToFit()
    }
}