//
//  AIDropdownTagView.swift
//  AIVeris
//
//  Created by admin on 1/12/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

/// 入参 [(title: String, imageURL: String)], selectedIndex: Int
/// 出参 selectedIndex
/// onDownButtonDidClick 处理下拉按钮点击
/// onSelectedIndexDidChanged 处理brand选择

class AIDropdownBrandView: UIView {
	var isExpanded: Bool = false {
		didSet {
			updateExpandedViewStatus()
		}
	}
	var displayModel : AIServiceProviderViewModel?
	var onDownButtonDidClick: ((AIDropdownBrandView) -> ())? = nil
	var onSelectedIndexDidChanged: ((AIDropdownBrandView, Int) -> ())? = nil
	
	var expandedView: UIView!
	var brands = [(title: String, image: String, id: Int)]()
	var labels = [HalfRoundedCornerLabel]()
	var iconLabels = [BrandIconLabel]()
	var downButton: UIButton!
	var barView: UIView! // 上面条状的 bar 背景
	var barScrollView: UIScrollView!
	var numberOfBrandsLabel: UILabel!
	var lineView: UIView! // 细线
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
			static let margin = AITools.displaySizeFrom1080DesignSize(40)
			static let imageWidth = AITools.displaySizeFrom1080DesignSize(110)
			static let hspace = AITools.displaySizeFrom1080DesignSize(110)
			static let vspace = AITools.displaySizeFrom1080DesignSize(18)
		}
		
		struct Label {
			static let backgroundColor: UIColor = UIColor.clearColor()
			static let highlightedBackgroundColor: UIColor = UIColor(red: 0.2941, green: 0.2863, blue: 0.3765, alpha: 1.0)
			static let textColor: UIColor = UIColor.whiteColor()
			static let highlightedTextColor: UIColor = UIColor.whiteColor()
		}
	}
	
	override func layoutSubviews() {
		var size = barScrollView.contentSize
		size.height = barScrollView.height
		barScrollView.contentSize = size
		super.layoutSubviews()
	}
	
	init(brands: [(title: String, image: String, id: Int)], selectedIndex: Int, frame: CGRect) {
		self.brands = brands
		self.selectedIndex = selectedIndex
		super.init(frame: CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, Constants.barHeight))
		setupBarView()
		setupDownButton()
		setupExpandedView()
		setupLabels()
		setupLineView()
		updateLabelSelectStatus()
		updateExpandedViewStatus()
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
		for (i, brand) in brands.enumerate() {
			let labelWidth = (width - Constants.IconLabel.margin * 2 - Constants.IconLabel.hspace * 3) / 4
			let labelHeight = labelWidth + 4 // just magic number
			let label = BrandIconLabel(frame: .zero)
			label.tag = i
			label.imageWidth = Constants.IconLabel.imageWidth
			expandedView.addSubview(label)
			if let image = UIImage(named: brand.image) {
				label.image = image
			} else {
				label.imageURL = brand.image
			}
			label.text = brand.title
			
			iconLabels.append(label)
			let row = CGFloat(i / 4)
			let column = CGFloat(i % 4)
			label.frame = CGRectMake(Constants.IconLabel.margin + column * (labelWidth + Constants.IconLabel.hspace), Constants.IconLabel.vspace + row * (labelHeight + Constants.IconLabel.vspace), labelWidth, labelHeight)
			
			let tap = UITapGestureRecognizer(target: self, action: "tapped:")
			label.addGestureRecognizer(tap)
		}
		
		if let last = iconLabels.last {
			expandedView.frame = CGRectMake(0, Constants.barHeight, width, CGRectGetMaxY(last.frame))
		} else {
            expandedView.frame = CGRectMake(0, Constants.barHeight, width, 0)
		}
	}

	func setupBarView() {

		barView = UIView(frame: .zero)
		barView.backgroundColor = Constants.barViewBackgroundColor
		addSubview(barView)
		barView.snp_makeConstraints { (make) -> Void in
			make.top.leading.trailing.equalTo(self)
			make.height.equalTo(Constants.barHeight)
		}
	}
	
	func setupLabels() {
		numberOfBrandsLabel = {
			let result = UILabel(frame: .zero)
			
			result.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(41))
			result.text = "\(brands.count) brands in total"
			result.textColor = UIColor.whiteColor()
			barView.addSubview(result)
			result.sizeToFit()
			var f = result.frame
			f.origin.y = Constants.barHeight / 2 - result.height / 2
			f.origin.x = Constants.margin
			result.frame = f
			return result
		}()
		
		barScrollView = UIScrollView(frame: .zero)
		barScrollView.alwaysBounceVertical = false
		barScrollView.showsHorizontalScrollIndicator = false
		barScrollView.showsVerticalScrollIndicator = false
		
		barView.addSubview(barScrollView)
		for (i, brand) in brands.enumerate() {
			let label = HalfRoundedCornerLabel(text: brand.title, backgroundColor: Constants.Label.backgroundColor, highlightedBackgroundColor: Constants.Label.highlightedBackgroundColor, textColor: Constants.Label.textColor, highlightedTextColor: Constants.Label.highlightedTextColor)
			label.text = brand.title
//			#if !DEBUG
//			label.text = "\(brand.id)"
//			#endif
			label.tag = i
			label.userInteractionEnabled = true
			barScrollView.addSubview(label)
			labels.append(label)
			let tap = UITapGestureRecognizer(target: self, action: "tapped:")
			label.addGestureRecognizer(tap)
		}
		
		barScrollView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(barView)
			make.leading.equalTo(barView).offset(Constants.margin)
			make.bottom.equalTo(barView).offset(-Constants.lineViewHeight)
			if downButton != nil {
				make.trailing.equalTo(downButton.snp_leading).offset(-Constants.margin)
			} else {
				make.trailing.equalTo(self)
			}
		}
		
		var previousView: UIView = barScrollView
		for (i, label) in labels.enumerate() {
			label.snp_makeConstraints(closure: { (make) -> Void in
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
		line.snp_makeConstraints { (make) -> Void in
			make.leading.equalTo(barView).offset(Constants.margin / 2)
			make.trailing.bottom.equalTo(barView)
			make.height.equalTo(Constants.lineViewHeight)
		}
	}
	
	func updateLabelSelectStatus() {
		for (i, label) in labels.enumerate() {
			label.highlighted = (i == selectedIndex)
		}
		
		for (i, label) in iconLabels.enumerate() {
			label.highlighted = (i == selectedIndex)
		}
	}
	
	func updateExpandedViewStatus() {
		var f = frame
		barScrollView.alpha = isExpanded ? 0 : 1.0
		expandedView.alpha = isExpanded ? 1.0 : 0
		numberOfBrandsLabel.alpha = isExpanded ? 1.0 : 0
		
		if isExpanded {
			f.size.height = Constants.barHeight + expandedView.height
		} else {
			f.size.height = Constants.barHeight
		}
		frame = f
	}
	
	func tapped(g: UITapGestureRecognizer) {
		selectedIndex = g.view!.tag
		updateLabelSelectStatus()
		if let c = onSelectedIndexDidChanged {
			c(self, selectedIndex)
		}
	}
	
	func setupDownButton() {
		if brands.count < 5 {
			return
		}
		downButton = UIButton(type: .Custom)
		downButton.setImage(UIImage(named: "up_triangle"), forState: .Selected)
		downButton.setImage(UIImage(named: "down_triangle"), forState: .Normal)
		downButton.addTarget(self, action: "downButtonPressed:", forControlEvents: .TouchUpInside)
		barView.addSubview(downButton)
		downButton.snp_makeConstraints { (make) -> Void in
			make.top.trailing.bottom.equalTo(barView)
			make.width.equalTo(Constants.downButtonWidth)
		}
	}
	
	func downButtonPressed(sender: UIButton) {
		sender.selected = !sender.selected
		if let block = onDownButtonDidClick {
			block(self)
		}
	}
}

class BrandIconLabel: VerticalIconLabel {
	var highlighted: Bool = false {
		didSet {
			updateHighlighted()
		}
	}
	
	var colorfulImage: UIImage?
	var grayImage: UIImage?
	var imageURL: String? {
		didSet {
			if let i = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(imageURL) {
				image = i
			} else {
				if let wrappedImageURL = imageURL {
					if let url = NSURL(string: wrappedImageURL) {
						SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: SDWebImageDownloaderOptions.HighPriority, progress: { (_, _) -> Void in
							}, completed: { [weak self](i, data, error, completed) -> Void in
							self?.image = i
						})
					}
				}
			}
		}
	}
	
	override var image: UIImage? {
		set {
			if let i = newValue {
				grayImage = BrandIconLabel.convertImageToGray(i)
			}
			colorfulImage = newValue
			updateImage()
		}
		get {
			// return highlighted image
			return colorfulImage
		}
	}
	
	func updateHighlighted() {
		updateImage()
		updateBorder()
		updateAlpha()
	}
	
	func updateAlpha() {
		let a: CGFloat = highlighted ? 1 : 0.18
		alpha = a
	}
	
	func updateBorder() {
		let borderWidth: CGFloat = highlighted ? 1 : 0
		layer.borderColor = UIColor(red: 0.2275, green: 0.2157, blue: 0.349, alpha: 1.0).CGColor
		layer.borderWidth = borderWidth
		layer.cornerRadius = AITools.displaySizeFrom1080DesignSize(11)
	}
	
	func updateImage() {
		if highlighted {
			self.imageView.image = colorfulImage
		} else {
			self.imageView.image = grayImage
		}
	}
	
	private static func convertImageToGray(image: UIImage) -> UIImage {
		// Create image rectangle with current image width/height
		let beginImage = CIImage(CGImage: image.CGImage!);
		
		let blackAndWhite = CIFilter(name: "CIColorControls", withInputParameters: [kCIInputImageKey: beginImage, "inputBrightness": 0.0, "inputContrast": 1.1, "inputSaturation": 0.0])?.outputImage
		let output = CIFilter(name: "CIExposureAdjust", withInputParameters: [kCIInputImageKey: blackAndWhite!, "inputEV": 0.7])?.outputImage
		
		let context = CIContext(options: nil)
		let cgiimage = context.createCGImage(output!, fromRect: (output?.extent)!)
		let newImage = UIImage(CGImage: cgiimage, scale: 0, orientation: image.imageOrientation)
		
		return newImage;
	}
}

class HalfRoundedCornerLabel: UILabel {
	var highlightedBackgroundColor: UIColor
	var normalBackgroundColor: UIColor
	override var highlighted: Bool {
		didSet {
			backgroundColor = highlighted ? highlightedBackgroundColor : normalBackgroundColor
			userInteractionEnabled = highlighted ? false : true
		}
	}
	
	struct Constants {
		static let cornerRadii = CGSize(width: AITools.displaySizeFrom1080DesignSize(10), height: AITools.displaySizeFrom1080DesignSize(10))
		static let margin = AITools.displaySizeFrom1080DesignSize(24)
		static let font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(41))
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