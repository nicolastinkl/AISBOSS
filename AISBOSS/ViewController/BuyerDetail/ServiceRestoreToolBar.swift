//
// ServiceRestoreToolBar.swift
// AIVeris
//
// Created by admin on 12/3/15.
// Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Cartography

@objc protocol ServiceRestoreToolBarDataSource : NSObjectProtocol {
	func serviceRestoreToolBar(serviceRestoreToolBar: ServiceRestoreToolBar, imageAtIndex index: Int) -> String?
}

@objc protocol ServiceRestoreToolBarDelegate: NSObjectProtocol {
	optional func serviceRestoreToolBar(serviceRestoreToolBar: ServiceRestoreToolBar, didClickLogoAtIndex index: Int)
	optional func serviceRestoreToolBarDidClickBlankArea(serviceRestoreToolBar: ServiceRestoreToolBar)
}

class ServiceRestoreToolBar: UIView {

    var isAnimating: Bool = false
	@IBOutlet var logos: [UIImageView]!
	weak var dataSource: ServiceRestoreToolBarDataSource?
	weak var delegate: ServiceRestoreToolBarDelegate?

	class func currentView() -> ServiceRestoreToolBar {
		let result = NSBundle.mainBundle().loadNibNamed("ServiceRestoreToolBar", owner: self, options: nil).first as! ServiceRestoreToolBar
		return result
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		// TODO: make logo click more easily
		for (i, logo) in logos.enumerate() {
			logo.layer.cornerRadius = logo.width / 2
			logo.clipsToBounds = true
			logo.userInteractionEnabled = true
			logo.tag = i;
			let tap = UITapGestureRecognizer(target: self, action: "logoTapped:")
			logo.addGestureRecognizer(tap)
		}
	}

	@IBAction func bgTapped(sender: UITapGestureRecognizer) {
		if let d = delegate {
			d.serviceRestoreToolBarDidClickBlankArea!(self)
		}
	}

	func logoTapped(g: UITapGestureRecognizer) {
		if let d = delegate {
			d.serviceRestoreToolBar!(self, didClickLogoAtIndex: g.view!.tag)
		}
	}

	func reloadLogos() {
		for (i, logo) in logos.enumerate() {
			if let image = dataSource?.serviceRestoreToolBar(self, imageAtIndex: i) {
				if i < 5 {
					logo.asyncLoadImage(image)
                } else {
                    logo.image = UIImage(named: "restore_toolbar_more");
                }
				logo.hidden = false
			}else {
				logo.image = nil
				logo.hidden = true
			}
		}
	}
    
    func removeLogoAt(index:Int) {
        
    }
}
