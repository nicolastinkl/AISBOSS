//
//  AITimePickerViewController.swift
//  DimPresentViewController
//
//  Created by admin on 3/10/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

import UIKit

class AITimePickerViewController: UIViewController {
	@IBOutlet weak var determineButton: UIButton!
	@IBOutlet weak var datePicker: AITimePickerView!
	var onDetermineButtonClick: ((date: NSDate, dateDescription: String) -> ())?
	var date: NSDate?
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor(red: 0.0392, green: 0.1137, blue: 0.3765, alpha: 1.0)
		if let date = date {
			datePicker?.date = date
			datePicker?.reload()
		}
		determineButton.layer.cornerRadius = 15
	}
	@IBAction func determineButtonPressed(sender: AnyObject) {
		dismissPopupViewController(true) { () -> Void in
			if let onDetermineButtonClick = self.onDetermineButtonClick, date = self.datePicker.date, dateDescription = self.datePicker.dateDescription {
                onDetermineButtonClick(date: date, dateDescription: dateDescription)
			}
		}
	}
}
