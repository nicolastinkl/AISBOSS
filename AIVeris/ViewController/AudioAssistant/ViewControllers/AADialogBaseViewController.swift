//
//  AADialogBaseViewController.swift
//  AIVeris
//
//  Created by admin on 5/24/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AADialogBaseViewController: UIViewController {
	
	var roomNumber: String!
	@IBOutlet weak var dialogToolBar: DialogToolBar!
	@IBOutlet weak var zoomButton: UIButton!
	var proposalID: Int = 1000
	var proposalName: String = "Proposal"
	
	var status: AudioAssistantManagerConnectionStatus = .NotConnected {
		didSet {
			if status != oldValue {
				updateUI()
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		dialogToolBar?.delegate = self
		setupNotification()
	}
	
	func setupNotification() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AADialogBaseViewController.updateConnectionStatus(_:)), name: AIApplication.Notification.AIRemoteAssistantConnectionStatusChangeNotificationName, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AADialogBaseViewController.handleCommand(_:)), name: AIApplication.Notification.AIRemoteAssistantManagerMessageReceivedNotificaitonName, object: nil)
	}
	
	func handleCommand(notification: NSNotification) {
		assertionFailure("subclass need override this function")
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		updateUI()
	}
	
	func updateConnectionStatus(notification: NSNotification) {
		updateUI()
	}
	
	/**
	 每次 connectionstatus 变化 和 viewWillAppear 会调用
	 */
	func updateUI() {
		assertionFailure("subclass need override this function")
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	@IBAction func zoomButtonPressed(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}
}

// MARK: - DialogToolBarDelegate 静音 免提
extension AADialogBaseViewController: DialogToolBarDelegate {
	func dialogToolBar(dialogToolBar: DialogToolBar, clickMuteButton sender: UIButton?) {
		let manager = AudioAssistantManager.sharedInstance
		manager.mute = !manager.mute
		dialogToolBar.mute = manager.mute
	}
	
	func dialogToolBar(dialogToolBar: DialogToolBar, clickSpeakerButton sender: UIButton?) {
		let sharedInstance = AVAudioSession.sharedInstance()
		if AVAudioSessionDefaultCategory == "" {
			AVAudioSessionDefaultCategory = sharedInstance.category
			do {
				try sharedInstance.setCategory(AVAudioSessionCategoryPlayback, withOptions: .DefaultToSpeaker)
				dialogToolBar.speakderOn = false
			} catch {
				
			}
		} else {
			do {
				try sharedInstance.setCategory(AVAudioSessionDefaultCategory, withOptions: .DefaultToSpeaker)
				dialogToolBar.speakderOn = true
			} catch {
				
			}
			AVAudioSessionDefaultCategory = ""
		}
	}
}
var AVAudioSessionDefaultCategory: String = ""