//
//  RotateView.swift
//  MyWholeDemos
//
//  Created by 刘先 on 16/3/8.
//  Copyright © 2016年 wantsor. All rights reserved.
//

import UIKit

class AIRotateView: UIView {
    
    var curServiceNameLabel : UILabel!
    var nextServiceNameLabel : UILabel!
    
    var models : [AssignServiceInstModel]?
    var curModelNum : Int!
    var nextModelNum : Int!
    var beginTime : CFTimeInterval!

    override init(frame: CGRect) {
        super.init(frame: frame)
        curModelNum = 0
        nextModelNum = 1
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - 构造view
    func buildContent(models : [AssignServiceInstModel]){
        self.models = models
        
        let curFrame = CGRect(x: 10, y: 20, width: 300, height: 50)
        curServiceNameLabel = UILabel(frame: curFrame)
        curServiceNameLabel.text = models[0].serviceName
        self.addSubview(curServiceNameLabel)
        
        let nextFrame = CGRect(x: 10, y: 40, width: 300, height: 50)
        nextServiceNameLabel = UILabel(frame: nextFrame)
        nextServiceNameLabel.layer.opacity = 0
        self.addSubview(nextServiceNameLabel)
        //多于1个选中服务实例，才启动滚动动画
        if models.count > 1{
            startAnimation()
        }
    }
    
    //MARK: - 轮播动画
    func startAnimation(){
        beginTime = CACurrentMediaTime() + 3
        makeCurLabelAnimation(curServiceNameLabel)
        makeNextLabelAnimation(nextServiceNameLabel)
    }
    
    func makeNextLabelAnimation(view : UIView){
        var degree : CGFloat = -45
        //旋转动画
        let rotateAnimation = CABasicAnimation(keyPath: "transform")
        var fromValue : CATransform3D = CATransform3DIdentity
        fromValue.m34 = 1.0 / -500
        fromValue = CATransform3DRotate(fromValue, degree, 1, 0, 0)
        
        var toValue : CATransform3D = CATransform3DIdentity
        toValue.m34 = 1.0 / -500
        degree += 45
        toValue = CATransform3DRotate(toValue, degree, 1, 0, 0)
        
        rotateAnimation.fromValue = NSValue.init(CATransform3D: fromValue)
        rotateAnimation.toValue = NSValue.init(CATransform3D: toValue)
        //设置透明度动画
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = NSNumber(float: 0.0)
        opacityAnimation.toValue = NSNumber(float: 1.0)
        
        //设置位移动画
        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.fromValue = NSValue.init(CGPoint: view.layer.position)
        var toPoint = view.layer.position
        toPoint.y -= 20
        positionAnimation.toValue = NSValue.init(CGPoint: toPoint)
        
        //设置动画组
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [rotateAnimation,opacityAnimation,positionAnimation]
        animationGroup.duration = 1
//        animationGroup.repeatCount = 1
        animationGroup.removedOnCompletion = false
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.beginTime = beginTime
        view.layer.addAnimation(animationGroup, forKey: nil)
    }
    
    func makeCurLabelAnimation(view : UIView) {
        var degree : CGFloat = 0

        //旋转动画
        let rotateAnimation = CABasicAnimation(keyPath: "transform")
        var fromValue : CATransform3D = CATransform3DIdentity
        fromValue.m34 = 1.0 / -500
        fromValue = CATransform3DRotate(fromValue, 0, 1, 0, 0)
        
        var toValue : CATransform3D = CATransform3DIdentity
        toValue.m34 = 1.0 / -500
        degree += 45
        toValue = CATransform3DRotate(toValue, degree, 1, 0, 0)
        
        rotateAnimation.fromValue = NSValue.init(CATransform3D: fromValue)
        rotateAnimation.toValue = NSValue.init(CATransform3D: toValue)
        //设置透明度动画
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = NSNumber(float: 1.0)
        opacityAnimation.toValue = NSNumber(float: 0.0)
        
        //设置位移动画
        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.fromValue = NSValue.init(CGPoint: view.layer.position)
        var toPoint = view.layer.position
        toPoint.y -= 20
        positionAnimation.toValue = NSValue.init(CGPoint: toPoint)
        
        //设置动画组
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [rotateAnimation,opacityAnimation,positionAnimation]
        animationGroup.duration = 1
//        animationGroup.repeatCount = 1
        animationGroup.removedOnCompletion = false
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.beginTime = beginTime
        animationGroup.delegate = self
        view.layer.addAnimation(animationGroup, forKey: nil)
    }
    
    override func animationDidStart(anim: CAAnimation) {
        nextServiceNameLabel.text = models![nextModelNum].serviceName
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if nextModelNum == (models?.count)! - 1{
            curModelNum = nextModelNum
            nextModelNum = 0
        }
        else if curModelNum == (models?.count)! - 1 {
            curModelNum = 0
            nextModelNum = 1
        }
        else{
            curModelNum = curModelNum + 1
            nextModelNum = nextModelNum + 1
        }
        curServiceNameLabel.text = models![curModelNum].serviceName
        startAnimation()
    }
}


