//
//  PurchasedServiceView.swift
//  AIVeris
//  已经订购的服务视图
//
//  Created by Rocky on 15/10/21.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography
import AISpring

class PurchasedServiceView: UIView, Measureable {
    
    private var logo: UIImageView!
    private var title: UILabel!
    private var statu: UILabel!
    private var eyeIcon: UIImageView!
    private var contactIcon: UIImageView!
    private var bellIcon: UIImageView!
    private var serviceDescription: UILabel!
    
    private var expandContent: UIView?
    
    var dimentionListener: DimentionChangable?
    private var serviceOrderModel: ServiceOrderModel?
    var serviceOrderStateProtocal: ServiceOrderStateProtocal?
    
    private let EYE_ENABLE_IMAGE = "eye_enable.png"
    private let EYE_DISABLE_IMAGE = "eye_disable.png"
    private let CONTENT_TOP_MARGIN: CGFloat = 20 / PurchasedViewDimention.CONVERT_FACTOR
    private let DESCRIPTION_ONE_LINE_HEIGHT: CGFloat = 30
    private let BOTTOM_PADDING_MARGIN: CGFloat = 48 / PurchasedViewDimention.CONVERT_FACTOR
    
    var serviceOrderData: ServiceOrderModel? {
        get {
            return serviceOrderModel
        }
        
        set {
            serviceOrderModel = newValue
            
            if let model = newValue {
                logo.asyncLoadImage(model.service_thumbnail_icon)
                title.text = model.service_name
                statu.text = model.order_state
                serviceDescription.text = model.service_intro
                
                if (model.service_intro == "") {
                    hideDescriptionLabel()
                } else {
                    setDescriptionLabelHeight()
                }
            }
        }
    }
    
    private func hideDescriptionLabel() {
        frame.size.height = frame.size.height - DESCRIPTION_ONE_LINE_HEIGHT + BOTTOM_PADDING_MARGIN
    }
    
