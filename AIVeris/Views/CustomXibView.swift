//
//  CustomXibView.swift
//  AIVeris
//
//  Created by Rocky on 16/5/10.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

extension UIView {
	// load xib file to init view, and let this custom view can be used in another xib view
	func initSelfFromXib() {
		let storyboardName = NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!
		let view = UINib.init(nibName: storyboardName, bundle: NSBundle.mainBundle()).instantiateWithOwner(self, options: nil).first as! UIView
		addSubview(view)
		view.snp_makeConstraints { (make) in
			make.edges.equalTo(self)
		}
	}
}
