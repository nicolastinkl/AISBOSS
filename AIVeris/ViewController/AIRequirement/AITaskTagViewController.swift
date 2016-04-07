//
//  AITaskTagViewController.swift
//  AIVeris
//
//  Created by admin on 3/21/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AIAlertView

class AITaskTagViewController: RRTagController {
	
	override func addTagDidClick() {
		print("addTagDidClick")
		let vc = AITaskInputViewController.initFromNib()
		vc.delegate = self
		presentPopupViewController(vc, animated: true)
	}
	
	override func viewDidLoad() {
        setupNavigationAndBackgroundImage(backgroundColor: UIColorFromHex(0x558bdc, alpha: 0.22))
		navigationBar.titleLabel.text = "Tag"
		super.viewDidLoad()
		setupCollectionView()
	}
	
	func setupCollectionView() {
		collectionTag.reloadData()
        collectionTag.snp_remakeConstraints { (make) in
            make.top.equalTo(navigationBar.snp_bottom)
            make.leading.bottom.trailing.equalTo(view)
        }
	}
}

extension AITaskTagViewController: AITaskInputViewControllerDelegate {
	func remarkInputViewControllerDidEndEditing(sender: AITaskInputViewController, text: String?) {
		let spaceSet = NSCharacterSet.whitespaceCharacterSet()
		if let contentTag = text?.stringByTrimmingCharactersInSet(spaceSet) {
			if strlen(contentTag) > 0 {
				let newTag = RequirementTag(id: random() % 10000, selected: false, textContent: contentTag)
				tags.insert(newTag, atIndex: tags.count)
				collectionTag.reloadData()
			}
		}
	}
    
    func remarkInputViewControllerShouldEndEditing(sender: AITaskInputViewController, text: String?) -> Bool {
        return text?.length < 51
    }
}

extension AITaskTagViewController: AITaskNavigationBarDelegate {
	func navigationBar(navigationBar: AITaskNavigationBar, cancelButtonPressed: UIButton) {
		print("cancel button pressed")
		if let onDidCancel = onDidCancel {
			onDidCancel()
		}
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func navigationBar(navigationBar: AITaskNavigationBar, saveButtonPressed: UIButton) {
		var selected: Array<RequirementTag> = Array()
		var unSelected: Array<RequirementTag> = Array()
		
		for currentTag in tags {
			if currentTag.selected {
				selected.append(currentTag)
			}
			else {
				unSelected.append(currentTag)
			}
		}
        
        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIRequireContentViewControllerCellWrappNotificationName, object: nil)
        
		dismissViewControllerAnimated(true, completion: { () -> Void in
			if let onDidSelected = self.onDidSelected {
				onDidSelected(selectedTags: selected, unSelectedTags: unSelected)
			}
		})
	}
}
