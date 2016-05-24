//
//  DialogToolBar.swift
//  AIVeris
//
//  Created by admin on 5/17/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

@objc protocol DialogToolBarDelegate: NSObjectProtocol {
	optional func dialogToolBar(dialogToolBar: DialogToolBar, clickHangUpButton sender: UIButton)
	optional func dialogToolBar(dialogToolBar: DialogToolBar, clickPickUpButton sender: UIButton)
	optional func dialogToolBar(dialogToolBar: DialogToolBar, clickMuteButton sender: UIButton)
	optional func dialogToolBar(dialogToolBar: DialogToolBar, clickSpeakerButton sender: UIButton)
}

class DialogToolBar: UIView {
	
	weak var delegate: DialogToolBarDelegate?
	
	@IBOutlet var toolBarViews: [UIView]!
	
	var status: AudioAssistantManagerConnectionStatus = .Dialing {
		didSet {
			updateUI()
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initSelfFromXib()
	}
	
	func updateUI() {
		toolBarViews.forEach { (view) in
			view.hidden = true
		}
		let currentView = toolBarViews[status.rawValue]
		currentView.hidden = false
	}
	
	@IBAction func hangUpButtonPressed(sender: UIButton) {
		delegate?.dialogToolBar?(self, clickHangUpButton: sender)
	}
	
	@IBAction func pickUpButtonPressed(sender: UIButton) {
		delegate?.dialogToolBar?(self, clickPickUpButton: sender)
	}
    
	@IBAction func speakerButtonPressed(sender: UIButton) {
		delegate?.dialogToolBar?(self, clickSpeakerButton: sender)
	}
	
	@IBAction func muteButtonPressed(sender: UIButton) {
		delegate?.dialogToolBar?(self, clickMuteButton: sender)
	}
}
