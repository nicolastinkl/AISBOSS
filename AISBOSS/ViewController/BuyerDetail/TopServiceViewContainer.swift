//
//  TopServiceViewContainer.swift
//  AIVeris
//
//  Created by Rocky on 15/11/6.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class TopServiceViewContainer: ServiceViewContainer {

    override func buildSubviews() {
        leftIndicator = TopLeftIndicator(frame: CGRect(x: 0, y: 0, width: ServiceViewContainer.INDICATOR_WIDTH, height: 0))
        rightServiceView = RightServiceView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        addSubview(leftIndicator)
        addSubview(rightServiceView)
    }
    
    override func layoutView() {
        layout(leftIndicator, leftIndicator.topBall, rightServiceView) {indicator, topBall, service in
            
            indicator.top == indicator.superview!.top
            indicator.left == indicator.superview!.left
            indicator.height == indicator.superview!.height
            indicator.width == ServiceViewContainer.INDICATOR_WIDTH
            
            service.top == topBall.top + 12
            service.left == indicator.right - ServiceViewContainer.INDICATOR_WIDTH / 2 + 5
            service.right == service.superview!.right
        }
        
        layout(leftIndicator.bottomBall, rightServiceView) {bottomBall, service in
            service.bottom == bottomBall.centerY - 2
        }
        
        frame.size.height = RightServiceView.getHeadHeight() + ServiceViewContainer.INDICATOR_WIDTH
    }
}

class TopLeftIndicator: LeftIndicator {
    
    override func layoutView() {
        topBall.image = UIImage(named: "white_ball")
        
        group = constrain(topBall) {topBall in
            topBall.top == topBall.superview!.top
            topBall.centerX == topBall.superview!.centerX
            topBall.width == LeftIndicator.BIG_BALL_WIDTH
            topBall.height == topBall.width
        }
        
        constrain(topBall, bottomBall) {topBall, bottomBall in

            
            bottomBall.bottom == bottomBall.superview!.bottom
            bottomBall.centerX == topBall.centerX
            bottomBall.width == LeftIndicator.SMALL_BALL_WIDTH
            bottomBall.height == bottomBall.width / 2
        }
    }
}
