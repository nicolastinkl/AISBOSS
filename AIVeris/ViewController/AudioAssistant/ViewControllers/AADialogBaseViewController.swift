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
			dialogToolBar?.status = status
			zoomButton.hidden = status == .Connected
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		dialogToolBar.status = .Dialing
		dialogToolBar?.delegate = self
		
		let tapLabel = UILabel(frame: CGRectMake(10, 10, 100, 40))
		tapLabel.text = "点击消失"
		tapLabel.textColor = UIColor.whiteColor()
		tapLabel.backgroundColor = UIColor.clearColor()
		tapLabel.userInteractionEnabled = true
		view.addSubview(tapLabel)
		
		let gestrue = UITapGestureRecognizer(target: self, action: #selector(disppear))
		tapLabel.addGestureRecognizer(gestrue)
		
		setupNotification()
	}
	
	func setupNotification() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AADialogBaseViewController.updateConnectionStatus(_:)), name: AIApplication.Notification.AIRemoteAssistantConnectionStatusChangeNotificationName, object: nil)
	}
	
	func updateConnectionStatus(notification: NSNotification) {
        assertionFailure("subclass need override this function")
//		let status = AudioAssistantManager.sharedInstance.connectionStatus
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	@IBAction func zoomButtonPressed(sender: AnyObject) {
	}
	
	func disppear() {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
}

// MARK: - DialogToolBarDelegate 静音 免提
extension AADialogBaseViewController: DialogToolBarDelegate {
	func dialogToolBar(dialogToolBar: DialogToolBar, clickMuteButton sender: UIButton) {
		let manager = AudioAssistantManager.sharedInstance
		manager.mute = !manager.mute
	}
	
	func dialogToolBar(dialogToolBar: DialogToolBar, clickSpeakerButton sender: UIButton) {
		let sharedInstance = AVAudioSession.sharedInstance()
		if AVAudioSessionDefaultCategory == "" {
			AVAudioSessionDefaultCategory = sharedInstance.category
			do {
				try sharedInstance.setCategory(AVAudioSessionCategoryPlayback, withOptions: .DefaultToSpeaker)
			} catch {
				
			}
		} else {
			do {
				try sharedInstance.setCategory(AVAudioSessionDefaultCategory, withOptions: .DefaultToSpeaker)
			} catch {
				
			}
			AVAudioSessionDefaultCategory = ""
		}
	}
}
var AVAudioSessionDefaultCategory: String = ""