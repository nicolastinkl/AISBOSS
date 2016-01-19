//
// VerticalIconLabel.swift
// AIVeris
//
// Created by admin on 1/5/16.
// Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit
import SnapKit

class VerticalIconLabel: UIView {
	
	static let DEFAULT_FRAME = CGRect(x: 0, y: 0, width: 100, height: 100)
	
	var image: UIImage? {
		set {
			self.imageView.image = newValue
		}
		get {
			return self.imageView.image
		}
	}
	
	var text: String? {
		set {
			self.label.text = newValue
			setNeedsLayout()
			layoutIfNeeded()
		}
		get {
			return self.label.text
		}
	}
	var imageWidth : CGFloat = AITools.displaySizeFrom1080DesignSize(54) {
		didSet {
			setNeedsLayout()
			layoutIfNeeded()
		}
	}
	lazy var imageView: UIImageView = {
		let result = UIImageView()
		self.addSubview(result)
		return result
	}()
	
	lazy var label: UILabel = {
		let result = UILabel()
		result.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(42)) ;
		result.textColor = UIColor.whiteColor()
		result.textAlignment = .Center
		self.addSubview(result)
		return result
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	override var frame: CGRect {
		didSet {
			setNeedsLayout()
			layoutIfNeeded()
		}
	}
	
	override func layoutSubviews() {
		imageView.frame = CGRectMake(width / 2 - imageWidth / 2, 4, imageWidth, imageWidth)
		label.sizeToFit()
		label.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 4, width, label.height)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
