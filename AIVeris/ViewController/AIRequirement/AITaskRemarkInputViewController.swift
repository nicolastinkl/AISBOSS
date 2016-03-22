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
	weak var delegate: AITaskRemarkInputViewControllerDelegate?
	var text: String? {
		didSet {
			textField.text = text
		}
	}
	@IBOutlet weak var textField: UITextField!
	override func viewDidLoad() {
		super.viewDidLoad()
		textField.text = text
	}
	
	override func viewDidAppear(animated: Bool) {
		textField.becomeFirstResponder()
		super.viewDidAppear(animated)
	}
}

extension AITaskRemarkInputViewController: UITextFieldDelegate {
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.endEditing(true)
		dismissPopupViewController(true) { () -> Void in
			if let delegate = self.delegate {
				delegate.remarkInputViewControllerDidEndEditing(self, text: textField.text)
			}
		}
		return true
	}
}