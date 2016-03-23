//
//  AITaskRemarkInputViewController.swift
//  DimPresentViewController
//
//  Created by admin on 3/15/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

import UIKit

protocol AITaskRemarkInputViewControllerDelegate: NSObjectProtocol {
	func remarkInputViewControllerDidEndEditing(sender: AITaskRemarkInputViewController, text: String?)
}

class AITaskRemarkInputViewController: UIViewController {
	@IBOutlet weak var textField: KMPlaceholderTextView!
	
	weak var delegate: AITaskRemarkInputViewControllerDelegate?
	
	var text: String? {
		didSet {
			textField?.text = text
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		textField?.text = text
	}
	
	override func viewDidAppear(animated: Bool) {
		textField?.becomeFirstResponder()
		super.viewDidAppear(animated)
	}
}

extension AITaskRemarkInputViewController: UITextViewDelegate {
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		if (text == "\n") {
			textView.resignFirstResponder()
			dismissPopupViewController(true) { () -> Void in
				if let delegate = self.delegate {
					delegate.remarkInputViewControllerDidEndEditing(self, text: textView.text)
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
			viewHeightConstraint.constant = textView.contentSize.height + 17 // magic number
			view.setNeedsUpdateConstraints()
			view.updateConstraintsIfNeeded()
			view.setNeedsLayout()
			self.view.superview?.layoutIfNeeded()
		}
	}
}