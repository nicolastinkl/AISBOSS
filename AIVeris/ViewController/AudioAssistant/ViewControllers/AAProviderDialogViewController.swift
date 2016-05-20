//
//  AAProviderDialogViewControllerViewController.swift
//  AIVeris
//
//  Created by admin on 5/17/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AAProviderDialogViewController: UIViewController {
	
	var roomNumber: String!
	@IBOutlet weak var dialogToolBar: DialogToolBar!
	@IBOutlet weak var zoomButton: UIButton!
    var proposalID : Int = 1000
    var proposalName : String = "Proposal"
    
	var status: DialogToolBar.Status = DialogToolBar.Status.Received {
		didSet {
			dialogToolBar?.status = status
			zoomButton.hidden = status == .Connected
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		dialogToolBar.status = .Received
		dialogToolBar?.delegate = self
	}

	
	@IBAction func zoomButtonPressed(sender: AnyObject) {
	}
	
}

extension AAProviderDialogViewController: DialogToolBarDelegate {
	func dialogToolBar(dialogToolBar: DialogToolBar, clickHangUpButton sender: UIButton) {
		AudioAssistantManager.sharedInstance.providerHangUpRoom()
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func dialogToolBar(dialogToolBar: DialogToolBar, clickPickUpButton sender: UIButton) {
		AudioAssistantManager.sharedInstance.providerAnswerRoom(roomNumber: roomNumber, sessionDidConnectHandler: { [weak self] in
			self?.status = .Connected
		})
	}
}