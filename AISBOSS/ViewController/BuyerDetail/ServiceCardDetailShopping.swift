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
    
    
    var dataSource : NSDictionary?
    var shoppingListData : NSArray?
    
    //MARK: - Constants
    //sizes
    let TITLE_SHOPPING_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(44)
    let SHOPPING_LIST_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(50)
    let TITLE_TOP_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(12)
    let TITLE_HEIGHT : CGFloat = AITools.displaySizeFrom1080DesignSize(60)
    let VIEW_LEFT_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(98)
    let SHOPPING_ITEM_HEIGHT : CGFloat = AITools.displaySizeFrom1080DesignSize(150)
    
    //fonts
    let TITLE_TEXT_FONT : UIFont = AITools.myriadLightSemiCondensedWithSize(48/2.5)
    
    func loadData(){
        shoppingListData = ["shoppingItem1","shoppingItem2"]
        layoutView()
    }
    
    //MARK: - build views
    func buildTitle(){
        let text = "Supplements package"
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.text = text
        titleLabel.font = TITLE_TEXT_FONT
        titleLabel.textColor = UIColor.whiteColor()
        self.addSubview(titleLabel)
        
        layout(titleLabel){
            titleLabel in
            titleLabel.topMargin == titleLabel.superview!.topMargin
            titleLabel.leadingMargin == titleLabel.superview!.leadingMargin
            titleLabel.trailingMargin >= titleLabel.superview!.trailingMargin
            titleLabel.height == TITLE_HEIGHT
        }
    }
    
    func buildShoppingListContainer(){
        shoppingViewContainer = UIView(frame: CGRectZero)
        self.addSubview(shoppingViewContainer)
        
        for var index = 0; index < shoppingListData?.count; index++ {
            let frame = CGRectMake(0, CGFloat(index) * SHOPPING_ITEM_HEIGHT, self.width, SHOPPING_ITEM_HEIGHT)
            let cellView : SCDShoppingListCellView = SCDShoppingListCellView(frame: frame)
            cellView.loadData()
            shoppingViewContainer.addSubview(cellView)
        }
        
        let containerHeight = CGFloat((shoppingListData?.count)!) * SHOPPING_ITEM_HEIGHT
        shoppingViewContainer.frame.size.height = containerHeight
        
        layout(shoppingViewContainer,titleLabel){
            shoppingViewContainer,titleLabel in
            
            shoppingViewContainer.height == containerHeight
            shoppingViewContainer.leadingMargin == shoppingViewContainer.superview!.leadingMargin
            shoppingViewContainer.trailingMargin >= shoppingViewContainer.superview!.trailingMargin
            shoppingViewContainer.bottomMargin == shoppingViewContainer.superview!.bottomMargin
            titleLabel.bottomMargin == shoppingViewContainer.topMargin
        }
    }
    
    func fixFrame(){
        self.frame.size.height = TITLE_HEIGHT + shoppingViewContainer.frame.maxY
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
    
    
    var dataSource : NSDictionary?

    //MARK: - Constants
    //sizes
    let IMAGE_LABEL_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(24)
    let IMAGE_SIZE : CGFloat = AITools.displaySizeFrom1080DesignSize(98)
    let LABEL_TRAILLING : CGFloat = AITools.displaySizeFrom1080DesignSize(12)

    //fonts
    let LABEL_TEXT_FONT : UIFont = AITools.myriadLightSemiCondensedWithSize(36/2.5)
    
    func loadData(){
        dataSource = ["url":"http://171.221.254.231:3000/upload/proposal/FKByrmpYrI5kn.png","text":"Vitafusion Fiber Plus Calcium PreNature Made Calcium 600 Mg, 22"]
        
        layoutView()
        
        let url = dataSource?.valueForKey("url") as! String
        imageView.sd_setImageWithURL(url.toURL(), placeholderImage: UIImage(named: "Placehold"))
        let text = dataSource?.valueForKey("text") as! String
        descLabel.text = text
    }
    
    
    func layoutView(){
        imageView = UIImageView(frame: CGRectZero)
        self.addSubview(imageView)
        
        descLabel = UILabel(frame: CGRectZero)
        descLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        descLabel.numberOfLines = 2
        descLabel.textColor = UIColor.whiteColor()
        descLabel.font = LABEL_TEXT_FONT
        self.addSubview(descLabel)
        
        layout(imageView,descLabel){
            imageView,descLabel in
            imageView.width == IMAGE_SIZE
            imageView.height == IMAGE_SIZE
            imageView.topMargin == imageView.superview!.topMargin
            imageView.leadingMargin == imageView.superview!.leadingMargin
            
            imageView.trailingMargin == descLabel.leadingMargin + IMAGE_LABEL_MARGIN
            imageView.centerY == descLabel.centerY
            descLabel.topMargin == descLabel.superview!.topMargin
            descLabel.trailingMargin == descLabel.superview!.trailingMargin
            descLabel.bottomMargin == descLabel.superview!.bottomMargin
        }
    }
}