//
//  AITaskTimeLineView.swift
//  demo
//
//  Created by admin on 3/1/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

import UIKit

protocol AITaskTimeLineViewDelegate: NSObjectProtocol {
	func taskTimeLineViewDidClickDependOnNodeLogo(taskTimeLineView: AITaskTimeLineView)
	func taskTimeLineViewDidClickDatePickerLogo(taskTimeLineView: AITaskTimeLineView)
	func taskTimeLineViewDidClickRemarkLogo(taskTimeLineView: AITaskTimeLineView)
}

class AITaskTimeLineView: UIView {
	@IBOutlet weak var logo1: UIImageView!
	@IBOutlet weak var logo2: UIImageView!
	@IBOutlet weak var logo3: UIImageView!
	
	@IBOutlet weak var label1: UILabel!
	@IBOutlet weak var label2: UILabel!
	@IBOutlet weak var label3: UILabel!
	
	var subLabel1: UILabel! {
		return subLabels[0]
	}
	
	var subLabel2: UILabel! {
		return subLabels[1]
	}
	
	var subLabel3: UILabel! {
		return subLabels[2]
	}
	
	@IBOutlet weak var topCenterXConstraint: NSLayoutConstraint!
	@IBOutlet weak var middleCenterXConstraint: NSLayoutConstraint!
	@IBOutlet weak var bottomCenterXConstraint: NSLayoutConstraint!
	
	@IBOutlet var subLabels: [UILabel]!
	
	weak var delegate: AITaskTimeLineViewDelegate?
	
	var isTopLogoAtLeft: Bool {
		return label1.text != nil && label1.text?.characters.count > 0
	}
	
	var isMiddleLogoAtLeft: Bool {
		return label2.text != nil && label2.text?.characters.count > 0
	}
	
	var isBottomLogoAtLeft: Bool {
		return label3.text != nil && label3.text?.characters.count > 0
	}
	
	var line1: CAShapeLayer!
	var line2: CAShapeLayer!
	var line3: CAShapeLayer!
    
    var radiusOfLogo: CGFloat {
        return logo1.width / 2
    }
	
	var path1: CGPath {
		var point1 = CGPoint(x: CGRectGetMidX(subLabel1.frame), y: CGRectGetMaxY(subLabel1.frame))
		var point2 = CGPoint(x: CGRectGetMidX(logo2.frame), y: CGRectGetMinY(logo2.frame))
		if isTopLogoAtLeft && !isMiddleLogoAtLeft {
			point1 = logo1.center
			point1.x += radiusOfLogo / sqrt(2)
			point1.y += radiusOfLogo / sqrt(2)
			
			point2 = logo2.center
			point2.x -= radiusOfLogo / sqrt(2)
			point2.y -= radiusOfLogo / sqrt(2)
		}
		
		let path1 = UIBezierPath()
		path1.moveToPoint(point1)
		path1.addLineToPoint(point2)
		
		return path1.CGPath
	}
	
	var path2: CGPath {
		var point3 = CGPoint(x: CGRectGetMidX(subLabel2.frame), y: CGRectGetMaxY(subLabel2.frame))
		var point4 = CGPoint(x: CGRectGetMidX(logo3.frame), y: CGRectGetMinY(logo3.frame))
		if isMiddleLogoAtLeft && !isBottomLogoAtLeft {
			point3 = logo2.center
			point3.x += radiusOfLogo / sqrt(2)
			point3.y += radiusOfLogo / sqrt(2)
			
			point4 = logo3.center
			point4.x -= radiusOfLogo / sqrt(2)
			point4.y -= radiusOfLogo / sqrt(2)
		}
		let path2 = UIBezierPath()
		path2.moveToPoint(point3)
		path2.addLineToPoint(point4)
		
		return path2.CGPath
	}
	
