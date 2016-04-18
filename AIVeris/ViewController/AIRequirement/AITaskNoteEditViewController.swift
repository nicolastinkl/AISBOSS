//
//  AITaskNoteEditViewController.swift
//  AIVeris
//
//  Created by admin on 3/21/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AITaskNoteEditViewController: UIViewController {
	
	var contentModel: AIChildContentCellModel?
	var requirementItem: AIRequirementItem?
	var textView: KMPlaceholderTextView!
	var iconLabel: UILabel!
	var businessModel: AIQueryBusinessInfos?
	var iconImageView: UIImageView!
	var iconContainerView: UIView!
	
	struct Constants {
		static let textViewLeadingSpace: CGFloat = 35 / 3
		static let textViewTopSpace: CGFloat = 22 / 3
		static let textViewHeight: CGFloat = 490 / 3
		static let placeholderFont = AITools.myriadLightSemiCondensedWithSize(48 / 3)
		static let iconContainerLeadingSpace: CGFloat = 40 / 3
		static let iconContainerHeight: CGFloat = 200 / 3
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationAndBackgroundImage(backgroundColor: UIColorFromHex(0x558bdc, alpha: 0.22))
		navigationBar.titleLabel.text = "Note"
		setupTextView()
		setupIconView()
		
		updateUI()
		textView.becomeFirstResponder()
	}
	
	func updateUI() {
		if let requirementItem = requirementItem {
			if let desc = (requirementItem.requirement.first as? AIRequirement)?.desc {
				textView?.placeholder = desc
			}
			iconLabel?.text = textView?.placeholder
			if let url = requirementItem.service_provider_icons.first as? String {
				iconImageView.asyncLoadImage(url)
			}
		} else {
			iconContainerView.hidden = true
		}
        
        if contentModel != nil {
            textView?.placeholder = ""
        }
	}
	
	func setupTextView() {
		textView = KMPlaceholderTextView()
		textView.backgroundColor = UIColor.clearColor()
		textView.font = Constants.placeholderFont
		textView.textColor = UIColor.whiteColor()
		textView.placeholderFont = Constants.placeholderFont
		textView.placeholderColor = UIColorFromHex(0xffffff, alpha: 0.28)
		view.addSubview(textView)
		
		textView.snp_makeConstraints { (make) in
			make.leading.equalTo(view).offset(Constants.textViewLeadingSpace)
			make.top.equalTo(navigationBar.snp_bottom).offset(Constants.textViewTopSpace)
			make.trailing.equalTo(view).offset(-Constants.textViewLeadingSpace)
			make.height.equalTo(Constants.textViewHeight)
		}
	}
	
	func setupIconView() {
		iconContainerView = UIImageView(image: UIImage(named: "ai_rac_bg_normal"))
        iconContainerView.userInteractionEnabled = true
		view.addSubview(iconContainerView)
        iconContainerView.snp_makeConstraints { (make) in
            make.top.equalTo(textView.snp_bottom)
            make.leading.equalTo(view).offset(Constants.iconContainerLeadingSpace)
            make.trailing.equalTo(view).offset(-Constants.iconContainerLeadingSpace)
            make.height.equalTo(Constants.iconContainerHeight)
        }
		
		iconLabel = UILabel()
		iconLabel.font = Constants.placeholderFont
		iconLabel.textColor = textView.textColor
		iconContainerView.addSubview(iconLabel)
		
		iconLabel.snp_makeConstraints { (make) in
			make.leading.equalTo(40 / 3)
			make.top.equalTo(30 / 3)
			make.trailing.equalTo(iconContainerView).offset(-40 / 3)
		}
		
		if let contentModel = contentModel {
			iconLabel.hidden = true
			let lengthAudio = contentModel.audioLengh ?? 0
			
			let audioModel = AIProposalServiceDetailHopeModel()
			audioModel.audio_url = contentModel.audioUrl ?? ""
			audioModel.time = lengthAudio
			let audio1 = AIAudioMessageView.currentView()
			iconContainerView.addSubview(audio1)
			audio1.tag = 11
			audio1.fillData(audioModel)
			audio1.snp_makeConstraints { (make) in
				make.leading.equalTo(0)
				make.top.equalTo(30 / 3)
				make.trailing.equalTo(iconContainerView).offset(-40 / 3)
                make.height.equalTo(22)
			}
			audio1.smallMode()
		}
		
		let line = UIImageView(image: UIImage(named: "orderline"))
		iconContainerView.addSubview(line)
		line.snp_makeConstraints { (make) in
			make.height.equalTo(1)
			make.leading.trailing.equalTo(iconContainerView)
			make.top.equalTo(110 / 3)
		}
		
		iconImageView = UIImageView(image: UIImage(named: "icon-amazon"))
		iconImageView.layer.cornerRadius = 10
		iconImageView.backgroundColor = UIColor.redColor()
		iconContainerView.addSubview(iconImageView)
		
		iconImageView.snp_makeConstraints { (make) in
			make.bottom.equalTo(iconContainerView).offset(-5)
			make.leading.equalTo(iconLabel)
			make.size.equalTo(CGSize(width: 20, height: 20))
		}
	}
}

// MARK: - AITaskNavigationBarDelegate
extension AITaskNoteEditViewController: AITaskNavigationBarDelegate {
	
	func navigationBar(navigationBar: AITaskNavigationBar, cancelButtonPressed sender: UIButton) {
		print("cancel button pressed")
		view.endEditing(true)
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func navigationBar(navigationBar: AITaskNavigationBar, saveButtonPressed sender: UIButton) {
		view.endEditing(true)
		
		// save here
		view.showLoading()
		weak var wf = self
		
		let cellWrapperModel = AIRequirementViewPublicValue.bussinessModel?.baseJsonValue
		let comp_user_id = (cellWrapperModel?.comp_user_id)!
		let customer_id: String = (cellWrapperModel?.customer.customer_id.stringValue)! as String
		let order_id = (cellWrapperModel?.order_id)!
		let requirement_id = (AIRequirementViewPublicValue.cellContentTransferValue?.cellmodel?.childServices?.first?.requirement_id)
		let requirement_type = (AIRequirementViewPublicValue.cellContentTransferValue?.cellmodel?.category)
        
        let service_id = AIRequirementViewPublicValue.cellContentTransferValue?.cellmodel?.childServices?.first?.service_id ?? (AIRequirementViewPublicValue.bussinessModel?.baseJsonValue!.comp_service_id)!

		
        AIRequirementHandler.defaultHandler().addNewNote(service_id,comp_user_id:comp_user_id, customer_id: customer_id, order_id: order_id, requirement_id: requirement_id, requirement_type: requirement_type, analysis_type: "WishNote", note_content: textView.text, success: { (unassignedNum) -> Void in
			wf!.shouldDismissSelf(true)
			
			NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIAIRequirementNotifyOperateCellNotificationName, object: nil, userInfo: [AIApplication.JSONREPONSE.unassignedNum: unassignedNum])
		}) { (errType, errDes) -> Void in
			wf!.shouldDismissSelf(false)
		}
	}
	
	func shouldDismissSelf(didSuccess: Bool) {
		view.hideLoading()
		
		if didSuccess {
			NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIRequireContentViewControllerCellWrappNotificationName, object: nil)
		}
		
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}
