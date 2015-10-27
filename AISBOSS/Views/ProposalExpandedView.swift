//
//  ProposalExpandedView.swift
//  AIVeris
//
//  Created by admin on 15/10/21.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class ProposalExpandedView: UIView, Measureable, DimentionChangable {
    
    private var title: UILabel!
    private var statu: UILabel!
    private var serviceViews: [PurchasedServiceView] = []
    var dimentionListener: DimentionChangable?
    var indexPath: NSIndexPath?
    private var propodalModel: ProposalModel?

    
    var proposalOrder: ProposalModel? {
        get {
            return propodalModel
        }
        
        set {
            if let model = newValue {
                title.text = model.proposal_name
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        title = UILabel(frame: CGRect(x: PurchasedViewDimention.PROPOSAL_PADDING_LEFT, y: PurchasedViewDimention.PROPOSAL_TITLE_MARGIN_TOP, width: 200, height: PurchasedViewDimention.PROPOSAL_TITLE_HEIGHT))
        title.font = PurchasedViewFont.TITLE
        title.textColor = PurchasedViewColor.TITLE
        title.text = "Shop-on-behalf Service"
        headView.addSubview(title)
        
        statu = UILabel(frame: CGRect(x: title.frame.width + 10, y: PurchasedViewDimention.PROPOSAL_STATU_MARGIN_TOP, width: 80, height: PurchasedViewDimention.PROPOSAL_STATU_HEIGHT))
        
        statu.backgroundColor = PurchasedViewColor.STATU_BACKGROUND
        statu.font = PurchasedViewFont.STATU
        statu.textColor = PurchasedViewColor.STATU
        statu.text = "On Schedule"
        statu.layer.cornerRadius = 6
        statu.layer.masksToBounds = true
        statu.textAlignment = .Center
        headView.addSubview(statu)
        
        layout(statu) { statuView in
            statuView.top == statuView.superview!.top + PurchasedViewDimention.PROPOSAL_TITLE_MARGIN_TOP
            statuView.right == statuView.superview!.right - PurchasedViewDimention.PROPOSAL_PADDING_RIGHT
            statuView.width == 80
            statuView.height == PurchasedViewDimention.PROPOSAL_STATU_HEIGHT
        }
        
        addSubview(headView)
    }
    
    func getHeight() -> CGFloat {
        var height: CGFloat = PurchasedViewDimention.PROPOSAL_HEAD_HEIGHT
        
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
        var height: CGFloat = PurchasedViewDimention.PROPOSAL_HEAD_HEIGHT
        
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
