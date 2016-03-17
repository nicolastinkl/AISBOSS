//
//  CircleProgressView.swift
//  MyWholeDemos
//
//  Created by 刘先 on 16/3/10.
//  Copyright © 2016年 wantsor. All rights reserved.
//

import UIKit

class AICircleProgressView: UIView {
    
    var fontLayer : CAShapeLayer!
    var strokWidth : CGFloat = 2
    var isSelect : Bool = false
    var progress : CGFloat?
    var delegate : CircleProgressViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUp(){
        
        fontLayer = CAShapeLayer()
        fontLayer.fillColor = nil
        fontLayer.frame = self.bounds
        self.layer.addSublayer(fontLayer)
        setCircleLayer()
    }

    func setCircleLayer(){
        makeGradientColor()
        fontLayer.lineWidth = strokWidth
        bindTapEvent()
    }
    
    func refreshProgress(progress : CGFloat){
        self.progress = progress
        let centerPoint = CGPoint(x: self.bounds.size.width * 0.5, y: self.bounds.size.height * 0.5)
        let radius = (CGRectGetWidth(self.bounds) + strokWidth + 5) / 2
        let endAngle = CGFloat(2*M_PI)*progress - CGFloat(M_PI_2)
        let path = UIBezierPath(arcCenter: centerPoint , radius: radius, startAngle: CGFloat(-M_PI_2), endAngle: endAngle, clockwise: true)
        fontLayer.path = path.CGPath
        //fontLayer.strokeEnd = 0
        startAnimation()
    }
    
    func startAnimation(){
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = NSNumber(float: 0)
        animation.toValue = NSNumber(float: 1)
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = true
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        fontLayer.addAnimation(animation, forKey: nil)
    }
    
    func makeGradientColor(){
        //fontLayer.strokeColor = UIColor.greenColor().CGColor
        let frame = CGRect(x: -(strokWidth + 5) / 2, y:-(strokWidth + 5) / 2, width: self.bounds.width + strokWidth + 5, height: self.bounds.height + strokWidth + 5)
        fontLayer.strokeColor = UIColor.colorWithGradientStyle(UIGradientStyle.UIGradientStyleLeftToRight, frame: frame, colors: [UIColor.whiteColor(),UIColor.redColor()]).CGColor
    }
    //设置选中还是未选中状态
    func changeSelect(isSelect : Bool){
        self.isSelect = isSelect
        
        if isSelect {
            //因为半径已经变了，所以frame不再从0开始
            let frame = CGRect(x: -(strokWidth + 5) / 2, y:-(strokWidth + 5) / 2, width: self.bounds.width + strokWidth + 5, height: self.bounds.height + strokWidth + 5)
            let path = UIBezierPath(roundedRect: frame, cornerRadius: frame.width / 2)
            fontLayer.path = path.CGPath
            fontLayer.strokeColor = UIColor.blueColor().CGColor
        }
        else {
            if let progress = progress{
                refreshProgress(progress)
                makeGradientColor()
            }
            else{
                fontLayer.path = nil
            }
        }
    }
    
    func bindTapEvent(){
        let tapGuesture = UITapGestureRecognizer(target: self, action: "selectAction:")
        self.addGestureRecognizer(tapGuesture)
    }
    
    func selectAction(sender : UIGestureRecognizer){
        isSelect = !isSelect
        //触发delegate
        if let delegate = delegate{
            delegate.viewDidSelect(self)
        }
        changeSelect(isSelect)
        
    }
}

//MARK: - delegate，处理选中事件
@objc
protocol CircleProgressViewDelegate {
    
    func viewDidSelect(circleView : AICircleProgressView)
}
