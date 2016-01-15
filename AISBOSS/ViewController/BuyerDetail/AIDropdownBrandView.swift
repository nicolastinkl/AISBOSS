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
	
	var expandedView: UIView!
	var brands = [(title: String, image: String)]()
	var labels = [HalfRoundedCornerLabel]()
    var iconLabels = [VerticalIconLabel]()
	var downButton: UIButton!
	var barView: UIView! // 上面条状的 bar 背景
	var lineView: UIView!
	var selectedIndex: Int {
		didSet {
			updateLabelSelectStatus()
		}
	}
	
	struct Constants {
		static let barHeight: CGFloat = AITools.displaySizeFrom1080DesignSize(88)
		static let downButtonWidth: CGFloat = 44
		static let margin: CGFloat = 8
		static let space: CGFloat = 20
		static let lineViewHeight: CGFloat = 0.5
		static let barViewBackgroundColor: UIColor = UIColor(red: 0.1176, green: 0.1059, blue: 0.2196, alpha: 1.0)
		
		struct IconLabel {
			
			static let size = CGSizeMake(AITools.displaySizeFrom1080DesignSize(176), AITools.displaySizeFrom1080DesignSize(176))
		}
		struct Label {
			static let backgroundColor: UIColor = UIColor.clearColor()
			static let highlightedBackgroundColor: UIColor = UIColor(red: 0.2941, green: 0.2863, blue: 0.3765, alpha: 1.0)
			static let textColor: UIColor = UIColor(red: 0.7804, green: 0.7961, blue: 0.8863, alpha: 1.0)
			static let highlightedTextColor: UIColor = UIColor.whiteColor()
		}
	}
	
	init(brands: [(title: String, image: String)], selectedIndex: Int, width: CGFloat) {
		self.brands = brands
		self.selectedIndex = selectedIndex
		super.init(frame: CGRectMake(0, 0, width, Constants.barHeight))
		setupBarView()
		setupDownButton()
		setupExpandedView()
		setupLabels()
		setupLineView()
		updateLabelSelectStatus()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupExpandedView() {
		expandedView = UIView(frame: .zero)
		addSubview(expandedView)
		setupIconLabels()
	}
	
	func setupIconLabels() {
		for brand in brands {
			let label = VerticalIconLabel(image: UIImage(named: brand.image)!, text: brand.title, frame: CGRectMake(0, 0, 300, 300))
            expandedView.addSubview(label)
            iconLabels.append(label)
		}
	}
	
	func setupBarView() {
		barView = UIView(frame: .zero)
		barView.backgroundColor = Constants.barViewBackgroundColor
		addSubview(barView)
		barView.snp_makeConstraints {(make) -> Void in
			make.top.leading.trailing.equalTo(self)
			make.height.equalTo(Constants.barHeight)
		}
	}
	
	func setupLabels() {
		let barScrollView = UIScrollView(frame: .zero)
		barView.addSubview(barScrollView)
		for (i, brand) in brands.enumerate() {
			let label = HalfRoundedCornerLabel(text: brand.title, backgroundColor: Constants.Label.backgroundColor, highlightedBackgroundColor: Constants.Label.highlightedBackgroundColor, textColor: Constants.Label.textColor, highlightedTextColor: Constants.Label.highlightedTextColor)
			label.text = brand.title
			label.tag = i
			label.userInteractionEnabled = true
			barScrollView.addSubview(label)
			labels.append(label)
			let tap = UITapGestureRecognizer(target: self, action: "tapped:")
			label.addGestureRecognizer(tap)
		}
		
		barScrollView.snp_makeConstraints {(make) -> Void in
			make.top.equalTo(barView)
			make.leading.equalTo(barView).offset(Constants.margin)
			make.bottom.equalTo(barView).offset(-Constants.lineViewHeight)
			make.trailing.equalTo(downButton.snp_leading).offset(-Constants.margin)
		}
		
		var previousView: UIView = barScrollView
		for (i, label) in labels.enumerate() {
			label.snp_makeConstraints(closure: {(make) -> Void in
					if i == 0 {
						// first label
						make.leading.equalTo(previousView)
					} else if i == labels.count - 1 {
						// last label
						make.leading.equalTo(previousView.snp_trailing).offset(Constants.space)
						make.trailing.equalTo(barScrollView)
					} else {
						// center labels
						make.leading.equalTo(previousView.snp_trailing).offset(Constants.space)
					}
					// every label
					make.bottom.equalTo(barScrollView)
					make.top.equalTo(barScrollView).offset(10)
				})
			previousView = label
		}
	}
	
	func setupLineView() {
		let line = UIView(frame: .zero)
		line.backgroundColor = Constants.Label.highlightedBackgroundColor
		barView.addSubview(line)
		line.snp_makeConstraints {(make) -> Void in
			make.leading.equalTo(barView).offset(Constants.margin / 2)
			make.trailing.bottom.equalTo(barView)
			make.height.equalTo(Constants.lineViewHeight)
		}
	}
	
	func updateLabelSelectStatus() {
		for (i, label) in labels.enumerate() {
			label.highlighted = (i == selectedIndex)
		}
	}
	
	func tapped(g: UITapGestureRecognizer) {
		selectedIndex = g.view!.tag
		updateLabelSelectStatus()
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
	var normalBackgroundColor: UIColor
	
	struct Constants {
		static let cornerRadii = CGSize(width: AITools.displaySizeFrom1080DesignSize(10), height: AITools.displaySizeFrom1080DesignSize(10))
		static let margin = AITools.displaySizeFrom1080DesignSize(24)
		static let font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(41))
	}
	
	override var highlighted: Bool {
		didSet {
			backgroundColor = highlighted ? highlightedBackgroundColor : normalBackgroundColor
		}
	}
	
	override var frame: CGRect {
		didSet {
			setupCorners()
		}
	}
	
	override func intrinsicContentSize() -> CGSize {
		return CGSizeMake(super.intrinsicContentSize().width + Constants.margin * 2, super.intrinsicContentSize().height + 10)
		// 10 is magic number hehe.
	}
	
	
	init(text: String, backgroundColor: UIColor, highlightedBackgroundColor: UIColor, textColor: UIColor, highlightedTextColor: UIColor) {
		self.highlightedBackgroundColor = highlightedBackgroundColor
		self.normalBackgroundColor = backgroundColor
		super.init(frame: CGRect.zero)
		self.text = text
		self.font = Constants.font
		self.textColor = textColor
		self.highlightedTextColor = highlightedTextColor
		self.textAlignment = .Center
		self.backgroundColor = backgroundColor
		self.frame = CGRectMake(0, 0, intrinsicContentSize().width, intrinsicContentSize().height)
		self.setupCorners()
	}
	
	func setupCorners() {
		let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.TopLeft, .TopRight], cornerRadii: Constants.cornerRadii)
		let maskLayer = CAShapeLayer()
		maskLayer.frame = self.bounds
		maskLayer.path = maskPath.CGPath
		self.layer.mask = maskLayer
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}