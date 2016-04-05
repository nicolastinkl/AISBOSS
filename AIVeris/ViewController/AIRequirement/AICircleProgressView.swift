//
//  CircleProgressView.swift
//  MyWholeDemos
//
//  Created by 刘先 on 16/3/10.
//  Copyright © 2016年 wantsor. All rights reserved.
//

import UIKit

class AICircleProgressView: UIView {
    
    var backLayer : CAShapeLayer!
    var fontLayer : CAShapeLayer!
    var strokWidth : CGFloat = 3.3
    var circlePadding : CGFloat = 1
    var isSelect : Bool = false
    var progress : CGFloat?
    var delegate : CircleProgressViewDelegate?
    
    let backLayerColor = UIColor(hex: "#0b038")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUp(){
        backLayer = CAShapeLayer()
        backLayer.fillColor = UIColor.clearColor().CGColor
        backLayer.frame = self.bounds
        backLayer.lineWidth = strokWidth
        backLayer.backgroundColor = UIColor.clearColor().CGColor
        
        fontLayer = CAShapeLayer()
        fontLayer.fillColor = UIColor.clearColor().CGColor
        fontLayer.frame = self.bounds
        fontLayer.lineWidth = strokWidth
        fontLayer.lineCap = kCALineCapRound
        fontLayer.lineJoin = kCALineJoinRound
        
        self.layer.addSublayer(backLayer)
        self.layer.addSublayer(fontLayer)
        
        setCircleLayer()
    }

    func setCircleLayer(){
        makeGradientColor()
        bindTapEvent()
        
        let frame = CGRect(x: -(strokWidth + circlePadding) / 2, y:-(strokWidth + circlePadding) / 2, width: self.bounds.width + strokWidth + circlePadding, height: self.bounds.height + strokWidth + circlePadding)
        let path = UIBezierPath(roundedRect: frame, cornerRadius: frame.width / 2)
        backLayer.path = path.CGPath
        backLayer.strokeColor = backLayerColor.CGColor
    }
    
    func refreshProgress(progress : CGFloat){
        self.progress = progress
        let centerPoint = CGPoint(x: self.bounds.size.width * 0.5, y: self.bounds.size.height * 0.5)
        let radius = (CGRectGetWidth(self.bounds) + strokWidth + circlePadding) / 2
        let endAngle = CGFloat(2*M_PI)*progress - CGFloat(M_PI_2)
        let path = UIBezierPath(arcCenter: centerPoint , radius: radius, startAngle: CGFloat(-M_PI_2), endAngle: endAngle, clockwise: true)
        fontLayer.path = path.CGPath
        //fontLayer.strokeEnd = 0
        startAnimation()
    }
    
//    func generationGradientLayer(){
//        let gradientLayer = CALayer()
//        
//        //Color 1:
//        let color1 = CAGradientLayer()
//        color1.frame = CGRectMake(0, 0, self.width, self.height/2)
//        color1.colors = [UIColor(hex: "2477e8").CGColor]
//        color1.locations = [0.5,0.9,1]
//        color1.startPoint = CGPointMake(0.5, 1)
//        color1.endPoint = CGPointMake(0.5, 0)
//        
//        //Color 2:        
//        let color2 = CAGradientLayer()
//        color2.frame = CGRectMake(0, self.height/2, self.width, self.height/2)
//        color2.colors = [UIColor(hex: "e30ab2").CGColor]
//        color2.locations = [0.1,0.5,1]
//        color2.startPoint = CGPointMake(0.5, 1)
//        color2.endPoint = CGPointMake(0.5, 0)
//        
//        gradientLayer.addSublayer(color1)
//        gradientLayer.addSublayer(color2)
//        self.layer.addSublayer(gradientLayer)
//    }
    
    func startAnimation(){
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = NSNumber(float: 0)
        animation.toValue = NSNumber(float: 1)
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = true
        animation.duration = 0.5 + Double((self.progress ?? 0) / 10) //Default Value: 0.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        fontLayer.addAnimation(animation, forKey: nil)
    }
    
    func makeGradientColor(){

        let frame = CGRect(x: -(strokWidth + circlePadding) / 2 , y:-(strokWidth + circlePadding) / 2, width: self.bounds.width + strokWidth + circlePadding, height: self.bounds.height + strokWidth + circlePadding + 10)

        fontLayer.strokeColor = UIColor.colorWithGradientStyle(UIGradientStyle.UIGradientStyleTopToBottom, frame: frame, colors: [UIColor(hex: "2477e8"),UIColor(hex: "e30ab2"),UIColor(hex: "7B40D3"),UIColor(hex: "2477e8")]).CGColor
        fontLayer.setNeedsDisplay()

    }
    //设置选中还是未选中状态
    func changeSelect(isSelect : Bool){
        self.isSelect = isSelect
        //因为半径已经变了，所以frame不再从0开始
        let frame = CGRect(x: -(strokWidth + circlePadding) / 2, y:-(strokWidth + circlePadding) / 2, width: self.bounds.width + strokWidth + circlePadding, height: self.bounds.height + strokWidth + circlePadding)
        let path = UIBezierPath(roundedRect: frame, cornerRadius: frame.width / 2)
        if isSelect {
            
            //改变颜色时不需要动画，用这个禁用
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            fontLayer.path = path.CGPath
            fontLayer.strokeColor = UIColor(hex: "0f86e8").CGColor
            CATransaction.commit()
            
        }
        else {
            let progressCurrent = progress ?? 0
            if progressCurrent > 0 {
                
                makeGradientColor()
                refreshProgress(progressCurrent)
            }
            else{
                //改变颜色时不需要动画，用这个禁用
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                fontLayer.path = path.CGPath
                fontLayer.strokeColor = UIColor.clearColor().CGColor
                CATransaction.commit()
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