	var path3: CGPath {
		let point5 = CGPoint(x: CGRectGetMidX(subLabel3.frame), y: CGRectGetMaxY(subLabel3.frame))
		let point6 = CGPoint(x: CGRectGetMidX(logo3.frame), y: CGRectGetHeight(bounds))
		
		let path3 = UIBezierPath()
		path3.moveToPoint(point5)
		path3.addLineToPoint(point6)
		
		return path3.CGPath
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupUI()
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		if line1.path == nil {
			// do once
			line1.path = path1
			line2.path = path2
			line3.path = path3
			
			let texts = ["Select task", "Set time", "Create task"]
			for (i, label) in subLabels.enumerate() {
				label.font = AITools.myriadSemiCondensedWithSize(16)
				label.alpha = 0.5
				label.text = texts[i]
				label.textColor = UIColor.whiteColor()
			}
		}
	}
	
	override func displayLayer(layer: CALayer) {
		super.displayLayer(layer)
		line1.path = path1
		line2.path = path2
		line3.path = path3
	}
	
	func setupUI() {
		line1 = CAShapeLayer()
		line1.lineWidth = 2
		line1.strokeColor = UIColor(red: 0.1412, green: 0.0706, blue: 0.4784, alpha: 1.0).CGColor
		layer.addSublayer(line1)
		
		line2 = CAShapeLayer()
		line2.lineWidth = 2
		line2.strokeColor = UIColor(red: 0.1412, green: 0.0706, blue: 0.4784, alpha: 1.0).CGColor
		layer.addSublayer(line2)
		
		line3 = CAShapeLayer()
		line3.lineWidth = 2
		line3.strokeColor = UIColor(red: 0.1412, green: 0.0706, blue: 0.4784, alpha: 1.0).CGColor
		layer.addSublayer(line3)
	}
	
	func animationLines() {
		let animation1 = makeAnimationToNewPath(path1)
		line1.addAnimation(animation1, forKey: "1")
		
		let animation2 = makeAnimationToNewPath(path2)
		
		line2.addAnimation(animation2, forKey: "2")
		
		let animation3 = makeAnimationToNewPath(path3)
		line3.addAnimation(animation3, forKey: "3")
	}
	
	override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		if let anim = anim as? CABasicAnimation {
			let path: CGPath = anim.toValue as! CGPath
			if line1.animationForKey("1") == anim {
				line1.path = path
			} else if line2.animationForKey("2") == anim {
				line2.path = path
			} else {
				line3.path = path
			}
		}
	}
	
	func makeAnimationToNewPath(newPath: CGPath) -> CABasicAnimation {
		let animation: CABasicAnimation = CABasicAnimation(keyPath: "path")
		animation.duration = 0.25
		animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		animation.fillMode = kCAFillModeForwards
		animation.delegate = self
		animation.removedOnCompletion = false
		animation.toValue = newPath
		return animation
	}
	
	override func updateConstraints() {
		let constant: CGFloat = -130
		topCenterXConstraint.constant = isTopLogoAtLeft ? constant : 0
		middleCenterXConstraint.constant = isMiddleLogoAtLeft ? constant : 0
		bottomCenterXConstraint.constant = isBottomLogoAtLeft ? constant : 0
		label1.alpha = isTopLogoAtLeft ? 1 : 0
		label2.alpha = isMiddleLogoAtLeft ? 1 : 0
		label3.alpha = isBottomLogoAtLeft ? 1 : 0
		super.updateConstraints()
	}
	
	@IBAction func topTapped(sender: AnyObject) {
		if let delegate = delegate {
			delegate.taskTimeLineViewDidClickDependOnNodeLogo(self)
		}
	}
	
	@IBAction func middleTapped(sender: AnyObject) {
		guard label1.text?.characters.count > 0 else {
			return
		}
		if let delegate = delegate {
			delegate.taskTimeLineViewDidClickDatePickerLogo(self)
		}
	}
	
	@IBAction func bottomTapped(sender: AnyObject) {
		guard label2.text?.characters.count > 0 else {
			return
		}
		if let delegate = delegate {
			delegate.taskTimeLineViewDidClickRemarkLogo(self)
		}
	}
}
