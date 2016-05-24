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
    
    override func updateConnectionStatus(notification: NSNotification) {
        
    }

	func dialogToolBar(dialogToolBar: DialogToolBar, clickHangUpButton sender: UIButton) {
		AudioAssistantManager.sharedInstance.providerHangUpRoom()
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func dialogToolBar(dialogToolBar: DialogToolBar, clickPickUpButton sender: UIButton) {
		view.showLoading()
		AudioAssistantManager.sharedInstance.providerAnswerRoom(roomNumber: roomNumber, sessionDidConnectHandler: { [weak self] in
			self?.status = .Connected
			AudioAssistantManager.sharedInstance.doPublishAudio()
			self?.view.hideLoading()
			}, didFailHandler: { [weak self] error in
			self?.view.hideLoading()
		})
	}
}