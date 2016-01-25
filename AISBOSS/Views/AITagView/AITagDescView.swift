//
//  AITagDescView.swift
//  multiLabelDemo
//
//  Created by admin on 1/22/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

import UIKit

class AITagDescView: UIView {
	lazy private var label: UILabel = { [weak self] in
		let result = UILabel(frame: CGRectInset((self?.bounds)!, 10, 0))
		self?.addSubview(result)
		result.numberOfLines = 0
		return result
	}()
	var text: String? {
		set {
			label.text = newValue
		}
		get {
			return label.text
		}
	}

}
