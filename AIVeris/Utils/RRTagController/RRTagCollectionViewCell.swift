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
	
	lazy var textContent: UILabel! = { [unowned self] in
		let textContent = UILabel(frame: CGRectZero)
		textContent.layer.masksToBounds = true
		
		textContent.layer.borderColor = Constants.blue.CGColor
		textContent.font = Constants.font
		textContent.textAlignment = NSTextAlignment.Center
        self.contentView.addSubview(textContent)
		return textContent
	}()
	
	lazy var addIcon: UIImageView = { [unowned self] in
		let result = UIImageView(image: UIImage(named: "addTag")!)
		self.contentView.addSubview(result)
		return result
	}()
		
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
        _ = textContent
        _ = addIcon
		layer.borderWidth = 2 / 3
		layer.borderColor = Constants.blue.CGColor
	}
	
	func initContent(tag: RequirementTag) {
		addIcon.hidden = true
		textContent.text = tag.textContent
		selected = tag.selected
        animateSelection(tag.selected)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = CGRectGetHeight(bounds) / 2
		if addIcon.hidden == false {
            textContent.sizeToFit()
            addIcon.setOrigin(CGPoint(x: 4, y: 4))
            textContent.setX(addIcon.right + 8)
            textContent.setCenterY(addIcon.centerY)
		} else {
            textContent.frame = CGRectOffset(bounds, 0, 0)
		}
	}
	
	func initAddButtonContent() {
		textContent.text = "Add Tag"
        selected = false
        animateSelection(false)
		addIcon.hidden = false
	}
	
	func animateSelection(selection: Bool) {
		selected = selection
		layer.backgroundColor = (selected == true) ? colorSelectedTag.CGColor : colorUnselectedTag.CGColor
		textContent.textColor = (selected == true) ? colorTextSelectedTag : colorTextUnSelectedTag
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
