//
//  ServiceViewContainer.swift
//  AIVeris
//
//  Created by Rocky on 15/11/3.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class ServiceViewContainer: UIView {
    
    private static let INDICATOR_WIDTH: CGFloat = 10
    private static let SERVICE_HEIGHT: CGFloat = 200
    private var leftIndicator: LeftIndicator!
    var rightServiceView: RightServiceView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelf()
    }
    
    private func initSelf() {
        
        leftIndicator = LeftIndicator(frame: CGRect(x: 0, y: 0, width: ServiceViewContainer.INDICATOR_WIDTH, height: ServiceViewContainer.SERVICE_HEIGHT))
        rightServiceView = RightServiceView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        addSubview(leftIndicator)
        addSubview(rightServiceView)
        
        layout(leftIndicator, rightServiceView) {indicator, service in
            service.top == indicator.top
            service.left == indicator.right
            service.right == service.superview!.right
            service.height == ServiceViewContainer.SERVICE_HEIGHT
        }
        
        frame.size.height = leftIndicator.frame.height
    }
    
    class LeftIndicator: UIView {
        
    }
    
    class RightServiceView: UIView {
        private static let LOGO_WIDTH: CGFloat = 20
        private static let LOGO_HEIGHT: CGFloat = LOGO_WIDTH
        private static let PADDING_TOP: CGFloat = 20
        private static let PADDING_LEFT: CGFloat = 20
        private static let PADDING_RIGHT: CGFloat = 10
        private static let PADDING_BOTTOM: CGFloat = 20
        
        private var logo: UIImageView!
        private var name: UILabel!
        private var price: UILabel!
        private var grade: UIImageView!
        
        private var content: UIView?
        
        var contentView: UIView? {
            get {
                return content
            }
            set {
                content = newValue
                if content != nil {
                    addjustContentFrame()
                    addSubview(content!)
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
            addLogo()
            addGrade()
            addPrice()
            addTitle()
        }
        
        private func addLogo() {
            logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            
            logo.layer.cornerRadius = RightServiceView.LOGO_WIDTH / 2
            logo.layer.masksToBounds = true
            
            addSubview(logo)
            
            layout(logo) { logView in
                logView.top == logView.superview!.top + RightServiceView.PADDING_TOP
                logView.left == logView.superview!.left + RightServiceView.PADDING_LEFT
                logView.width == RightServiceView.LOGO_WIDTH
                logView.height == RightServiceView.LOGO_HEIGHT
            }
            
            logo.asyncLoadImage("http://static.wolongge.com/uploadfiles/company/8a0b0a107a1d3543fd22e9591ba4601f.jpg")
        }
        
        private func addGrade() {
            grade = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            addSubview(grade)
            
            layout(logo, grade) {logo, grade in
                grade.top == logo.top
                grade.right == grade.superview!.right - RightServiceView.PADDING_RIGHT
                grade.height == logo.height
                grade.width == grade.height * 1.5
            }
            
            grade.asyncLoadImage("http://pic.baike.soso.com/p/20100114/bki-20100114182657-1449988150.jpg")
        }
        
        private func addPrice() {
            price = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            price.textAlignment = .Right
            addSubview(price)
            
            layout(grade, price) {grade, price in
                price.top == grade.top
                price.right == grade.left - 3
                price.height == grade.height
                price.width == 60
            }
            
            price.text = "$500"
        }
        
        private func addTitle() {
            name = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            name.font = PurchasedViewFont.SERVICE_TITLE
            
            addSubview(name)
            
            layout(price, logo, name) {price, logo, name in
                name.top == logo.top
                name.left == logo.right + 5
                name.height == RightServiceView.LOGO_HEIGHT
                name.right == price.left - 30
            }
            
            name.text = "Mu576"
        }
        
        private func addjustContentFrame() {
            let oldFrame = content!.frame
            content!.frame = CGRect(x: RightServiceView.PADDING_LEFT, y: logo.frame.origin.y + logo.frame.height + 10, width: frame.width - RightServiceView.PADDING_LEFT - RightServiceView.PADDING_RIGHT, height: oldFrame.height)
        }
    }
}
