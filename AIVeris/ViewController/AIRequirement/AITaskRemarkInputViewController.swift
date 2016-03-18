//
//  AITaskRemarkInputViewController.swift
//  DimPresentViewController
//
//  Created by admin on 3/15/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

import UIKit

class AITaskRemarkInputViewController: UIViewController {
    
	var text: String? {
		didSet {
			textField.text = text
		}
	}
	var onReturnButtonClick: ((inputText: String?) -> ())? = nil
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
			if let onReturnButtonClick = self.onReturnButtonClick {
				onReturnButtonClick(inputText: textField.text)
			}
		}
		return true
	}
}