    private func setDescriptionLabelHeight() {
        let descriptionWidth = serviceDescription.superview!.width - PurchasedViewDimention.PROPOSAL_PADDING_LEFT - PurchasedViewDimention.PROPOSAL_PADDING_RIGHT
        
        let size = serviceOrderModel!.service_intro.sizeWithFont(serviceDescription.font, forWidth: descriptionWidth)
        
        var descriptionHeight = DESCRIPTION_ONE_LINE_HEIGHT
        
        if size.height / serviceDescription.font.lineHeight > 1 {
            let ADDITION_HEIGHT: CGFloat = 10
            descriptionHeight += ADDITION_HEIGHT
            frame.size.height += ADDITION_HEIGHT
        }
        
        layout(statu, serviceDescription) { statu, serviceDescription in
            serviceDescription.top == statu.bottom - 2
            serviceDescription.left == serviceDescription.superview!.left + PurchasedViewDimention.PROPOSAL_PADDING_LEFT
            serviceDescription.width == serviceDescription.superview!.width - PurchasedViewDimention.PROPOSAL_PADDING_LEFT - PurchasedViewDimention.PROPOSAL_PADDING_RIGHT
            serviceDescription.height >= descriptionHeight
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelf()
    }
    
    private func initSelf() {
        addTopDivider()
        addContent()
        
        eyeIcon.userInteractionEnabled = true
        eyeIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "eyeTap:"))
        bellIcon.userInteractionEnabled = true
        bellIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "bellTap:"))
        contactIcon.userInteractionEnabled = true
        contactIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "contactTap:"))
    }
    
    private func addTopDivider() {
        let divider = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 1))
        divider.backgroundColor = PurchasedViewColor.DIVIDER
        addSubview(divider)
    }
    
    private func addContent() {
        addLogo()
        addTitle()
        addStatu()
        addDescription()
        addAddutionalIcons()
    }
    
    private func addLogo() {
        logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        logo.layer.cornerRadius = PurchasedViewDimention.LOGO_WIDTH / 2
        logo.layer.masksToBounds = true
        
        addSubview(logo)
        
        layout(logo) { logView in
            logView.top == logView.superview!.top + PurchasedViewDimention.LOGO_MARGIN_TOP
            logView.left == logView.superview!.left + PurchasedViewDimention.PROPOSAL_PADDING_LEFT
            logView.width == PurchasedViewDimention.LOGO_WIDTH
            logView.height == PurchasedViewDimention.LOGO_HEIGHT
        } 
    }
    
    private func addTitle() {
        title = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        title.font = PurchasedViewFont.SERVICE_TITLE
        title.textColor = PurchasedViewColor.TITLE
        title.text = "Home Delivery"
        addSubview(title)
        
        layout(logo, title) { logo, title in
            title.top == logo.top - 4
            title.left == logo.right + 10
            title.height == 20
        }
    }
    
    private func addStatu() {
        statu = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        statu.font = PurchasedViewFont.SERVICE_STATU
        statu.textColor = PurchasedViewColor.SERVICE_STATU
        statu.text = "Ongoing"
        addSubview(statu)
        
        layout(title, statu) { title, statu in
            statu.top == title.bottom - 2
            statu.left == title.left
            statu.width == title.width
            statu.height == PurchasedViewDimention.SERVICE_STATU_HEIGHT
        }
    }
    
    private func addDescription() {
        serviceDescription = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        serviceDescription.font = PurchasedViewFont.SERVICE_DESCRIPTION
        serviceDescription.textColor = PurchasedViewColor.DEFAULT
        serviceDescription.text = "Your ordered items have arrived at Shanghai storehouse, ready to be sent to Beijing."
        serviceDescription.numberOfLines = 2
        addSubview(serviceDescription)
        
        
    }
    
    private func addAddutionalIcons() {
        contactIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        contactIcon.image = UIImage(named: "contact_icon.png")
        addSubview(contactIcon)
        
        bellIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bellIcon.image = UIImage(named: "bell_icon.png")
        addSubview(bellIcon)
        
        eyeIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        eyeIcon.image = UIImage(named: EYE_DISABLE_IMAGE)
        addSubview(eyeIcon)
        
        layout(contactIcon) { contacView in
            contacView.top == contacView.superview!.top + PurchasedViewDimention.LOGO_MARGIN_TOP
            contacView.right == contacView.superview!.right - PurchasedViewDimention.PROPOSAL_PADDING_RIGHT
            contacView.width == PurchasedViewDimention.ICON_WIDTH
            contacView.height == PurchasedViewDimention.ICON_HEIGHT
        }
        
        layout(contactIcon, bellIcon) { contact, bell in
            bell.top == contact.top
            bell.right == contact.left - PurchasedViewDimention.ADDITIONAL_ICON_MARGIN
            bell.width == contact.width
            bell.height == contact.height
        }
        
        layout(bellIcon, eyeIcon) { bell, eye in
            eye.top == bell.top
            eye.right == bell.left - PurchasedViewDimention.ADDITIONAL_ICON_MARGIN
            eye.width == bell.width
            eye.height == bell.height
        }
        
        layout(eyeIcon, title) { eyeIcon, title in
            title.right == eyeIcon.left - 10
        }

    }
    
    func addExpandView(view: UIView) {
        expandContent = view
        expandContent?.hidden = true
        adjustAddedViewFrame(view)
        addSubview(view)
        
        eyeIcon.image = UIImage(named: EYE_ENABLE_IMAGE)
    }
    
    func getHeight() -> CGFloat {
        return frame.height
    }
    
    private func adjustAddedViewFrame(addedView: UIView) {
        let oldFrame = addedView.frame
        addedView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height + CONTENT_TOP_MARGIN, width: frame.width, height: oldFrame.height)
    }
    
    
    
    func eyeTap(sender: UITapGestureRecognizer) {
        if let contentView = expandContent {
            if orderIsComplete() {
                checkOrderAndChangeState()
            }
            
            if (contentView.hidden) {
                adjustFrameToExpand()
            } else {
                adjustFrameToCollapse()
            }
            
           contentView.hidden = !contentView.hidden
        }    
    }
    
    func bellTap(sender: UITapGestureRecognizer) {
        
    }
    
    func contactTap(sender: UITapGestureRecognizer) {
        
    }
    
    private func orderIsComplete() -> Bool {
        let state = ServiceOrderState(rawValue: serviceOrderModel!.order_state)
        return state == ServiceOrderState.Completed
    }
    
    private func checkOrderAndChangeState() {
        let oldState = ServiceOrderState(rawValue: serviceOrderModel!.order_state)
        serviceOrderModel!.order_state = ServiceOrderState.CompletedAndChecked.rawValue
        serviceOrderStateProtocal?.orderStateChanged(serviceOrderModel!, oldState: oldState!)
    }
    
    private func adjustFrameToExpand() {
        let oldFrame = frame
        frame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: oldFrame.width, height: oldFrame.height + CONTENT_TOP_MARGIN + expandContent!.frame.height)
        
        dimentionListener?.heightChanged(self, beforeHeight: oldFrame.height, afterHeight: frame.height)
    }
    
    private func adjustFrameToCollapse() {
        let oldFrame = frame
        frame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: oldFrame.width, height: oldFrame.height - expandContent!.frame.height)
        
        dimentionListener?.heightChanged(self, beforeHeight: oldFrame.height, afterHeight: frame.height)
    }

}
