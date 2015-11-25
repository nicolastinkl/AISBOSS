//
//  ServiceCardDetailShopping.swift
//  AIVeris
//
//  Created by 刘先 on 15/11/20.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class ServiceCardDetailShopping: UIView {
    //MARK: - uiViews
    var shoppingViewContainer : UIView!
    var titleLabel : UILabel!
    
    
    var dataSource : ServiceCellShoppingModel?
    var shoppingListData : NSArray?
    
    //MARK: - Constants
    //sizes
    let TITLE_SHOPPING_MARGIN : CGFloat = 1
    let SHOPPING_LIST_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(50)
    let TITLE_TOP_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(24)
    let TITLE_HEIGHT : CGFloat = AITools.displaySizeFrom1080DesignSize(60)
    let VIEW_LEFT_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(98)
    let SHOPPING_ITEM_HEIGHT : CGFloat = AITools.displaySizeFrom1080DesignSize(150)

    
    //fonts
    let TITLE_TEXT_FONT : UIFont = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(48))
    
    func loadData(){
        let jsonString = "{\"product_name\":\"Shopping list for 8 weeks of pregnancy\",\"product_sub_name\":\"Supplments package\",\"item_list\":[{\"item_icon\":\"http://171.221.254.231:3000/upload/proposal/FKByrmpYrI5kn.png\",\"item_intro\":\"Vitafusion Fiber Plus Calcium PreNature Made Calcium 600 Mg, 220-Count\"},{\"item_icon\":\"http://171.221.254.231:3000/upload/proposal/FKByrmpYrI5kn.png\",\"item_intro\":\"Nature Made Prenatal Multi Vitaminalue Size, Tablets, 250-Count\"}]}"
        buildModel(jsonString)
        layoutView()
    }
    
    func buildModel(jsonString : String){
        dataSource = ServiceCellShoppingModel(string: jsonString, error: nil)
    }
    
    //MARK: - build views
    func buildTitle(){
        let text = dataSource?.product_sub_name
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.text = text
        titleLabel.font = TITLE_TEXT_FONT
        titleLabel.textColor = UIColor.whiteColor()
        self.addSubview(titleLabel)
        
        layout(titleLabel){
            titleLabel in
            titleLabel.topMargin == titleLabel.superview!.topMargin + TITLE_TOP_MARGIN
            titleLabel.leadingMargin == titleLabel.superview!.leadingMargin + VIEW_LEFT_MARGIN
            titleLabel.superview!.trailingMargin >= titleLabel.trailingMargin
            titleLabel.height == TITLE_HEIGHT
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
        
        constrain(shoppingViewContainer,titleLabel){
            shoppingViewContainer,titleLabel in

            distribute(by: TITLE_SHOPPING_MARGIN,vertically : titleLabel,shoppingViewContainer)
        }
    }
    
    func fixFrame(){
        let containerHeight = CGFloat((dataSource?.item_list.count)!) * SHOPPING_ITEM_HEIGHT
        self.frame.size.height = TITLE_HEIGHT + containerHeight + TITLE_TOP_MARGIN + 35
    }
    
    func layoutView(){
        buildTitle()
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
    let IMAGE_SIZE : CGFloat = AITools.displaySizeFrom1080DesignSize(98)
    let LABEL_TRAILLING : CGFloat = AITools.displaySizeFrom1080DesignSize(30)
    let VIEW_LEFT_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(110)
    let MAX_LABEL_TEXT_WIDTH : CGFloat = AITools.displaySizeFrom1080DesignSize(740)
    let LABEL_LINE_SPACING : CGFloat = AITools.displaySizeFrom1080DesignSize(24)

    //fonts
    let LABEL_TEXT_FONT : UIFont = AITools.myriadLightSemiCondensedWithSize(34/2.5)
    
    func loadData(shoppingItemModel : ServiceCellShoppingItemModel){
        dataSource = shoppingItemModel
        
        layoutView()
        
        let url = dataSource?.item_icon
        imageView.sd_setImageWithURL(url!.toURL(), placeholderImage: UIImage(named: "Placehold"))
        let text = dataSource?.item_intro
        descLabel.text = text
        
        adjustRowMargin(descLabel,lineSpacing : LABEL_LINE_SPACING)
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
        
        layout(imageView,descLabel){
            imageView,descLabel in
            imageView.width == IMAGE_SIZE
            imageView.height == IMAGE_SIZE
            imageView.centerY == imageView.superview!.centerY
            imageView.leadingMargin == imageView.superview!.leadingMargin + VIEW_LEFT_MARGIN
            
            distribute(by: IMAGE_LABEL_MARGIN, horizontally: imageView, descLabel)
            
            descLabel.centerY == imageView.centerY
            
            descLabel.superview!.trailingMargin == descLabel.trailingMargin + LABEL_TRAILLING
            //descLabel.topMargin == descLabel.superview!.topMargin
            //descLabel.bottomMargin == descLabel.superview!.bottomMargin
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