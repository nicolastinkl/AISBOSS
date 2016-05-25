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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let connectionStatus = AudioAssistantManager.sharedInstance.connectionStatus
		if connectionStatus != .Connected && connectionStatus != .Dialing {
			status = .Dialing
			dia() }
	}
	
	override func updateUI() {
		let connectionStatus = AudioAssistantManager.sharedInstance.connectionStatus
		status = connectionStatus
		// 接通状态才显示zoomButton
		zoomButton.hidden = connectionStatus != .Connected
		switch connectionStatus {
		case .NotConnected:
			dialogToolBar.status = .NotConnected
		case .Dialing:
			dialogToolBar.status = .Dialing
		case .Connected:
			dialogToolBar.status = .Connected
		case .Error:
			dialogToolBar.status = .NotConnected
		}
	}
	
	func dia() {
		var roomNumber = random() % 9999
		roomNumber = AudioAssistantManager.fakeRoomNumber // test
		
		let notification = [AIRemoteNotificationParameters.AudioAssistantRoomNumber: roomNumber, AIRemoteNotificationKeys.NotificationType: AIRemoteNotificationParameters.AudioAssistantType, AIRemoteNotificationKeys.MessageKey: "您有远程协助请求", AIRemoteNotificationKeys.ProposalID: proposalID, AIRemoteNotificationKeys.ProposalName: proposalName]
		
		view.showLoading()
		AudioAssistantManager.sharedInstance.customerCallRoom(roomNumber: "\(roomNumber)", sessionDidConnectHandler: { [weak self] in
			AIRemoteNotificationHandler.defaultHandler().sendAudioAssistantNotification(notification as! [String: AnyObject], toUser: "200000002501")
			AudioAssistantManager.sharedInstance.doPublishAudio()
			self?.view.hideLoading()
			}, didFailHandler: { [weak self] error in
			self?.view.hideLoading()
		})
	}
	
	func dialogToolBar(dialogToolBar: DialogToolBar, clickHangUpButton sender: UIButton) {
		AudioAssistantManager.sharedInstance.customerHangUpRoom()
		dismissViewControllerAnimated(true, completion: nil)
	}
}
