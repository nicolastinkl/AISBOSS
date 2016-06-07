//
//  AAProviderDialogViewControllerViewController.swift
//  AIVeris
//
//  Created by admin on 5/17/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

/// Provider 拨号界面
class AAProviderDialogViewController: AADialogBaseViewController {
	
	override func updateUI() {
		let connectionStatus = AudioAssistantManager.sharedInstance.connectionStatus
		status = connectionStatus
		zoomButton.hidden = status != .Connected
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
	override func handleCommand(notification: NSNotification) {
		if let command = notification.object as? AudioAssistantMessage {
			if command.type == .Command {
				switch command.content {
				case AudioAssistantString.HangUp:
					dialogToolBar(dialogToolBar, clickHangUpButton: nil)
				default:
					break
				}
			}
		}
	}
	func dialogToolBar(dialogToolBar: DialogToolBar, clickHangUpButton sender: UIButton?) {
		let sharedInstance = AudioAssistantManager.sharedInstance
		sharedInstance.providerHangUpRoom(roomNumber: roomNumber)
		
		let presentingViewController = self.presentingViewController
		dismissViewControllerAnimated(false, completion: {
			presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
		})
	}
	
	func dialogToolBar(dialogToolBar: DialogToolBar, clickPickUpButton sender: UIButton?) {
		view.showLoading()
		let sharedInstance = AudioAssistantManager.sharedInstance
		sharedInstance.providerAnswerRoom(roomNumber: roomNumber, sessionDidConnectHandler: { [weak self] in
			sharedInstance.connectionStatus = .Connected
			sharedInstance.doPublishAudio()
			sharedInstance.sendNormalMessage(AudioAssistantString.PickedUp)
			self?.view.hideLoading()
			}, didFailHandler: { [weak self] error in
			self?.view.hideLoading()
		})
	}
}