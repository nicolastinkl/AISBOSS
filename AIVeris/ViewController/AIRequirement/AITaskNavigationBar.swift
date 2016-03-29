//
//  AITaskNavigationBar.swift
//  AIVeris
//
//  Created by admin on 3/28/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

protocol AITaskNavigationBarDelegate: NSObjectProtocol {
	var navigationBar: AITaskNavigationBar { get }
    
	func navigationBar(navigationBar: AITaskNavigationBar, cancelButtonPressed sender: UIButton)
	func navigationBar(navigationBar: AITaskNavigationBar, saveButtonPressed sender: UIButton)
}

class AITaskNavigationBar: UIView {
	
	struct Constants {
		static let margin: CGFloat = 40 / 3
		static let saveButtonHeight: CGFloat = 78 / 3
		static let saveButtonWidth: CGFloat = 156 / 3
	}
	
	weak var delegate: AITaskNavigationBarDelegate?
	lazy var cancelButton: UIButton = { [unowned self] in
		let cancelButton = UIButton()
		cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		cancelButton.setTitle("cancel", forState: .Normal)
		cancelButton.addTarget(self, action: "cancelButtonPressed:", forControlEvents: .TouchUpInside)
		cancelButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(20)
		
		self.addSubview(cancelButton)
		cancelButton.snp_makeConstraints { (make) in
			make.leading.equalTo(self).offset(Constants.margin)
			make.centerY.equalTo(self)
		}
		return cancelButton
	}()
	
	lazy var saveButton: UIButton = { [unowned self] in
		let saveButton = UIButton()
		saveButton.setTitle("save", forState: .Normal)
		saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		saveButton.addTarget(self, action: "saveButtonPressed:", forControlEvents: .TouchUpInside)
		saveButton.backgroundColor = UIColor(red: 0.0784, green: 0.4353, blue: 0.8863, alpha: 1.0)
		saveButton.layer.cornerRadius = 4
		saveButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(20)
		
		self.addSubview(saveButton)
		saveButton.snp_makeConstraints { (make) in
			make.trailing.equalTo(self).offset(-Constants.margin)
			make.centerY.equalTo(self)
			make.width.equalTo(Constants.saveButtonWidth)
			make.height.equalTo(Constants.saveButtonHeight)
		}
		return saveButton
	}()
	
	lazy var titleLabel: UILabel = { [unowned self] in
		let result = UILabel()
		result.textColor = UIColor.whiteColor()
		result.font = AITools.myriadSemiCondensedWithSize(72 / 3)
		self.addSubview(result)
		result.snp_makeConstraints(closure: { (make) in
			make.center.equalTo(self)
		})
		return result
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		_ = saveButton
		_ = cancelButton
	}
	
	func cancelButtonPressed(sender: UIButton) {
		delegate?.navigationBar(self, cancelButtonPressed: sender)
	}
	
	func saveButtonPressed(sender: UIButton) {
		delegate?.navigationBar(self, saveButtonPressed: sender)
	}
}

extension AITaskNavigationBarDelegate where Self: UIViewController {
	func setupNavigationAndBackgroundImage() {
		edgesForExtendedLayout = .None
		let imageView = UIImageView(image: UIImage(named: "taskEditBg"))
		view.addSubview(imageView)
		imageView.snp_makeConstraints { (make) in
			make.edges.equalTo(view)
		}
		let bar = AITaskNavigationBar()
		bar.tag = 765
		bar.delegate = self
		view.addSubview(bar)
		bar.snp_makeConstraints { (make) in
			make.height.equalTo(74)
			make.top.leading.trailing.equalTo(view)
		}
	}
	
	var navigationBar: AITaskNavigationBar {
		return view.viewWithTag(765) as! AITaskNavigationBar
	}

    var saveButtonEnabled: Bool {
        set {
            navigationBar.saveButton.enabled = newValue
            navigationBar.saveButton.alpha = newValue ? 1 : 0.4
        }
        get {
            return navigationBar.saveButton.enabled
        }
    }
}