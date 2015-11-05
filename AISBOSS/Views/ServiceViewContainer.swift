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
    
    private static let INDICATOR_WIDTH: CGFloat = 20
  //  private static let SERVICE_HEIGHT: CGFloat = 200
    private var leftIndicator: LeftIndicator!
    var rightServiceView: RightServiceView!
    private var dataModel: Int?
    
    var data: Int? {
        get {
            return dataModel
        }
        set {
            dataModel = newValue
            if dataModel != nil {
                if let serviceView = createServiceView(dataModel!) {
                    rightServiceView.contentView = serviceView
                    frame.size.height += serviceView.frame.height
                }
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
        
        leftIndicator = LeftIndicator(frame: CGRect(x: 0, y: 0, width: ServiceViewContainer.INDICATOR_WIDTH, height: 0))
        rightServiceView = RightServiceView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
  //      rightServiceView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        
        addSubview(leftIndicator)
        addSubview(rightServiceView)
        
        layout(leftIndicator, rightServiceView) {indicator, service in
            
            indicator.top == indicator.superview!.top
            indicator.left == indicator.superview!.left
            indicator.height == indicator.superview!.height
            indicator.width == ServiceViewContainer.INDICATOR_WIDTH
            
            service.top == indicator.top + ServiceViewContainer.INDICATOR_WIDTH / 2
            service.left == indicator.right - ServiceViewContainer.INDICATOR_WIDTH / 2 + 5
            service.right == service.superview!.right
            service.height == service.superview!.height - ServiceViewContainer.INDICATOR_WIDTH
        }
        
        frame.size.height = RightServiceView.getHeadHeight() + ServiceViewContainer.INDICATOR_WIDTH
    }
    
    private func createServiceView(data: Int) -> View? {
        switch data {
        case 0:
            return FlightService(frame: CGRect(x: 0, y: 0, width: rightServiceView.frame.width, height: 0))
        case 1:
            return TransportService(frame: CGRect(x: 0, y: 0, width: rightServiceView.frame.width, height: 0))
        case 2:
            return AccommodationService(frame: CGRect(x: 0, y: 0, width: rightServiceView.frame.width, height: 0))
        default:
            return nil
        }
    }   
}

class LeftIndicator: UIView {
    private var topBall: UIImageView!
    private var bottomBall: UIImageView!
    private var linkLine: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelf()
    }
    
    private func initSelf() {
        topBall = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBall = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        linkLine = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        topBall.image = UIImage(named: "white_ball.png")
        bottomBall.image = UIImage(named: "hollow_ball.png")
        linkLine.image = UIImage(named: "link_line_vertical.png")
        
        addSubview(topBall)
        addSubview(bottomBall)
        addSubview(linkLine)
        
        layout(topBall, bottomBall, linkLine) {topBall, bottomBall, linkLine in
            topBall.top == topBall.superview!.top
            topBall.left == topBall.superview!.left
            topBall.width == ServiceViewContainer.INDICATOR_WIDTH
            topBall.height == topBall.width
            
            bottomBall.bottom == bottomBall.superview!.bottom
            bottomBall.centerX == topBall.centerX
            bottomBall.height == 15
            bottomBall.width == bottomBall.height
            
            linkLine.top == topBall.bottom
            linkLine.centerX == topBall.centerX
            linkLine.width == 2
            linkLine.bottom == bottomBall.top
        }
    }
}


class RightServiceView: UIView {
    private static let LOGO_WIDTH: CGFloat = AITools.displaySizeFrom1080DesignSize(60)
    private static let LOGO_HEIGHT: CGFloat = LOGO_WIDTH
    private static let PADDING_TOP: CGFloat = AITools.displaySizeFrom1080DesignSize(34)
    private static let PADDING_LEFT: CGFloat = AITools.displaySizeFrom1080DesignSize(34)
    private static let PADDING_RIGHT: CGFloat = AITools.displaySizeFrom1080DesignSize(15)
    private static let PADDING_BOTTOM: CGFloat = 20
    private static let TITLE_MAGIN_BOTTOM: CGFloat = AITools.displaySizeFrom1080DesignSize(44)
    
    private var background: UIImageView!
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
                addjustSelfFrame()
                addSubview(content!)
                addBackground()
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
        //      layer.cornerRadius = 8
        //      layer.masksToBounds = true
        
        //     addBackground()
        addLogo()
        addGrade()
        addPrice()
        addTitle()
        setFrameToHeadSize()
    }
    
    private func addBackground() {
        background = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        let bkImg = UIImage(named: "white_top_unfilled_corner")
        let insets = UIEdgeInsetsMake(60, 70, 100, 100)
        bkImg?.resizableImageWithCapInsets(insets)
        background.image = bkImg
        
        insertSubview(background, atIndex: 0)
    //    addSubview(background)
        
        //            layout(background) {background in
        //                background.height == background.superview!.height
        //                background.width == background.superview!.width
        //                background.top == background.superview!.top
        //                background.left == background.superview!.left
        //            }
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
            grade.top == grade.superview!.top + AITools.displaySizeFrom1080DesignSize(43)
            grade.right == grade.superview!.right - RightServiceView.PADDING_RIGHT
            grade.height == AITools.displaySizeFrom1080DesignSize(40)
            grade.width == AITools.displaySizeFrom1080DesignSize(64)
        }
        
        grade.asyncLoadImage("http://pic.baike.soso.com/p/20100114/bki-20100114182657-1449988150.jpg")
    }
    
    private func addPrice() {
        price = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        price.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(56))
        price.textColor = UIColor.whiteColor()
        price.textAlignment = .Right
        addSubview(price)
        
        layout(grade, price) {grade, price in
            price.centerY == grade.centerY
            price.right == grade.left - AITools.displaySizeFrom1080DesignSize(10)
            price.height == AITools.displaySizeFrom1080DesignSize(56)
            price.width == 60
        }
        
        price.text = "$500"
    }
    
    private func addTitle() {
        name = UnderlineLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        name.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(56))
        name.textColor = UIColor(hex: "#FEE300")
        
        addSubview(name)
        
        layout(price, logo, name) {price, logo, name in
            name.top == logo.top
            name.left == logo.right + 5
            name.height == RightServiceView.LOGO_HEIGHT
            name.right == price.left - 30
        }
        
        name.text = "Mu576"
    }
    
    private func setFrameToHeadSize() {
        frame.size.height = RightServiceView.getHeadHeight()
    }
    
    static func getHeadHeight() -> CGFloat {
        return RightServiceView.PADDING_TOP + LOGO_HEIGHT + RightServiceView.TITLE_MAGIN_BOTTOM
    }
    
    private func addjustContentFrame() {
        let oldFrame = content!.frame
        content!.frame = CGRect(x: RightServiceView.PADDING_LEFT, y: logo.frame.origin.y + logo.frame.height + RightServiceView.TITLE_MAGIN_BOTTOM, width: frame.width - RightServiceView.PADDING_LEFT - RightServiceView.PADDING_RIGHT, height: oldFrame.height)
    }
    
    private func addjustSelfFrame() {
        frame.size.height = RightServiceView.getHeadHeight() + content!.frame.size.height
    }
}
