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
        descLabel.font = AITools.myriadSemiCondensedWithSize(16)
	}
	
	@IBOutlet weak var checkMarkImageView: UIImageView!
	@IBOutlet weak var descLabel: UILabel!
	@IBOutlet weak var dateLabel: CycleLabel!
	override var selected: Bool {
		didSet {
			checkMarkImageView.hidden = !selected
            backgroundColor = selected ? UIColorFromHex(0x79c2ff, alpha: 0.28) : UIColor.clearColor()
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
        font = AITools.myriadLightSemiCondensedWithSize(12)
		cycleColor = UIColorFromHex(0x2a9fff)
		layer.borderWidth = 1
		textAlignment = .Center
		textColor = UIColorFromHex(0x2a9fff)
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
