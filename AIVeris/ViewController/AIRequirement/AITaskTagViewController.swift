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
    func remarkInputViewControllerDidEndEditing(sender: AITaskInputViewController, text: String?) {
        
        guard let _ = text else {
            return
        }
        
        // save here
        view.showLoading()
        weak var wf = self
        
        let service_id = AIRequirementViewPublicValue.cellContentTransferValue?.cellmodel?.childServices?.first?.service_id ?? (AIRequirementViewPublicValue.bussinessModel?.baseJsonValue!.comp_service_id)!
        
        AIRequirementHandler.defaultHandler().addNewTag(service_id, tag_type: "Text", tag_content: text!, success: { (newTag) -> Void in
            
            let spaceSet = NSCharacterSet.whitespaceCharacterSet()
            if let contentTag = text?.stringByTrimmingCharactersInSet(spaceSet) {
                if strlen(contentTag) > 0 {
                    let newTag = RequirementTag(id: newTag.tag_id.integerValue, selected: false, textContent: newTag.tag_content)
                    wf!.tags.insert(newTag, atIndex: wf!.tags.count)
                    wf!.collectionTag.reloadData()
                    wf!.view.hideLoading()
                }
            }
            
        }) { (errType, errDes) -> Void in
            wf!.view.hideLoading()
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
        var selected: Array<String> = Array()
        var unSelected: Array<RequirementTag> = Array()
        
        for currentTag in tags {
            if currentTag.selected {
                selected.append("\(currentTag.id)")
            }
            else {
                unSelected.append(currentTag)
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
        
        AIRequirementHandler.defaultHandler().saveTagsAsTask(comp_user_id, customer_id: customer_id, order_id: order_id, requirement_id: requirement_id, requirement_type: requirement_type, analysis_type: "WishTag", analysis_ids: selected, success: { (unassignedNum) -> Void in
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
