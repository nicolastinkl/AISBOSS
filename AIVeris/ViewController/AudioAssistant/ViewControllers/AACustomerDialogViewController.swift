//
//  AADialogViewController.swift
//  AIVeris
//
//  Created by admin on 5/17/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AACustomerDialogViewController: UIViewController {
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
		dialogToolBar?.delegate = self
		dia()
	}
	
	func dia() {
		var roomNumber = random() % 9999
		roomNumber = 9786521 // test
        
        let notification = [AIRemoteNotificationParameters.AudioAssistantRoomNumber: roomNumber, AIRemoteNotificationKeys.NotificationType : AIRemoteNotificationParameters.AudioAssistantType, AIRemoteNotificationKeys.MessageKey : "您有一个新的订单！", AIRemoteNotificationKeys.ProposalID : proposalID, AIRemoteNotificationKeys.ProposalName : proposalName]
        
        
		AudioAssistantManager.sharedInstance.customerCallRoom(roomNumber: "\(roomNumber)") {
			AIRemoteNotificationHandler.defaultHandler().sendAudioAssistantNotification(notification as! [String : AnyObject], toUser: "200000002501")
		}
	}
}

extension AACustomerDialogViewController: DialogToolBarDelegate {
	func dialogToolBar(dialogToolBar: DialogToolBar, clickHangUpButton sender: UIButton) {
		AudioAssistantManager.sharedInstance.customerHangUpRoom()
		dismissViewControllerAnimated(true, completion: nil)
	}
}
