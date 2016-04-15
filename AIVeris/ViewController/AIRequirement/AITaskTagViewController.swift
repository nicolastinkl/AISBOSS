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
    var businessModel : AIQueryBusinessInfos?
    
    var shouldShowInputTextField = false
    
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if shouldShowInputTextField {
            addTagDidClick()
        }
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
    func inputViewControllerDidEndEditing(sender: AITaskInputViewController, text: String?) {
        
        guard let _ = text else {
            return
        }
        
        // save here
        view.showLoading()
        weak var wf = self
        
        var service_id = AIRequirementViewPublicValue.cellContentTransferValue?.cellmodel?.childServices?.first?.service_id ?? (AIRequirementViewPublicValue.bussinessModel?.baseJsonValue!.comp_service_id)!
        
        if shouldShowInputTextField {
            service_id = "0"
        }
        AIRequirementHandler.defaultHandler().addNewTag(service_id, tag_type: "Text", tag_content: text!, success: { [unowned self] (newTag) -> Void in
            
            let spaceSet = NSCharacterSet.whitespaceCharacterSet()
            if let contentTag = text?.stringByTrimmingCharactersInSet(spaceSet) {
                if strlen(contentTag) > 0 {
                    let newTag = RequirementTag(id: newTag.tag_id.integerValue, selected: self.shouldShowInputTextField, textContent: newTag.tag_content)
                    wf!.tags.insert(newTag, atIndex: wf!.tags.count)
                    wf!.collectionTag.reloadData()
                    wf!.view.hideLoading()
                    if self.shouldShowInputTextField {
                       self.navigationBar(self.navigationBar, saveButtonPressed: self.navigationBar.saveButton)
                    }
                }
            }
            
        }) { (errType, errDes) -> Void in
            wf!.view.hideLoading()
        }
    }
    
    func inputViewControllerShouldEndEditing(sender: AITaskInputViewController, text: String?) -> Bool {
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
        var selectedTagIds: Array<String> = Array()
        
        for currentTag in tags {
            if currentTag.selected {
                selectedTagIds.append("\(currentTag.id)")
            }
            else {
            }
        }
        
        // save here
        view.showLoading()
        weak var wf = self
        let cellWrapperModel = AIRequirementViewPublicValue.bussinessModel?.baseJsonValue
        let comp_user_id = (cellWrapperModel?.comp_user_id)!
        let customer_id : String = (cellWrapperModel?.customer.customer_id.stringValue)! as String
        let order_id = (cellWrapperModel?.order_id)!
        let requirement_id = (AIRequirementViewPublicValue.cellContentTransferValue?.cellmodel?.childServices?.first?.requirement_id)
        let requirement_type = (AIRequirementViewPublicValue.cellContentTransferValue?.cellmodel?.category)
        
        AIRequirementHandler.defaultHandler().saveTagsAsTask(comp_user_id, customer_id: customer_id, order_id: order_id, requirement_id: requirement_id, requirement_type: requirement_type, analysis_type: "WishTag", analysis_ids: selectedTagIds, success: { (unassignedNum) -> Void in
            wf!.shouldDismissSelf(true)
            
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIAIRequirementNotifyOperateCellNotificationName, object: nil,userInfo: [AIApplication.JSONREPONSE.unassignedNum:unassignedNum])
            
            
            }) { (errType, errDes) -> Void in
                wf!.shouldDismissSelf(false)
        }
        
        
    }
    
    func shouldDismissSelf (didSuccess : Bool) {
        view.hideLoading()
        
        if didSuccess {
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIRequireContentViewControllerCellWrappNotificationName, object: nil)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
