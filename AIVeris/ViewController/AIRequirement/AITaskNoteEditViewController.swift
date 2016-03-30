//
//  AITaskNoteEditViewController.swift
//  AIVeris
//
//  Created by admin on 3/21/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AITaskNoteEditViewController: UIViewController {
	
	var textView: KMPlaceholderTextView!
    
    var iconImageView: UIImageView!
//    var
	
	struct Constants {
		static let textViewLeadingSpace: CGFloat = 35 / 3
		static let textViewTopSpace: CGFloat = 22 / 3
		static let textViewHeight: CGFloat = 490 / 3
		static let placeholderFont = AITools.myriadLightSemiCondensedWithSize(48 / 3)
		static let iconContainerLeadingSpace: CGFloat = 40 / 3
		static let iconContainerHeight: CGFloat = 200 / 3
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationAndBackgroundImage(backgroundColor: UIColorFromHex(0x558bdc, alpha: 0.22))
		navigationBar.titleLabel.text = "Note"
		setupTextView()
		setupIconView()
	}
	
	func setupTextView() {
		textView = KMPlaceholderTextView()
		textView.backgroundColor = UIColor.clearColor()
		textView.font = Constants.placeholderFont
		textView.textColor = UIColor.whiteColor()
		textView.placeholderFont = Constants.placeholderFont
		textView.placeholderColor = UIColorFromHex(0xffffff, alpha: 0.28)
		textView.placeholder = "9 weeks of pregnancy, action inconvenient"
		view.addSubview(textView)
		
		textView.snp_makeConstraints { (make) in
			make.leading.equalTo(view).offset(Constants.textViewLeadingSpace)
			make.top.equalTo(navigationBar.snp_bottom).offset(Constants.textViewTopSpace)
			make.trailing.equalTo(view).offset(-Constants.textViewLeadingSpace)
			make.height.equalTo(Constants.textViewHeight)
		}
	}
	
	func setupIconView() {
		
		let iconContainerView = UIImageView(image: UIImage(named: "ai_rac_bg_normal"))
		view.addSubview(iconContainerView)
		iconContainerView.snp_makeConstraints { (make) in
			make.top.equalTo(textView.snp_bottom)
			make.leading.equalTo(view).offset(Constants.iconContainerLeadingSpace)
			make.trailing.equalTo(view).offset(-Constants.iconContainerLeadingSpace)
			make.height.equalTo(Constants.iconContainerHeight)
		}
		
		let textLabel = UILabel()
		textLabel.text = "9 weeks of pregnancy, action inconvenient"
		textLabel.font = Constants.placeholderFont
		textLabel.textColor = textView.textColor
		iconContainerView.addSubview(textLabel)
		
		textLabel.snp_makeConstraints { (make) in
			make.leading.equalTo(40 / 3)
			make.top.equalTo(30 / 3)
			make.trailing.equalTo(iconContainerView).offset(-40 / 3)
		}
		
        let line = UIImageView(image: UIImage(named: "orderline"))
		iconContainerView.addSubview(line)
		line.snp_makeConstraints { (make) in
			make.height.equalTo(1)
			make.leading.trailing.equalTo(iconContainerView)
			make.top.equalTo(110 / 3)
		}
        
        
        iconImageView = UIImageView(image: UIImage(named: "icon-amazon"))
        iconImageView.layer.cornerRadius = 10
        iconImageView.backgroundColor = UIColor.redColor()
        iconContainerView.addSubview(iconImageView)
        
        iconImageView.snp_makeConstraints { (make) in
            make.bottom.equalTo(iconContainerView).offset(-5)
            make.leading.equalTo(textLabel)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
	}
}

// MARK: - AITaskNavigationBarDelegate
extension AITaskNoteEditViewController: AITaskNavigationBarDelegate {
	
	func navigationBar(navigationBar: AITaskNavigationBar, cancelButtonPressed sender: UIButton) {
		print("cancel button pressed")
		view.endEditing(true)
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func navigationBar(navigationBar: AITaskNavigationBar, saveButtonPressed sender: UIButton) {
		dismissViewControllerAnimated(true, completion: nil)
		print("save button pressed")
	}
}
