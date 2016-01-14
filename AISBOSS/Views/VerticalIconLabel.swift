//
// VerticalIconLabel.swift
// AIVeris
//
// Created by admin on 1/5/16.
// Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit
import SnapKit

enum VerticalIconType: Int {
	case Custom, Price;
	
	func image() -> UIImage? {
		switch self {
		case .Custom:
			return nil
		case .Price:
			return UIImage(named: "eye_enable") // tofix
		}
	}
}

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
        }
        get {
            return self.label.text
        }
    }
	
	lazy var imageView: UIImageView = {
		let result = UIImageView()
		self.addSubview(result)
        let ICON_SIZE : CGFloat = AITools.displaySizeFrom1080DesignSize(54)
        let VIEW_HEIGHT : CGFloat = AITools.displaySizeFrom1080DesignSize(257)
        
		result.snp_makeConstraints(closure: {(make) -> Void in
				make.centerX.equalTo(self)
                make.width.height.equalTo(ICON_SIZE)
				//make.top.equalTo(self).offset(20)
			})
		return result
	}()
	
	lazy var label: UILabel = {
		let result = UILabel()
		result.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(42)) ;
		result.textColor = UIColor.whiteColor()
		result.textAlignment = .Center
		self.addSubview(result)
		result.snp_makeConstraints(closure: {(make) -> Void in
				// TODO:
				make.centerX.equalTo(self)
				make.top.equalTo(self).offset(25)
			})
		return result
	}()
	
	var type: VerticalIconType {
		didSet {
			imageView.image = type.image()
		}
	}
	
	init(type: VerticalIconType, text: String, frame: CGRect = DEFAULT_FRAME) {
		self.type = type
		super.init(frame: frame)
		self.label.text = text
		self.imageView.image = type.image()
	}
    
    override init(frame: CGRect) {
        self.type = .Custom
        super.init(frame: frame)
    }
	
	init(image: UIImage, text: String, frame: CGRect = DEFAULT_FRAME) {
		self.type = .Custom
		super.init(frame: frame)
		self.label.text = text
		self.imageView.image = image
	}
	
	override var frame: CGRect {
		get {
			return super.frame
		}
		set {
			super.frame = newValue
			self.label.preferredMaxLayoutWidth = CGRectGetWidth(newValue) - 16
			layoutIfNeeded()
		}
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	
}
