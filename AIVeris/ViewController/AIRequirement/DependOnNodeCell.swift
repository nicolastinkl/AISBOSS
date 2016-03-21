//
//  DependOnNodeCell.swift
//  DimPresentViewController
//
//  Created by admin on 3/17/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

import UIKit

class DependOnNodeCell: UITableViewCell {
	
	var date: NSDate? {
		didSet {
			let formatter = NSDateFormatter()
			formatter.dateFormat = "H:mm"
			if let date = date {
				dateLabel.text = formatter.stringFromDate(date)
			} else {
				dateLabel.text = nil
			}
		}
	}
	var desc: String? {
		didSet {
			descLabel.text = desc
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		selectionStyle = .None
		backgroundColor = UIColor.clearColor()
		contentView.backgroundColor = UIColor.clearColor()
		layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	}
	
	@IBOutlet weak var checkMarkImageView: UIImageView!
	@IBOutlet weak var descLabel: UILabel!
	@IBOutlet weak var dateLabel: CycleLabel!
	override var selected: Bool {
		didSet {
			checkMarkImageView.image = selected ? UIImage(named: "FakeLogin_Checked") : UIImage(named: "orange")
		}
	}
}

class CycleLabel: UILabel {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	func setup() {
		cycleColor = UIColor(red: 0.1216, green: 0.4157, blue: 0.7922, alpha: 1.0)
		layer.borderWidth = 1
		textAlignment = .Center
		textColor = UIColor(red: 0.1216, green: 0.4157, blue: 0.7922, alpha: 1.0)
		font = UIFont.systemFontOfSize(14)
	}
	
	var cycleColor: UIColor? {
		didSet {
			if let cycleColor = cycleColor {
				layer.borderColor = cycleColor.CGColor
			}
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = width / 2
	}
}
