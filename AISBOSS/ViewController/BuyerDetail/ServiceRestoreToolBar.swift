//
// ServiceRestoreToolBar.swift
// AIVeris
//
// Created by admin on 12/3/15.
// Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Cartography
import SnapKit

@objc protocol ServiceRestoreToolBarDelegate: NSObjectProtocol {
	optional func serviceRestoreToolBar(serviceRestoreToolBar: ServiceRestoreToolBar, didClickLogoAtIndex index: Int)
	optional func serviceRestoreToolBarDidClickBlankArea(serviceRestoreToolBar: ServiceRestoreToolBar)
}

class ServiceRestoreToolBar: UIView {
	
	var serviceModels: NSMutableArray?
	
	let LOGO_WIDTH: CGFloat = 19.0
	let LOGO_SPACE: CGFloat = 20.0
	
	var logos = [UIImageView]()
	var moreMenuIcon = UIImageView()
	
	weak var delegate: ServiceRestoreToolBarDelegate?
	
	var constraintGroups = [ConstraintGroup]()
	
	func bgTapped(sender: UITapGestureRecognizer) {
		if let d = delegate {
			d.serviceRestoreToolBarDidClickBlankArea!(self)
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setup() {
		let tap = UITapGestureRecognizer(target: self, action: "bgTapped:")
		addGestureRecognizer(tap)
		
		let tap2 = UITapGestureRecognizer(target: self, action: "bgTapped:")
		moreMenuIcon.image = UIImage(named: "restore_toolbar_more")
		moreMenuIcon.userInteractionEnabled = true
		moreMenuIcon.addGestureRecognizer(tap2)
		moreMenuIcon.hidden = true
		moreMenuIcon.layer.cornerRadius = LOGO_WIDTH / 2
		moreMenuIcon.clipsToBounds = true
		addSubview(moreMenuIcon)
	}
	
	func logoTapped(g: UITapGestureRecognizer) {
		var index = 0
		if let d = delegate {
			if g.view == moreMenuIcon {
				index = 100 // any number bigger than 5
			} else {
				index = logos.indexOf(g.view as! UIImageView)!
			}
			d.serviceRestoreToolBar!(self, didClickLogoAtIndex: index)
		}
	}
	
	override func updateConstraints() {
		for (i, logo) in logos.enumerate() {
			if i < 3 {
				logo.snp_remakeConstraints(closure: { (make) -> Void in
					make.leading.equalTo(self).offset(LOGO_SPACE + (LOGO_SPACE + LOGO_WIDTH) * CGFloat(i))
					// make.size.equalTo(CGSizeMake(LOGO_WIDTH, LOGO_WIDTH)) // not working
					// https://github.com/SnapKit/SnapKit/issues/169
					make.width.equalTo(LOGO_WIDTH)
					make.height.equalTo(LOGO_WIDTH)
					make.centerY.equalTo(self)
				})
			} else {
				logo.snp_remakeConstraints(closure: { (make) -> Void in
					let index = min(i, 5)
					make.trailing.equalTo(self).offset(-(LOGO_SPACE + (LOGO_SPACE + LOGO_WIDTH) * CGFloat(5 - index)))
					make.width.equalTo(LOGO_WIDTH)
					make.height.equalTo(LOGO_WIDTH)
					make.centerY.equalTo(self)
				})
			}
		}
		
		moreMenuIcon.snp_remakeConstraints { (make) -> Void in
			make.trailing.equalTo(self).offset(-LOGO_SPACE)
			make.width.equalTo(LOGO_WIDTH)
			make.height.equalTo(LOGO_WIDTH)
			make.centerY.equalTo(self)
		}
		let moreMenuIconVisible = logos.count > 5
		moreMenuIcon.hidden = !moreMenuIconVisible
		bringSubviewToFront(moreMenuIcon)
		
		super.updateConstraints()
	}
	
	func appendLogoAtLast() {
		if let model = serviceModels?.lastObject {
			if let imageURL = model.service_thumbnail_icon {
				let logo = UIImageView()
				logo.userInteractionEnabled = true
				logo.layer.cornerRadius = LOGO_WIDTH / 2
				logo.clipsToBounds = true
				logo.asyncLoadImage(imageURL)
				let tap = UITapGestureRecognizer(target: self, action: "logoTapped:")
				logo.addGestureRecognizer(tap)
				logos.append(logo)
				addSubview(logo)
			}
		}
		setNeedsUpdateConstraints()
		updateConstraintsIfNeeded()
		layoutIfNeeded()
	}
	
	func removeLogoAt(index: Int) {
		let logo = logos[index]
		logos.removeAtIndex(index)
		
		setNeedsUpdateConstraints()
		updateConstraintsIfNeeded()
		UIView.animateWithDuration(0.25, animations: { () -> Void in
			logo.alpha = 0
			self.layoutIfNeeded()
		}) { (completion) -> Void in
			logo.removeFromSuperview()
		}
	}
	
	func removeAllLogos() {
		logos.forEach { (logo) -> () in
			logo.removeFromSuperview()
		}
        logos.removeAll()
	}
}
