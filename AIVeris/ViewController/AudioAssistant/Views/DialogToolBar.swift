//
//  DialogToolBar.swift
//  AIVeris
//
//  Created by admin on 5/17/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

@objc protocol DialogToolBarDelegate: NSObjectProtocol {
	optional func dialogToolBar(dialogToolBar: DialogToolBar, clickHangUpButton sender: UIButton?)
	optional func dialogToolBar(dialogToolBar: DialogToolBar, clickPickUpButton sender: UIButton?)
	optional func dialogToolBar(dialogToolBar: DialogToolBar, clickMuteButton sender: UIButton?)
	optional func dialogToolBar(dialogToolBar: DialogToolBar, clickSpeakerButton sender: UIButton?)
}

class DialogToolBar: UIView {
	
	weak var delegate: DialogToolBarDelegate?
	
	@IBOutlet var toolBarViews: [UIView]!
	
	@IBOutlet weak var speakerButton: UIButton!
	@IBOutlet weak var muteButton: UIButton!
	var mute: Bool = false {
		didSet {
			updateUI()
		}
	}
	var speakderOn: Bool = true {
		didSet {
			updateUI()
		}
	}
	
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
		// update visible view
		toolBarViews.forEach { (view) in
			view.hidden = true
		}
        var index = status.rawValue
        if status == .Error {
            index = 0
        }
		let currentView = toolBarViews[index]
		currentView.hidden = false
		
		// update button status
		muteButton.selected = mute
		speakerButton.selected = !speakderOn
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
