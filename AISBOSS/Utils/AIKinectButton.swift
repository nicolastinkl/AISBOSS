//
//  AIKinectButton.swift
//  AI2020OS
//
//  Created by tinkl on 9/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

/*!
*  @author tinkl, 15-04-09 14:04:48
*
*  点击放大处理
*/
class AIKinectButton:UIButton {
    var baseView: UIView!
    override var highlighted: Bool {
        didSet {
            let transform: CGAffineTransform = highlighted ?
                CGAffineTransformMakeScale(1.1, 1.1) : CGAffineTransformIdentity
            UIView.animateWithDuration(0.05, delay: 0, options: .BeginFromCurrentState, animations: { () -> Void in
                self.transform = transform
                }, completion: nil)
        }
    }
    
   required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2;
    }
    
    private func configure() {
        self.baseView = UIView(frame: self.bounds)
        self.layer.cornerRadius = CGRectGetWidth(self.bounds)
        self.baseView.addSubview(self)
//        self.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
}