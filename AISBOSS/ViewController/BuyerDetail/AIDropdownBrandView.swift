//
//  AIDropdownTagView.swift
//  AIVeris
//
//  Created by admin on 1/12/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIDropdownBrandView: UIView {
	var isExtended: Bool = false {
		didSet {
			// TODO: animation
		}
	}
	var brands = [String]()
	var labels = [HalfRoundedCornerLabel]()
	var downButton: UIButton!
	var barView: UIView! // 上面条状的 bar 背景
	
	private struct Constants {
		static let barHeight: CGFloat = 20
		static let downButtonWidth: CGFloat = 20
		static let margin: CGFloat = 8
		
		struct Label {
			static let backgroundColor: UIColor = UIColor.clearColor()
			static let highlightedBackgroundColor: UIColor = UIColor(red: 0.2941, green: 0.2863, blue: 0.3765, alpha: 1.0)
			static let textColor: UIColor = UIColor(red: 0.7804, green: 0.7961, blue: 0.8863, alpha: 1.0)
			static let highlightedTextColor: UIColor = UIColor.whiteColor()
		}
	}
	
	init(brands: [String], selectedIndex: Int, width: CGFloat) {
		self.brands = brands
		super.init(frame: CGRectMake(0, 0, width, Constants.barHeight))
		setupBarView()
		setupDownButton()
		setupLabels()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupBarView() {
		barView = UIView(frame: .zero)
		barView.backgroundColor = UIColor(red: 0.1176, green: 0.1059, blue: 0.2196, alpha: 1.0)
		addSubview(barView)
		barView.snp_makeConstraints {(make) -> Void in
			make.top.leading.trailing.equalTo(self)
			make.height.equalTo(Constants.barHeight)
		}
	}
	
	func setupLabels() {
		for brand in brands {
			
			let label = HalfRoundedCornerLabel(text: brand, backgroundColor: Constants.Label.backgroundColor, highlightedBackgroundColor: Constants.Label.highlightedBackgroundColor, textColor: Constants.Label.textColor, highlightedTextColor: Constants.Label.highlightedTextColor)
			label.text = brand
			addSubview(label)
			labels.append(label)
            let tap = UITapGestureRecognizer(target: self, action: "tapped:")
            label.addGestureRecognizer(tap)
		}
		let stackView = OAStackView(arrangedSubviews: labels)
		stackView.distribution = .EqualSpacing
		stackView.axis = .Horizontal
		addSubview(stackView)
		
		stackView.snp_makeConstraints {(make) -> Void in
			make.leading.equalTo(barView).offset(Constants.margin)
			make.top.bottom.equalTo(barView)
			make.trailing.equalTo(downButton.snp_leading).offset(-Constants.margin)
		}
	}
    
    func tapped(g: UITapGestureRecognizer) {
        labels.forEach { (label) -> () in
            if label == g.view {
                label.highlighted = true
            } else {
                label.highlighted = false
            }
        }
    }
	
	func setupDownButton() {
		downButton = UIButton(type: .Custom)
		downButton.setImage(UIImage(named: "up_triangle"), forState: .Selected)
		downButton.setImage(UIImage(named: "down_triangle"), forState: .Normal)
		downButton.addTarget(self, action: "downButtonPressed:", forControlEvents: .TouchUpInside)
		barView.addSubview(downButton)
		downButton.snp_makeConstraints {(make) -> Void in
			make.top.trailing.bottom.equalTo(barView)
			make.width.equalTo(Constants.downButtonWidth)
		}
	}
	
	func downButtonPressed(sender: UIButton) {
		sender.selected = !sender.selected
		isExtended = !isExtended
	}
}

class HalfRoundedCornerLabel: UILabel {
	var highlightedBackgroundColor: UIColor
	override var highlighted: Bool {
		didSet {
			self.backgroundColor = self.highlighted ? self.highlightedBackgroundColor : self.backgroundColor
		}
	}
	
	override func intrinsicContentSize() -> CGSize {
		return CGSizeMake(super.intrinsicContentSize().width + 16, super.intrinsicContentSize().height)
	}
	
	init(text: String, backgroundColor: UIColor, highlightedBackgroundColor: UIColor, textColor: UIColor, highlightedTextColor: UIColor) {
		self.highlightedBackgroundColor = highlightedBackgroundColor
		super.init(frame: CGRect.zero)
		self.text = text
		self.textColor = textColor
		self.highlightedTextColor = highlightedTextColor
		self.textAlignment = .Center
		self.backgroundColor = backgroundColor
//		self.setupCorners()
	}
	
	func setupCorners() {
		let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.TopLeft, .TopRight], cornerRadii: CGSizeMake(5, 5))
		let maskLayer = CAShapeLayer()
		maskLayer.frame = bounds
		maskLayer.path = maskPath.CGPath
		layer.mask = maskLayer
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}