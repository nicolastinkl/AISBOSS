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
		let result = UILabel(frame: CGRectInset((self?.bounds)!, -8, 0))
		self?.addSubview(result)
        result.textColor = UIColor.whiteColor()
		result.numberOfLines = 0
		return result
	}()
	var text: String? {
		set {
			label.text = newValue
			if let string = newValue {
                let size = CGSizeMake(CGRectGetWidth(label.bounds), .max)
                let contentRect = string.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:label.font], context: nil)
                label.frame = contentRect
                self.setHeight(frame.height)
                self.frame = CGRectInset(contentRect, 8, 0)
			}
		}
		get {
			return label.text
		}
	}

}
