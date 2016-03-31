//
//  RRTagCollectionViewCell.swift
//  RRTagController
//
//  Created by Remi Robert on 20/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

let RRTagCollectionViewCellIdentifier = "RRTagCollectionViewCellIdentifier"
let RRTagCollectionViewCellAddTagSize = CGSize(width: 120, height: 40)

class RRTagCollectionViewCell: UICollectionViewCell {
	
	struct Constants {
		static let font = AITools.myriadSemiCondensedWithSize(58 / 3)
		static let blue = UIColorFromHex(0x0f86e8)
	}
	
	lazy var textContent: UILabel! = {
		let textContent = UILabel(frame: CGRectZero)
		textContent.layer.masksToBounds = true
		
		textContent.layer.borderColor = Constants.blue.CGColor
		textContent.font = Constants.font
		textContent.textAlignment = NSTextAlignment.Center
		return textContent
	}()
    
    var addIcon: UIImageView = UIImageView(image: UIImage(named: "addTag"))
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
//        textContent.layer.borderWidth = 2 / 3
		layer.borderWidth = 2 / 3
        layer.borderColor = Constants.blue.CGColor
	}
	
	func initContent(tag: RequirementTag) {
		contentView.addSubview(textContent)
        addIcon.hidden = true
		textContent.text = tag.textContent
		textContent.sizeToFit()
		textContent.frame.size.width = textContent.frame.size.width + 30
		textContent.frame.size.height = textContent.frame.size.height + 20
		selected = tag.selected
		backgroundColor = UIColor.clearColor()
		layer.backgroundColor = (selected == true) ? colorSelectedTag.CGColor : colorUnselectedTag.CGColor
		textContent.textColor = (selected == true) ? colorTextSelectedTag : colorTextUnSelectedTag
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = CGRectGetHeight(bounds) / 2
	}
	
	func initAddButtonContent() {
		contentView.addSubview(textContent)
		textContent.text = "Add Tag"
		textContent.sizeToFit()
		textContent.frame.size = RRTagCollectionViewCellAddTagSize
		backgroundColor = UIColor.clearColor()

        addIcon.hidden = false
		contentView.addSubview(addIcon)
		addIcon.setOrigin(CGPoint(x: 4, y: 4))
		textContent.setX(addIcon.right + 8)
		textContent.setCenterY(addIcon.centerY)
		textContent.layer.backgroundColor = colorUnselectedTag.CGColor
		textContent.textColor = colorTextUnSelectedTag
	}
	
	func animateSelection(selection: Bool) {
		selected = selection
		
		textContent.frame.size = CGSizeMake(textContent.frame.size.width - 20, textContent.frame.size.height - 20)
		textContent.frame.origin = CGPointMake(textContent.frame.origin.x + 10, textContent.frame.origin.y + 10)
		layer.backgroundColor = (selected == true) ? colorSelectedTag.CGColor : colorUnselectedTag.CGColor
		textContent.textColor = (selected == true) ? colorTextSelectedTag : colorTextUnSelectedTag
		textContent.frame.size = CGSizeMake(textContent.frame.size.width + 20, textContent.frame.size.height + 20)
		textContent.center = CGPointMake(contentView.frame.size.width / 2, contentView.frame.size.height / 2)
	}
	
	class func contentHeight(content: String, maxWidth: CGFloat) -> CGSize {
		let styleText = NSMutableParagraphStyle()
		styleText.alignment = NSTextAlignment.Center
		let attributs = [NSParagraphStyleAttributeName: styleText, NSFontAttributeName: Constants.font]
		let sizeBoundsContent = content.boundingRectWithSize(CGSizeMake(maxWidth,
			UIScreen.mainScreen().bounds.size.height), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributs, context: nil)
		return CGSizeMake(sizeBoundsContent.width + 30, sizeBoundsContent.height + 20)
	}
}
