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
    
    // MARK: -> Internal class methods
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: -> Internal init methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            for value in 1...centNumber {
                
                pointArray.append(CGPointMake(centerPoint.x -  CGFloat(value) * kPointOffset, centerPoint.y + (newValue - atan(CGFloat(newValue - CGFloat(value)))) * kPointDamping ))
                
                pointArray.append(CGPointMake(centerPoint.x +  CGFloat(value) * kPointOffset, centerPoint.y + (newValue - atan(CGFloat(newValue - CGFloat(value-1)))) * kPointDamping ))
                
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
