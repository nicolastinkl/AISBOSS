//
//  AADialogViewController.swift
//  AIVeris
//
//  Created by admin on 5/17/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

/// Customer 拨号界面
class AACustomerDialogViewController: AADialogBaseViewController {
    var shouldDial: Bool = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if shouldDial {
            dial()
        }
    }
	
	override func handleCommand(notification: NSNotification) {
		if let command = notification.object as? AudioAssistantMessage {
			if command.type == .Command {
				switch command.content {
				case AudioAssistantString.HangUp:
					dialogToolBar(dialogToolBar, clickHangUpButton: nil)
                    shouldDial = true
				default:
					break
				}
			}
		}
	}
	
	override func updateUI() {
		let connectionStatus = AudioAssistantManager.sharedInstance.connectionStatus
		status = connectionStatus
		zoomButton.hidden = status != .Connected
		switch connectionStatus {
		case .NotConnected:
			dialogToolBar.status = .NotConnected
		case .Dialing:
			dialogToolBar.status = .NotConnected
		case .Connected:
			dialogToolBar.status = .Connected
		case .Error:
			dialogToolBar.status = .NotConnected
		}
	}
	
	func dial() {
		var roomNumber = "\(random() % 9999)"
		roomNumber = "\(AudioAssistantManager.fakeRoomNumber)" // test
		
		let notification = [AIRemoteNotificationParameters.AudioAssistantRoomNumber: roomNumber, AIRemoteNotificationKeys.NotificationType: AIRemoteNotificationParameters.AudioAssistantType, AIRemoteNotificationKeys.MessageKey: "您有远程协助请求", AIRemoteNotificationKeys.ProposalID: proposalID, AIRemoteNotificationKeys.ProposalName: proposalName]
		
		view.showLoading()
		AudioAssistantManager.sharedInstance.customerCallRoom(roomNumber: "\(roomNumber)", sessionDidConnectHandler: { [weak self] in
			AIRemoteNotificationHandler.defaultHandler().sendAudioAssistantNotification(notification as! [String: AnyObject], toUser: "200000002501")
            AudioAssistantManager.sharedInstance.doPublishAudio()
            self?.shouldDial = false
			self?.view.hideLoading()
			}, didFailHandler: { [weak self] error in
                
			// show error
			self?.view.hideLoading()
		})
	}
	
	func dialogToolBar(dialogToolBar: DialogToolBar, clickHangUpButton sender: UIButton?) {
		AudioAssistantManager.sharedInstance.customerHangUpRoom()
        dismissViewControllerAnimated(true, completion: { [weak self] in
           self?.shouldDial = true
        })
	}
}
