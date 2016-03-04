//
//  AIStepperParamView.swift
//  AIVeris
//
//  Created by admin on 2/3/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIStepperParamView: UIView {
	var value: CGFloat {
		get {
			return CGFloat(stepper.value)
		}
		set {
			stepper.value = Double(newValue)
		}
	}
	var stepper: KBHTextFieldStepper!
	var titleLabel: UPLabel?
	var tailLabel: UPLabel?
	
	var displayModel: AIStepperParamViewModel!
	
	init(frame : CGRect, model: AIStepperParamViewModel?) {
		super.init(frame: frame)
		displayModel = model
		
		if let _ = model {
			makeSubViews()
		}
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func makeSubViews() {
		
		let width = CGRectGetWidth(self.frame)
		let height: CGFloat = 40
		let margin: CGFloat = 10
		
//setup stepper
		let stepperHeight: CGFloat = 35
		let stepperWidth: CGFloat = width / 3
		let stepperX: CGFloat = width / 3
		let stepperY = height / 2 - stepperHeight / 2
		let stepperFrame = CGRectMake(stepperX, stepperY, stepperWidth, stepperHeight)
		stepper = KBHTextFieldStepper(frame: stepperFrame)
		stepper.tintColor = UIColor(red: 0.4745, green: 0.4627, blue: 0.5333, alpha: 1.0)
		stepper.backgroundColor = UIColor.clearColor()
		stepper.textField.textColor = UIColor.whiteColor()
		stepper.textField.text = "\(displayModel.defaultNumber)"
		addSubview(stepper)
		stepper.minimumValue = Double(displayModel.minNumber)
		if displayModel.maxNumber > 0 {
			stepper.maximumValue = Double(displayModel.maxNumber)
		}
		stepper.value = Double(displayModel.defaultNumber)
		
		if let title = displayModel?.title {
			let titleSize = title.sizeWithFont(AITools.myriadLightSemiCondensedWithSize(16), forWidth: width)
			titleLabel = AIViews.wrapLabelWithFrame(CGRectMake(0, 0, width, titleSize.height), text: title, fontSize: 16, color: UIColor.whiteColor()) ;
			titleLabel?.sizeToFit()
			titleLabel?.setCenterY(height / 2)
			self.addSubview(titleLabel!)
			
			stepper.setLeft((titleLabel?.right)! + margin)
		}
		
		if let tail = displayModel?.tail {
			let tailSize = tail.sizeWithFont(AITools.myriadLightSemiCondensedWithSize(16), forWidth: width)
			tailLabel = AIViews.wrapLabelWithFrame(CGRectMake(0, 0, width, tailSize.height), text: tail, fontSize: 16, color: UIColor.whiteColor())
			tailLabel?.sizeToFit()
			tailLabel?.setCenterY(height / 2)
			tailLabel?.setRight(width)
			self.addSubview(tailLabel!)
			tailLabel?.setLeft(stepper.right + margin)
		}
		
		var frame = self.frame
		frame.size.height = height
		self.frame = frame
	}
}
