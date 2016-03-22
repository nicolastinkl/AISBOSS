//
//  AITaskTagViewController.swift
//  AIVeris
//
//  Created by admin on 3/21/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AITaskTagViewController: RRTagController {
	class func tagController(tagsString: [String]?,
		blockFinish: (selectedTags: Array<Tag>, unSelectedTags: Array<Tag>) -> (), blockCancel: () -> ()) -> AITaskTagViewController {
			
			let tagController = AITaskTagViewController()
			tagController.tags = Array()
			if tagsString != nil {
				for currentTag in tagsString! {
					tagController.tags.append(Tag(isSelected: false, textContent: currentTag))
				}
			}
			tagController.blockCancel = blockCancel
			tagController.blockFinish = blockFinish
			return tagController
	}
	
	override func addTagDidClick() {
		print("addTagDidClick")
		let vc = AITaskRemarkInputViewController()
        vc.delegate = self
		navigationController?.presentPopupViewController(vc, animated: true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Tag"
		setupNavigationToAppTheme()
		// Do any additional setup after loading the view.
	}
}

extension AITaskTagViewController: AITaskRemarkInputViewControllerDelegate {
	func remarkInputViewControllerDidEndEditing(sender: AITaskRemarkInputViewController, text: String?) {
		let spaceSet = NSCharacterSet.whitespaceCharacterSet()
		if let contentTag = text?.stringByTrimmingCharactersInSet(spaceSet) {
			if strlen(contentTag) > 0 {
				let newTag = Tag(isSelected: false, textContent: contentTag)
				tags.insert(newTag, atIndex: tags.count)
				collectionTag.reloadData()
			}
		}
	}
}

extension AITaskTagViewController: AITaskNavigationDelegate {
	func cancelButtonPressed(sender: UIButton) {
		print("cancel button pressed")
		if let blockCancel = blockCancel {
			blockCancel()
		}
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func saveButtonPressed(sender: UIButton) {
		var selected: Array<Tag> = Array()
		var unSelected: Array<Tag> = Array()
		
		for currentTag in tags {
			if currentTag.isSelected {
				selected.append(currentTag)
			}
			else {
				unSelected.append(currentTag)
			}
		}
		dismissViewControllerAnimated(true, completion: { () -> Void in
			if let blockFinish = self.blockFinish {
				blockFinish(selectedTags: selected, unSelectedTags: unSelected)
			}
		})
	}
}
