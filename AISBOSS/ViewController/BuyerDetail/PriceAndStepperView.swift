//
//  PriceAndStepperView.swift
//  AIVeris
//
//  Created by admin on 1/11/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit
import MMNumberKeyboard

class PriceAndStepperView: UIView {
	
	var stepper: KBHTextFieldStepper!
	let price: String
	let showStepper: Bool
	let defaultValue: Int
	let minValue: Int
	let maxValue: Int
	let onValueChanged: PKYStepperValueChangedCallback
	
	private struct CONSTANTS {
		static let margin: CGFloat = AITools.displaySizeFrom1080DesignSize(35)
		static let stepperWidth: CGFloat = 120.0
		static let selectedLabelHeight: CGFloat = 20
		static let selectedLabelY: CGFloat = 0
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/**
	 初始化方法

	 - parameter frame:        frame
	 - parameter price:        单价
	 - parameter showStepper:  是否显示stepper
	 - parameter defaultValue: 默认选择数量
	 - parameter minValue:     最小数量 可选默认0
	 - parameter maxValue:     最大数量 －1则是默认值100

	 - returns:
	 */
	init(frame: CGRect, price: String, showStepper: Bool, defaultValue: Int = 0, minValue: Int = 0, maxValue: Int, onValueChanged: PKYStepperValueChangedCallback) {
		self.price = price
		self.showStepper = showStepper
		self.defaultValue = defaultValue
		self.minValue = minValue
		self.maxValue = maxValue
		self.onValueChanged = onValueChanged
		super.init(frame: frame)
		setup()
		
		var frame = self.frame
		frame.size.height += CONSTANTS.selectedLabelHeight
		self.frame = frame
	}
	
	func setup() {
		// setup bg
		let bgImage = UIImage(named: "Wave_BG")
		let bgImageView = UIImageView(image: bgImage)
		addSubview(bgImageView)
		bgImageView.frame = CGRectMake(0, CONSTANTS.selectedLabelHeight, frame.size.width, frame.size.height)
		
		// setup price label
		let priceLabelFrame = CGRectMake(CONSTANTS.margin, CONSTANTS.selectedLabelHeight, CGRectGetWidth(frame) - CONSTANTS.stepperWidth - CONSTANTS.margin, CGRectGetHeight(frame))
		let priceLabel = AIViews.normalLabelWithFrame(priceLabelFrame, text: price, fontSize: AITools.displaySizeFrom1080DesignSize(63), color: AITools.colorWithR(0xf7, g: 0x9a, b: 0x00))
		priceLabel.font = AITools.myriadBoldWithSize(AITools.displaySizeFrom1080DesignSize(63))
		addSubview(priceLabel)
		
		if showStepper {
			let stepperFrame = CGRectMake(CGRectGetWidth(frame) - CONSTANTS.stepperWidth - CONSTANTS.margin, CONSTANTS.selectedLabelHeight, CONSTANTS.stepperWidth, CGRectGetHeight(frame))
			stepper = KBHTextFieldStepper(frame: stepperFrame)
			stepper.tintColor = UIColor(red: 0.4745, green: 0.4627, blue: 0.5333, alpha: 1.0)
			stepper.backgroundColor = UIColor.clearColor()
			let keyboard = MMNumberKeyboard(frame: .zero)
			keyboard.allowsDecimalPoint = true;
			keyboard.delegate = self;
			
			stepper.textField.inputView = keyboard
			stepper.addTarget(self, action: "stepperValueChanged:", forControlEvents: .ValueChanged)
            addSubview(stepper)
//			// setup stepper
//			let stepperFrame = CGRectMake(CGRectGetWidth(frame) - CONSTANTS.stepperWidth - CONSTANTS.margin, CONSTANTS.selectedLabelHeight, CONSTANTS.stepperWidth, CGRectGetHeight(frame))
//			stepper = PKYStepper(frame: stepperFrame)
//			stepper.setBorderColor(UIColor(red: 0.4745, green: 0.4627, blue: 0.5333, alpha: 1.0))
//			stepper.setBorderWidth(1)
//			stepper.setLabelTextColor(UIColor.whiteColor())
//			stepper.countLabel.layer.borderWidth = 0.5
//			stepper.buttonWidth = 34
//			stepper.setButtonTextColor(UIColor(red: 0.8235, green: 0.8196, blue: 0.8431, alpha: 1.0), forState: .Normal)
//			stepper.setButtonTextColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forState: .Highlighted)
//			stepper.setButtonFont(AITools.myriadSemiCondensedWithSize(29))
//			stepper.decrementButton .setTitle("-", forState: .Normal)
//			stepper.countLabel.text = "0"
//			stepper.setup()
//			if maxValue != -1 {
//				stepper.maximum = Float(maxValue)
//			}
//			stepper.minimum = Float(minValue)
//			stepper.countLabel.text = String(defaultValue)
//			stepper.valueChangedCallback = onValueChanged
//			addSubview(stepper)
//
			// setup selected title label
			let seletedTitleLabelFrame = CGRectMake(stepper.x, CONSTANTS.selectedLabelY, CONSTANTS.stepperWidth, CONSTANTS.selectedLabelHeight)
			let selectedTitle = UILabel(frame: seletedTitleLabelFrame)
			selectedTitle.textColor = UIColor.whiteColor()
			selectedTitle.font = AITools.myriadLightSemiExtendedWithSize(15)
			selectedTitle.text = "Selected Amount"
			selectedTitle.textAlignment = .Center
			addSubview(selectedTitle)
		}
	}
    
    func stepperValueChanged(sender:KBHTextFieldStepper) {
        
    }
}

extension PriceAndStepperView: MMNumberKeyboardDelegate {
}