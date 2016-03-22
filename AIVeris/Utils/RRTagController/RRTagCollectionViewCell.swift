//
//  RRTagCollectionViewCell.swift
//  RRTagController
//
//  Created by Remi Robert on 20/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

let RRTagCollectionViewCellIdentifier = "RRTagCollectionViewCellIdentifier"
let RRTagCollectionViewCellAddTagSize = CGSize(width:120, height:40)

class RRTagCollectionViewCell: UICollectionViewCell {
    
    lazy var textContent: UILabel! = {
        let textContent = UILabel(frame: CGRectZero)
        textContent.layer.masksToBounds = true
        textContent.layer.cornerRadius = 20
        textContent.layer.borderWidth = 2
        textContent.layer.borderColor = UIColor(red: 0.1098, green: 0.4353, blue: 0.8706, alpha: 1.0).CGColor
        textContent.font = UIFont.boldSystemFontOfSize(17)
        textContent.textAlignment = NSTextAlignment.Center
        return textContent
    }()
    
    func initContent(tag: Tag) {
        self.contentView.addSubview(textContent)
        textContent.text = tag.textContent
        textContent.sizeToFit()
        textContent.frame.size.width = textContent.frame.size.width + 30
        textContent.frame.size.height = textContent.frame.size.height + 20
        selected = tag.isSelected
        textContent.backgroundColor = UIColor.clearColor()
        self.textContent.layer.backgroundColor = (self.selected == true) ? colorSelectedTag.CGColor : colorUnselectedTag.CGColor
        self.textContent.textColor = (self.selected == true) ? colorTextSelectedTag : colorTextUnSelectedTag
    }
    
    func initAddButtonContent() {
        self.contentView.addSubview(textContent)
        textContent.text = "Add Tag"
        textContent.sizeToFit()
        textContent.frame.size = RRTagCollectionViewCellAddTagSize
        textContent.backgroundColor = UIColor.clearColor()
//        self.textContent.layer.backgroundColor = UIColor.grayColor().CGColor
        self.textContent.layer.backgroundColor = colorUnselectedTag.CGColor
        self.textContent.textColor = colorTextUnSelectedTag
    }
    
    func animateSelection(selection: Bool) {
        selected = selection
    
        self.textContent.frame.size = CGSizeMake(self.textContent.frame.size.width - 20, self.textContent.frame.size.height - 20)
        self.textContent.frame.origin = CGPointMake(self.textContent.frame.origin.x + 10, self.textContent.frame.origin.y + 10)
//        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.4, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.textContent.layer.backgroundColor = (self.selected == true) ? colorSelectedTag.CGColor : colorUnselectedTag.CGColor
            self.textContent.textColor = (self.selected == true) ? colorTextSelectedTag : colorTextUnSelectedTag
            self.textContent.frame.size = CGSizeMake(self.textContent.frame.size.width + 20, self.textContent.frame.size.height + 20)
            self.textContent.center = CGPointMake(self.contentView.frame.size.width / 2, self.contentView.frame.size.height / 2)
//        }, completion: nil)
    }
    
    class func contentHeight(content: String, maxWidth: CGFloat) -> CGSize {
        let styleText = NSMutableParagraphStyle()
        styleText.alignment = NSTextAlignment.Center
        let attributs = [NSParagraphStyleAttributeName:styleText, NSFontAttributeName:UIFont.boldSystemFontOfSize(17)]
        let sizeBoundsContent = content.boundingRectWithSize(CGSizeMake(maxWidth,
            UIScreen.mainScreen().bounds.size.height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributs, context: nil)
        return CGSizeMake(sizeBoundsContent.width + 30, sizeBoundsContent.height + 20)
    }
}

