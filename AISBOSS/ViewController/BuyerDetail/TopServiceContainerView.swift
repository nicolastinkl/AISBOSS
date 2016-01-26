//
//  TopServiceContainerView.swift
//  AIVeris
//
//  Created by Rocky on 15/11/7.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class TopServiceContainerView: ServiceContainerView {
    
    var isSingle: Bool = false {
        willSet(newVaklue) {
            bottomBall.hidden = newVaklue
        }
    }
    
    override func isPrimeService(isPrime: Bool) {
        super.isPrimeService(isPrime)
        if isPrime {
            
            topBall.image = UIImage(named: "white_ball")
            background.image = UIImage(named: "white_top_unfilled_corner")
            topBallHeightConstraint.constant = 20
            
        } else {
            topBall.image = UIImage(named: "hollow_ball")
            background.image = UIImage(named: "white_corner_bk")  
            topBallHeightConstraint.constant = 16
        }
        
        topBall.setNeedsUpdateConstraints()
    }
}
