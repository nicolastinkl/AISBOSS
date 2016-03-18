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
            dateLabel.text = "\(date)"
        }
    }
    var desc: String? {
        didSet {
            descLabel.text = desc
        }
    }
   
    @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
	override var selected: Bool {
		didSet {
            
		}
	}
}
