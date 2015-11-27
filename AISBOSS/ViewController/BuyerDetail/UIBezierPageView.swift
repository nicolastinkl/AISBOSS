//
//  UIBezierPageView.swift
//  AIVeris
//
//  Created by tinkl on 17/11/2015.
//  Base on Tof Templates
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

// MARK: -
// MARK: UIBezierPageView
// MARK: -
internal class UIBezierPageView : UIView {
    // MARK: -
    // MARK: Internal access (aka public for current module)
    // MARK: -
    
    // MARK: -> Internal properties
    let kAngleOffset:CGFloat = CGFloat(M_PI_4)/6.3 //5.2 //CGFloat(M_PI_2) / 4.5
    let kSphereLength:CGFloat = 118  //半径7
    let kSphereDamping:Float = 0.7
    let kSphereFixPosition:CGFloat = 0
    
    var modelList:[AIProposalServiceModel]?
    // MARK: -> Internal class methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: -> Internal init methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func refershModelView(model: [AIProposalServiceModel]){
        //let number = model.count
        let holdNumber = 8
        let array = centerForCalculatePosition(holdNumber)
        var index:Int = 0
        for point in array {
            let position = point
            let imageView = UIImageView(frame: CGRectMake(position.x-10, position.y, 22/2.5, 22/2.5))
            if index < model.count {
                let mod = model[index]
                if mod.is_main_flag == 0 {
                    imageView.image = UIImage(named: "selectSettings")
                }else{
                    imageView.image = UIImage(named: "selectwhiteSettings")
                }
            }else{
                imageView.image = UIImage(named: "selectSettings")//UIColor.clearColor().imageWithColor()
            }
            imageView.tag = index
            self.addSubview(imageView)
            index = index + 1
        }
        
        if model.count < holdNumber {
            //筛选出最顶部的view
            let newSubview = self.subviews.sort({$0.top > $1.top})
            //移除剩余的view
            let count = holdNumber - model.count - 1
            
            for i in 0...count {
                newSubview[i].removeFromSuperview()
            }
        }
        
       /** if model.count < holdNumber {
            let count = holdNumber - model.count
            if (count > 0) && (count%2 == 0) {
                //偶数
                let c = count/2
                for _ in 0...c {
                    self.subviews.first?.removeFromSuperview()
                    self.subviews.last?.removeFromSuperview()
                }
            }else{
                //基数
                
                let c = count/2
                for _ in 0...c {
                    self.subviews.first?.removeFromSuperview()
                }
            }
        }*/
        
    }
    
    func refershView(number: Int = 0){
        
        let array = centerForCalculatePosition(number)
        for point in array {
            let position = point
            let imageView = UIImageView(frame: CGRectMake(position.x-10, position.y, 22/2.5, 22/2.5))
            imageView.image = UIImage(named: "selectWhite")
            self.addSubview(imageView)
        }
        
        /**
        for i in 0...number {
        let position = centerForIconAtIndex(i)
        let imageView = UIImageView(frame: CGRectMake(position.x, position.y, 12/2.5, 12/2.5))
        imageView.image = UIImage(named: "card_select")
        self.addSubview(imageView)
        }
        */
        
    }
    
    let kPointDamping:CGFloat = 10.7
    let kPointOffset:CGFloat = 15
    
    func centerForCalculatePosition(number: Int) -> [CGPoint]{
        if number < 1 {
            return [CGPointMake(0, 0)]
        }
        var pointArray:[CGPoint] = []
        if number % 2 == 0 {
            //偶数
            let centerPoint = CGPointMake(CGRectGetWidth(self.frame)/2, 0)
            let centNumber = number/2
            let newValue = CGFloat(number/2)
            for value in 1...centNumber {
                //一半循环
                if value < centNumber{
                    pointArray.append(CGPointMake(centerPoint.x -  CGFloat(value) * kPointOffset, centerPoint.y + (newValue - atan(CGFloat(newValue - CGFloat(value)))) * kPointDamping ))
                }
                
                pointArray.append(CGPointMake(centerPoint.x +  CGFloat(value) * kPointOffset, centerPoint.y + (newValue - atan(CGFloat(newValue - CGFloat(value-1)))) * kPointDamping ))
                
            }
            let value = 0
            pointArray.append(CGPointMake(centerPoint.x +  CGFloat(value) * kPointOffset, centerPoint.y + (newValue - atan(CGFloat(newValue - CGFloat(value-1)))) * kPointDamping ))
            
        }else{
            //奇数
            let centerPoint = CGPointMake(CGRectGetWidth(self.frame)/2, 0)
            let centNumber = number/2
            let newValue = CGFloat(number/2)
            if centNumber >= 1 {
                for value in 1...centNumber {
                    
                    pointArray.append(CGPointMake(centerPoint.x -  CGFloat(value) * kPointOffset, centerPoint.y + (newValue - atan(CGFloat(newValue - CGFloat(value)))) * kPointDamping ))
                    
                    pointArray.append(CGPointMake(centerPoint.x +  CGFloat(value) * kPointOffset, centerPoint.y + (newValue - atan(CGFloat(newValue - CGFloat(value-1)))) * kPointDamping ))
                    
                }
            }
            
            let value = 0
            pointArray.append(CGPointMake(centerPoint.x +  CGFloat(value) * kPointOffset, centerPoint.y + (newValue - atan(CGFloat(newValue - CGFloat(value-1)))) * kPointDamping ))
        }
        
        return pointArray
    }
    
    // MARK: -> Internal methods
    // 图标 弧形排列
    func centerForIconAtIndex(index:Int) -> CGPoint{
        let firstAngle:CGFloat = CGFloat(M_PI_4)*5.4  +  (CGFloat(M_PI_4) - kAngleOffset) - CGFloat(index) * kAngleOffset
        //print(firstAngle)
        let startPoint = self.center
        let x = startPoint.x + cos(firstAngle) * kSphereLength - kSphereFixPosition;
        let y = startPoint.y + sin(firstAngle) * kSphereLength - kSphereFixPosition;
        let position = CGPointMake(x, y);
        return position;
    }
    
    
    
}
