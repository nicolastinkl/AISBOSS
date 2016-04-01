//
//  AITimePickerViewController.swift
//  DimPresentViewController
//
//  Created by admin on 3/10/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

import UIKit

class AITimePickerViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var determineButton: UIButton!
	@IBOutlet weak var datePicker: AITimePickerView!
	var onDetermineButtonClick: ((date: NSDate, dateDescription: String) -> ())?
	var taskDate: NSDate?
	var date: NSDate?
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor(red: 0.0392, green: 0.1137, blue: 0.3765, alpha: 1.0)
        timeLabel.font = AITools.myriadSemiCondensedWithSize(20)
		datePicker?.taskDate = taskDate!
		if let date = date {
			datePicker?.date = date
			datePicker?.reload()
		}
		determineButton.layer.cornerRadius = determineButton.height / 2
	}
	@IBAction func determineButtonPressed(sender: AnyObject) {
		dismissPopupViewController(true) { [weak self] () -> Void in
			if let onDetermineButtonClick = self?.onDetermineButtonClick, date = self?.datePicker.date, dateDescription = self?.datePicker.dateDescription {
				onDetermineButtonClick(date: date, dateDescription: dateDescription)
			}
		}
	}
}
