//
//  AITaskInputViewController.swift
//  DimPresentViewController
//
//  Created by admin on 3/15/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

import UIKit

@objc protocol AITaskInputViewControllerDelegate: NSObjectProtocol {
	func inputViewControllerDidEndEditing(sender: AITaskInputViewController, text: String?)
    optional func inputViewControllerShouldEndEditing(sender: AITaskInputViewController, text: String?) -> Bool
}

class AITaskInputViewController: UIViewController {
	@IBOutlet weak var textField: KMPlaceholderTextView!
	
	weak var delegate: AITaskInputViewControllerDelegate?
	
	var text: String? {
		didSet {
			textField?.text = text
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		textField?.text = text
		textField.backgroundColor = UIColorFromHex(0xddecff)
		textField.font = AITools.myriadSemiCondensedWithSize(16)
		textField.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
		textField.layer.cornerRadius = 6
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		textField?.becomeFirstResponder()
	}
}

extension AITaskInputViewController: UITextViewDelegate {
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		if (text == "\n") {
            if let textViewShouldEndEditing = delegate?.inputViewControllerShouldEndEditing?(self, text: textView.text) {
                if !textViewShouldEndEditing {
                    textView.shake(.Horizontal, numberOfTimes: 10, totalDuration: 0.6, completion: {
                        // do something after animation finishes
                    })
                    return false
                }
            }
			textView.resignFirstResponder()
			dismissPopupViewController(true) { () -> Void in
				if let delegate = self.delegate {
					delegate.inputViewControllerDidEndEditing(self, text: textView.text)
				}
			}
			return false
		}
		return true;
	}
	func textViewDidChange(textView: UITextView) {
		
		let viewHeightConstraint = view.constraints.filter { (c) -> Bool in
			return c.firstAttribute == .Height
		}.first
		
		if let viewHeightConstraint = viewHeightConstraint {
			viewHeightConstraint.constant = textView.contentSize.height + 47 // magic number
			view.setNeedsUpdateConstraints()
			view.updateConstraintsIfNeeded()
			view.setNeedsLayout()
			self.view.superview?.layoutIfNeeded()
		}
	}
}