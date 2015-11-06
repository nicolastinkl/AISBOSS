//
//  BottomServiceViewContainer.swift
//  AIVeris
//
//  Created by Ricky on 15/11/6.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class BottomServiceViewContainer: ServiceViewContainer {

    override func buildSubviews() {
        leftIndicator = BottomLeftIndicator(frame: CGRect(x: 0, y: 0, width: ServiceViewContainer.INDICATOR_WIDTH, height: 0))
        rightServiceView = MiddleRightServiceView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        addSubview(leftIndicator)
        addSubview(rightServiceView)
    }
    
//    override func layoutView() {
//        layout(leftIndicator, leftIndicator.topBall, rightServiceView) {indicator, topBall, service in
//            
//            indicator.top == indicator.superview!.top
//            indicator.left == indicator.superview!.left
//            indicator.height == indicator.superview!.height
//            indicator.width == ServiceViewContainer.INDICATOR_WIDTH
//            
//            service.top == topBall.top + 5
//            service.left == indicator.right - ServiceViewContainer.INDICATOR_WIDTH / 2 + 5
//            service.right == service.superview!.right
//            service.bottom == service.superview!.bottom
//        }
//    
//        frame.size.height = RightServiceView.getHeadHeight() + ServiceViewContainer.INDICATOR_WIDTH
//    }

}

class BottomLeftIndicator: LeftIndicator {
    
    override func buildSbuViews() {
        super.buildSbuViews()
        bottomBall.hidden = true
    }
    
//    override func layoutView() {
//        
//        group = constrain(topBall) {topBall in
//            topBall.top == topBall.superview!.top
//            topBall.centerX == topBall.superview!.centerX
//            topBall.width == LeftIndicator.BIG_BALL_WIDTH
//            topBall.height == topBall.width
//        }
//    
//    }
}
