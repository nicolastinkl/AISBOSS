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
    
    private let EYE_ENABLE_IMAGE = "eye_enable.png"
    private let EYE_DISABLE_IMAGE = "eye_disable.png"
    
    var serviceOrderData: ServiceOrderModel? {
        get {
            return serviceOrderModel
        }
        
        set {
            if let model = newValue {
                logo.asyncLoadImage(model.service_thumbnail_icon)
                title.text = model.service_name
                serviceDescription.text = model.service_intro
            }
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
        
        logo.asyncLoadImage("http://static.wolongge.com/uploadfiles/company/8a0b0a107a1d3543fd22e9591ba4601f.jpg")
    }
    
    private func addTitle() {
        title = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        title.font = PurchasedViewFont.SERVICE_TITLE
        title.textColor = PurchasedViewColor.TITLE
        title.text = "Home Delivery"
        addSubview(title)
        
        layout(logo, title) { logo, title in
            title.top == logo.top - 2
            title.left == logo.right + 10
            title.width == 140
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
            statu.top == title.bottom
            statu.left == title.left
            statu.width == 60
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
        
        layout(statu, serviceDescription) { statu, serviceDescription in
            serviceDescription.top == statu.bottom
            serviceDescription.left == serviceDescription.superview!.left + PurchasedViewDimention.PROPOSAL_PADDING_LEFT
            serviceDescription.width == serviceDescription.superview!.width - PurchasedViewDimention.PROPOSAL_PADDING_LEFT - PurchasedViewDimention.PROPOSAL_PADDING_RIGHT
            serviceDescription.height == 30
        }
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
            bell.right == contact.left - 4
            bell.width == contact.width
            bell.height == contact.height
        }
        
        layout(bellIcon, eyeIcon) { bell, eye in
            eye.top == bell.top
            eye.right == bell.left - 4
            eye.width == bell.width
            eye.height == bell.height
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
        addedView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.height, width: frame.width, height: oldFrame.height)
    }
    
    
    
    func eyeTap(sender: UITapGestureRecognizer) {
        if let contentView = expandContent {
            if (contentView.hidden) {
                adjustFrameToExpand()
                
                eyeIcon.image = UIImage(named: EYE_DISABLE_IMAGE)
            } else {
                adjustFrameToCollapse()
                
                eyeIcon.image = UIImage(named: EYE_ENABLE_IMAGE)
            }
            
           contentView.hidden = !contentView.hidden
        }    
    }
    
    private func adjustFrameToExpand() {
        let oldFrame = frame
        frame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: oldFrame.width, height: oldFrame.height + expandContent!.frame.height)
        
        dimentionListener?.heightChanged(self, beforeHeight: oldFrame.height, afterHeight: frame.height)
    }
    
    private func adjustFrameToCollapse() {
        let oldFrame = frame
        frame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: oldFrame.width, height: oldFrame.height - expandContent!.frame.height)
        
        dimentionListener?.heightChanged(self, beforeHeight: oldFrame.height, afterHeight: frame.height)
    }

}
