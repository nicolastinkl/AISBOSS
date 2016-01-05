//
// VerticalIconLabel.swift
// AIVeris
//
// Created by admin on 1/5/16.
// Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

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
    
    
    lazy var imageView: UIImageView = {
        let result = UIImageView()
        self.addSubview(result)
        result.snp_makeConstraints(closure: { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(20)
//            make.width.equalTo(50)
//            make.height.equalTo(50)
        })
        return result
    }()
    
    lazy var label: UILabel = {
        let result = UILabel()
        result.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(42));
        result.textColor = UIColor.whiteColor()
        result.textAlignment = .Center
        self.addSubview(result)
        result.snp_makeConstraints(closure: { (make) -> Void in
            //TODO:
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-20)
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
            self.label.preferredMaxLayoutWidth = CGRectGetWidth(newValue)-16
            layoutIfNeeded()
        }
    }

	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	
}
