//
//  AITagDescView.swift
//  multiLabelDemo
//
//  Created by admin on 1/22/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

import UIKit
import SnapKit

class AITagDescView: UIView {
	lazy private var label: UILabel = { [weak self] in
		let result = UILabel(frame: CGRectInset((self?.bounds)!, -Constants.margin, 0))
		self?.addSubview(result)
		result.textColor = UIColor.whiteColor()
		result.numberOfLines = 0
		return result
	}()
	
	struct Constants {
		static let margin: CGFloat = 8
	}
	var text: String? {
		set {
			label.text = newValue
			if let string = newValue {
				let size = CGSizeMake(CGRectGetWidth(bounds) - 2 * Constants.margin, .max)
				let contentRect = string.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil)
				frame.origin.y = Constants.margin
				frame.origin.x = Constants.margin
				label.frame = contentRect
				self.setHeight(contentRect.height + 2 * Constants.margin)
			}
		}
		get {
			return label.text
		}
	}
}
