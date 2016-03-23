//
//  AITaskTagViewController.swift
//  AIVeris
//
//  Created by admin on 3/21/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AITaskTagViewController: RRTagController {

	override func addTagDidClick() {
		print("addTagDidClick")
		let vc = AITaskRemarkInputViewController()
		vc.delegate = self
		presentPopupViewController(vc, animated: true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Tag"
		
        collectionTag.reloadData()
		setupNavigationToAppTheme()
		// Do any additional setup after loading the view.
	}
}

extension AITaskTagViewController: AITaskRemarkInputViewControllerDelegate {
	func remarkInputViewControllerDidEndEditing(sender: AITaskRemarkInputViewController, text: String?) {
		let spaceSet = NSCharacterSet.whitespaceCharacterSet()
		if let contentTag = text?.stringByTrimmingCharactersInSet(spaceSet) {
			if strlen(contentTag) > 0 {
				let newTag = RequirementTag(id: random() % 10000,selected: false, textContent: contentTag)
				tags.insert(newTag, atIndex: tags.count)
				collectionTag.reloadData()
			}
		}
	}
}

extension AITaskTagViewController: AITaskNavigationDelegate {
	func cancelButtonPressed(sender: UIButton) {
		print("cancel button pressed")
		if let onDidCancel = onDidCancel {
			onDidCancel()
		}
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func saveButtonPressed(sender: UIButton) {
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
		dismissViewControllerAnimated(true, completion: { () -> Void in
			if let onDidSelected = self.onDidSelected {
				onDidSelected(selectedTags: selected, unSelectedTags: unSelected)
			}
		})
	}
}
