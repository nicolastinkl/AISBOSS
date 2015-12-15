//
//  ProposalExpandedView.swift
//  AIVeris
//
//  Created by Rocky on 15/10/21.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class ProposalExpandedView: UIView, Measureable, DimentionChangable {
    
    private var title: UILabel!
    private var statu: UILabel!
    private var alertIcon: UIImageView!
    private var serviceViews: [PurchasedServiceView] = []
    private var serviceModels: [ServiceOrderModel] = []
    var dimentionListener: DimentionChangable?
    private var proposalModel: ProposalOrderModel?
    var serviceOrderNumberIsChanged: Bool = false
    private var initHeight: CGFloat = 0
    var delegate: ProposalExpandedDelegate?
    
    var proposalOrder: ProposalOrderModel? {
        get {
            return proposalModel
        }
        
        set {
            proposalModel = newValue
            
            if let model = newValue {
                title.text = model.proposal_name
                
                if orderIsNormal(model) {
                    showNormalStatu()
                } else {
                    showAlertStatu()
                }
                
                appendServiceOrdersView()
            }
        }
    }
    
    private func orderIsNormal(orderModel: ProposalOrderModel) -> Bool {
        return orderModel.alarm_state == 1
    }
    
    private func showNormalStatu() {
        statu.hidden = false
        statu.text = "ProposalExpandedView.onSchedule".localized
        
        alertIcon.hidden = true
    }
    
    private func showAlertStatu() {
        statu.hidden = true
        alertIcon.hidden = false
    }
    
    private func appendServiceOrdersView() {
        for serviceModel in proposalModel!.order_list {
            let serviceOrder = serviceModel as! ServiceOrderModel
            
            if orderIsCompletedAndChecked(serviceOrder) {
                continue
            }
            
            let serviceView = PurchasedServiceView(frame: CGRect(x: 0, y: 0, width: frame.width, height: PurchasedViewDimention.SERVICE_COLLAPSED_HEIGHT))
            serviceView.serviceOrderStateProtocal = self
            serviceView.serviceOrderData = serviceOrder
            
            if serviceOrder.param_list != nil && serviceOrder.param_list.count > 0 {
                for paraModel in serviceOrder.param_list {
                    let param = paraModel as! ParamModel
                    var expandContentView: UIView?
                    
                    expandContentView = ServiceOrderExpandContentViewFactory.createExpandContentView(param)
                    
                    if expandContentView != nil {
                        expandContentView?.frame = CGRect(x: 0, y: 0, width: frame.width, height: expandContentView!.frame.height)
                        serviceView.addExpandView(expandContentView!)
                    }
                }
            }
            
            addServiceView(serviceView)
        }
    }
    
    private func orderIsCompletedAndChecked(serviceOrder: ServiceOrderModel) -> Bool {
        let state = ServiceOrderState(rawValue: serviceOrder.order_state)
        return state == ServiceOrderState.CompletedAndChecked
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        initHeight = frame.height
        initSelf()
        
        backgroundColor = PurchasedViewColor.BACKGROUND
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelf()
    }
    
    private func initSelf() {
        addHeadView()
    }
    
    private func addHeadView() {
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: super.frame.width, height: PurchasedViewDimention.PROPOSAL_HEAD_HEIGHT))
        headView.userInteractionEnabled = true
        headView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "headTap:"))
 
        statu = UILabel(frame: CGRect(x: 0, y: PurchasedViewDimention.PROPOSAL_STATU_MARGIN_TOP, width: 80, height: PurchasedViewDimention.PROPOSAL_STATU_HEIGHT))
        
        statu.backgroundColor = PurchasedViewColor.STATU_BACKGROUND
        statu.font = PurchasedViewFont.STATU
        statu.textColor = PurchasedViewColor.STATU
        statu.text = "ProposalExpandedView.onSchedule".localized
        statu.layer.cornerRadius = 8
        statu.layer.masksToBounds = true
        statu.textAlignment = .Center
        headView.addSubview(statu)
        
        layout(statu) { statuView in
            statuView.top == statuView.superview!.top + PurchasedViewDimention.PROPOSAL_TITLE_MARGIN_TOP
            statuView.right == statuView.superview!.right - PurchasedViewDimention.PROPOSAL_PADDING_RIGHT
            statuView.width == 80
            statuView.height == PurchasedViewDimention.PROPOSAL_STATU_HEIGHT
        }
        
        
        title = UILabel(frame: CGRect(x: PurchasedViewDimention.PROPOSAL_PADDING_LEFT, y: PurchasedViewDimention.PROPOSAL_TITLE_MARGIN_TOP, width: 200, height: PurchasedViewDimention.PROPOSAL_TITLE_HEIGHT))
        title.font = PurchasedViewFont.TITLE
        title.textColor = PurchasedViewColor.TITLE
        title.text = "ProposalExpandedView.shop".localized
        headView.addSubview(title)
        
        layout(statu, title) { statuView, title in
            title.top == title.superview!.top + PurchasedViewDimention.PROPOSAL_TITLE_MARGIN_TOP
            title.left == title.superview!.left + PurchasedViewDimention.PROPOSAL_PADDING_LEFT
            title.right == statuView.left - 10
            title.height == PurchasedViewDimention.PROPOSAL_TITLE_HEIGHT
        }
        
        alertIcon = UIImageView(image: UIImage(named: "AlertIcon.png"))
        headView.addSubview(alertIcon)
        
        layout(statu, alertIcon) { statu, alertIcon in
            alertIcon.top == statu.top
            alertIcon.right == statu.right
            alertIcon.width == 11
            alertIcon.height == 11
        }
        
        
        
        addSubview(headView)
    }
    
    func headTap(sender: UITapGestureRecognizer) {
        delegate?.headViewTapped(self)
    }
    
    func getHeight() -> CGFloat {
        var height: CGFloat = initHeight
        
        for serviceView in serviceViews {
            height += serviceView.frame.height
        }
        
        return height
    }
    
    func addServiceView(view: PurchasedServiceView) {
        
        serviceViews.append(view)
        adjustInsertViewFrame(view)
        addSubview(view)
        
        expandContainerFrame(view)
        view.dimentionListener = self
        
    }
    
    private func adjustInsertViewFrame(subview: UIView) {
        let oldFrame = subview.frame
        
        subview.frame = CGRect(x: 0, y: frame.height, width: oldFrame.width, height: oldFrame.height)
    }
    
    private func expandContainerFrame(insertedView: UIView) {
        let oldFrame = frame
        self.frame = CGRect(x: 0, y: 0, width: oldFrame.width, height: oldFrame.height + insertedView.frame.height)
    }
    
    func heightChanged(changedView: UIView, beforeHeight: CGFloat, afterHeight: CGFloat) {
        let oldFrame = frame
        recalculateFrame()
        dimentionListener?.heightChanged(self, beforeHeight: oldFrame.height, afterHeight: frame.height)
    }
    
    private func recalculateFrame() {
        var height: CGFloat = initHeight
        
        for var index = 0; index < serviceViews.count; index++ {
            height += serviceViews[index].frame.height
            
            if index > 0 {
                let preViewIndex = index - 1
                let preFrame = serviceViews[preViewIndex].frame
                let oldFrame = serviceViews[index].frame
                serviceViews[index].frame = CGRect(x: oldFrame.origin.x, y: preFrame.origin.y + preFrame.height, width: oldFrame.width, height: oldFrame.height)
            }
        }
        
        let oldFrame = frame
        self.frame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: oldFrame.width, height: height)
    }
}

extension ProposalExpandedView: ServiceOrderStateProtocal {
    func orderStateChanged(changedOrder: ServiceOrderModel, oldState: ServiceOrderState) {
        serviceOrderNumberIsChanged = true
    }
}

protocol ProposalExpandedDelegate {
    func headViewTapped(proposalView: ProposalExpandedView)
}

