//
//  UIBezierPageView.swift
//  AIVeris
//
//  Created by tinkl on 17/11/2015.
//  Base on Tof Templates
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

// MARK: -
// MARK: UIBezierPageView
// MARK: -
internal class UIBezierPageView : UIView {
  // MARK: -
  // MARK: Internal access (aka public for current module)
  // MARK: -
    
    // MARK: -> Internal properties
    let kAngleOffset:CGFloat = CGFloat(M_PI_2)/5.6 //5.2 //CGFloat(M_PI_2) / 4.5
    let kSphereLength:CGFloat = 61
    let kSphereDamping:Float = 0.7
    let kSphereFixPosition:CGFloat = 7
    
    // MARK: -> Internal class methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    // MARK: -> Internal init methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refershView(number: Int = 0){
        
        for i in 0...number {
            let position = centerForIconAtIndex(i)
            let imageView = UIImageView(frame: CGRectMake(position.x, position.y, 15/2.5, 15/2.5))
            imageView.image = UIImage(named: "card_select")
            self.addSubview(imageView)
        }
    }

    // MARK: -> Internal methods
    // 图标 弧形排列
    func centerForIconAtIndex(index:Int) -> CGPoint{
        let firstAngle:CGFloat = CGFloat(M_PI)*0.48 + (CGFloat(M_PI_2) - kAngleOffset) - CGFloat(index) * kAngleOffset
        //print(firstAngle)
        let startPoint = self.center
        let x = startPoint.x + cos(firstAngle) * kSphereLength - kSphereFixPosition;
        let y = startPoint.y + sin(firstAngle) * kSphereLength - kSphereFixPosition + 2;
        let position = CGPointMake(x, y);
        return position;
    }
    
    
  
  // MARK: -> Internal class override <#class name#>
  
  // MARK: -> Internal protocol <#protocol name#>
  
  // MARK: -
  // MARK: Private access
  // MARK: -
  
  // MARK: -> Private enums
  
  // MARK: -> Private structs
  
  // MARK: -> Private class
  
  // MARK: -> Private type alias 

  // MARK: -> Private static properties

  // MARK: -> Private properties
  
  // MARK: -> Private class methods
  
  // MARK: -> Private init methods
  
  // MARK: -> Private methods

}
