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
    
    
    var dataSource : ServiceCellShoppingModel?
    
    //MARK: - Constants
    //sizes
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
    let TITLE_TEXT_FONT : UIFont = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(42))
    let MAIN_TITLE_TEXT_FONT : UIFont = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(48))
    
    override func loadData(json jsonString : String){
        buildModel(jsonString)
        layoutView()
    }
    
    func buildModel(jsonString : String){
        dataSource = ServiceCellShoppingModel(string: jsonString, error: nil)
    }
    
    //MARK: - build views
    func buildTitle(){
        let text = dataSource?.product_name
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.text = text
        titleLabel.font = MAIN_TITLE_TEXT_FONT
        titleLabel.textColor = UIColor.whiteColor()
        self.addSubview(titleLabel)
        
        divideLineView = UIView(frame: CGRectZero)
        divideLineView.alpha = 0.38
        divideLineView.backgroundColor = UIColor.whiteColor()
        self.addSubview(divideLineView)
        
        layout(titleLabel, divideLineView){
            titleLabel, divideLineView in
            titleLabel.topMargin == titleLabel.superview!.topMargin + VIEW_TOP_MARGIN
            titleLabel.leadingMargin == titleLabel.superview!.leadingMargin + MAIN_TITLE_LEFT_MARGIN
            titleLabel.superview!.trailingMargin >= titleLabel.trailingMargin
            titleLabel.height == MAIN_TITLE_HEIGHT
            
            divideLineView.height == 0.5
            divideLineView.leadingMargin == divideLineView.superview!.leadingMargin + DIVIDE_MARGIN
            divideLineView.superview!.trailingMargin == divideLineView.trailingMargin + DIVIDE_MARGIN
            distribute(by: 0, vertically : titleLabel, divideLineView)
        }
    }
    
    func buildSubTitle(){
        let text = dataSource?.product_sub_name
        subTitleLabel = UILabel(frame: CGRectZero)
        subTitleLabel.text = text
        subTitleLabel.font = TITLE_TEXT_FONT
        subTitleLabel.textColor = UIColor.whiteColor()
        self.addSubview(subTitleLabel)
        
        layout(subTitleLabel){
            subTitleLabel in
            //subTitleLabel.topMargin == subTitleLabel.superview!.topMargin + TITLE_TOP_MARGIN
            subTitleLabel.leadingMargin == subTitleLabel.superview!.leadingMargin + SUB_TITLE_LEFT_MARGIN
            subTitleLabel.superview!.trailingMargin >= subTitleLabel.trailingMargin
            subTitleLabel.height == TITLE_HEIGHT
        }
        
        constrain(titleLabel,subTitleLabel){
            titleLabel,subTitleLabel in
            distribute(by: TITLE_TOP_MARGIN, vertically : titleLabel,subTitleLabel)
        }
    }
    
    func buildShoppingListContainer(){
        shoppingViewContainer = UIView(frame: CGRectZero)
        self.addSubview(shoppingViewContainer)
        for var index = 0; index < dataSource?.item_list.count; index++ {
            let cellView : SCDShoppingListCellView = SCDShoppingListCellView(frame: CGRectZero)
            let serviceItemModel = dataSource?.item_list[index] as! ServiceCellShoppingItemModel
            cellView.loadData(serviceItemModel)
            shoppingViewContainer.addSubview(cellView)
            
            layout(cellView){
                cellView in
                cellView.leadingMargin == cellView.superview!.leadingMargin
                cellView.trailingMargin == cellView.trailingMargin
                cellView.height == SHOPPING_ITEM_HEIGHT
                cellView.topMargin == cellView.superview!.topMargin + CGFloat(index) * SHOPPING_ITEM_HEIGHT
            }
        }
        
        let containerHeight = CGFloat((dataSource?.item_list.count)!) * SHOPPING_ITEM_HEIGHT
        shoppingViewContainer.frame.size.height = containerHeight
        
        layout(shoppingViewContainer){
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
        let containerHeight = CGFloat((dataSource?.item_list.count)!) * SHOPPING_ITEM_HEIGHT
        self.frame.size.height = TITLE_HEIGHT + containerHeight + TITLE_TOP_MARGIN + VIEW_TOP_MARGIN + MAIN_TITLE_HEIGHT + 15
    }
    
    func layoutView(){
        buildTitle()
        buildSubTitle()
        buildShoppingListContainer()
        fixFrame()
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
        
        layout(imageView, descLabel) {
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