//
//  TransportService.swift
//  AIVeris
//
//  Created by Rocky on 15/11/3.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class TransportService: UIView {
    
    private var time: UILabel!
    private var from: UILabel!
    private var to: UILabel!
    private var timeTitle: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelf()
    }
    
    private func initSelf() {
        addTime()
        addLocation()
    }
    
    private func addTime() {
        timeTitle = UILabel(frame: CGRect(x: 0, y: 10, width: 40, height: 15))
        timeTitle.text = "Time"
        addSubview(timeTitle)
        
        time = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
        addSubview(time)
        layout(timeTitle, time) {title, time in
            time.left == title.right + 5
            time.bottom == title.bottom
            time.right == time.superview!.right
        }
        
        time.text = "Oct.10th 10:30"
    }
    
    private func addLocation() {
        let fromIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        fromIcon.image = UIImage(named: "CardIndicator7.png")
        addSubview(fromIcon)
        
        let toIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        toIcon.image = UIImage(named: "CardIndicator6.png")
        addSubview(toIcon)
        
        from = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        to = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        addSubview(from)
        addSubview(to)
        
        layout(fromIcon, from, timeTitle) {fromIcon, from, timeTitle in
            fromIcon.left == timeTitle.left
            fromIcon.top == timeTitle.bottom + 10
            fromIcon.width == 20
            fromIcon.height == 20
            
            from.top == fromIcon.top
            from.left == fromIcon.right + 2
            from.right == from.superview!.right
            from.height == 20
        }
        
        layout(toIcon, to, fromIcon) {toIcon, to, fromIcon in
            toIcon.left == fromIcon.left
            toIcon.top == fromIcon.bottom + 10
            toIcon.width == fromIcon.width
            toIcon.height == fromIcon.height
            
            to.top == toIcon.top
            to.left == toIcon.right + 2
            to.right == to.superview!.right
            to.height == 20
        }
        
        from.text = "Pudong Airport T2"
        to.text = "Yanan Jingan District road 1218"
    }

}
