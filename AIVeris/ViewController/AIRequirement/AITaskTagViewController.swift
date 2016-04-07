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
        
        // save here
        view.showLoadingWithMessage("请稍候...")
        weak var wf = self
        
        AIRequirementHandler.defaultHandler().addNewTag(1, tagName: "", tagType: "", tagContent: "", success: { (newTag) -> Void in
            
            let spaceSet = NSCharacterSet.whitespaceCharacterSet()
            if let contentTag = text?.stringByTrimmingCharactersInSet(spaceSet) {
                if strlen(contentTag) > 0 {
                    let newTag = RequirementTag(id: newTag.tag_id.integerValue, selected: false, textContent: newTag.tag_content)
                    wf!.tags.insert(newTag, atIndex: wf!.tags.count)
                    wf!.collectionTag.reloadData()
                }
            }
            
            }) { (errType, errDes) -> Void in
                
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
        
        // save here
        view.showLoadingWithMessage("请稍候...")
        weak var wf = self
        AIRequirementHandler.defaultHandler().saveTagsAsTask(1, customID: 1, orderID: 1, requirementID: 1, requirementType: "", toType: "", requirementList: [], success: { (unassignedNum) -> Void in
            wf!.view.dismissLoading()
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIRequireContentViewControllerCellWrappNotificationName, object: nil)
            
            wf!.dismissViewControllerAnimated(true, completion: { () -> Void in
                if let onDidSelected = wf!.onDidSelected {
                    onDidSelected(selectedTags: selected, unSelectedTags: unSelected)
                }
            })

            
            }) { (errType, errDes) -> Void in
                
        }
        
        
        
        
        	}
}
