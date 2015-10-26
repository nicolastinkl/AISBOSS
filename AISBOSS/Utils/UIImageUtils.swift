//
//  UIImageUtils.swift
//  AIVeris
//
//  Created by tinkl on 26/10/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

extension UIImage{
    
    /**
    根据图片主色调 加深颜色处理图片边框颜色
    */
    func pickImageDeepColor() -> UIColor! {
        
        let selfColor = self.pickUpImageColor()
        let cs = CGColorGetComponents(selfColor.CGColor)
        let red = CGFloat(cs[0])
        let green = CGFloat(cs[1])
        let blue = CGFloat(cs[2])
        return UIColor(red: red+0.1, green: green, blue: blue, alpha: 1)
        
    }
    
    /**
    根据图片主色调 展示闪光效果
    */
    func pickImageEffectColor() -> UIColor! {
        
        let selfColor = self.pickUpImageColor()
        
        return selfColor.colorWithAlphaComponent(0.5)
    }
    
    /**
    根据图片主色调 返回图片背景图
    */
    func getBgImageFromImage() -> UIImage! {

        let selfColor = self.pickUpImageColor()

        return selfColor.imageWithColor()
    }
}