//
//  UIColorUtils.swift
//  AI2020OS
//
//  Created by tinkl on 1/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
/*!
*  @author tinkl, 15-04-01 17:04:07
*
*  extension of UIColor
*/
extension UIColor {
    /*!
    how to use it??
    
    var strokeColor = UIColor(rgba: "#ffcc00").CGColor // Solid color
    
    var fillColor = UIColor(rgba: "#ffcc00dd").CGColor // Color with alpha
    
    var backgroundColor = UIColor(rgba: "#FFF") // Supports shorthand 3 character representation
    
    var menuTextColor = UIColor(rgba: "#013E") // Supports shorthand 4 character representation (with alpha)
    
    
    :param: rgba #ffcc00
    
    :returns: UIColor object
    */
    convenience init(rgba: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let rgba = (rgba as NSString).substringFromIndex(1)
            let index   = rgba.startIndex//advance(rgba.startIndex, 1)
            let hex     = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {

                let counts = hex.length
                switch (counts) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
                }
            } else {
                //print("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    /*!
        处理导航栏黑线问题  透明投影问题
    */
    func clearImage() -> UIImage{
        
        let rect:CGRect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        
        CGContextSetFillColorWithColor(context, self.CGColor)
        CGContextFillRect(context, rect)
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }     
    
    // theme Color
    class func applicationMainColor() -> UIColor {
        return UIColor(rgba: AIApplication.AIColor.MainTextColor)
    }    
    
    func imageWithColor() -> UIImage {
        let rect:CGRect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        
        CGContextSetFillColorWithColor(context, self.CGColor)
        CGContextFillRect(context, rect)
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    ///通过渐变类型，颜色值返回渐变颜色 add by liux at 20160312
    static func colorWithGradientStyle(gradientStyle : UIGradientStyle, frame : CGRect , colors : [UIColor]) -> UIColor{
        
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.frame = frame
        let cgColors = NSMutableArray()
        for uiColor in colors{
            cgColors.addObject(uiColor.CGColor)
        }
        
        switch gradientStyle{
        case UIGradientStyle.UIGradientStyleLeftToRight:
            //Set out gradient's colors
            backgroundGradientLayer.colors = cgColors as [AnyObject]
            
            //Specify the direction our gradient will take
            backgroundGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            backgroundGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            
            //Convert our CALayer to a UIImage object
            UIGraphicsBeginImageContextWithOptions(backgroundGradientLayer.bounds.size, false, UIScreen.mainScreen().scale)
            backgroundGradientLayer.renderInContext(UIGraphicsGetCurrentContext()!)
            let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return UIColor(patternImage: backgroundColorImage)
            //TODO:还有两个实现没写完
        case UIGradientStyle.UIGradientStyleRadial:
            UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.mainScreen().scale)
            //Specific the spread of the gradient (For now this gradient only takes 2 locations)
            let locations : [CGFloat] = [0.0,1.0]
            
            //Default to the RGB Colorspace
            let myColorspace = CGColorSpaceCreateDeviceRGB()
            
            //Create our Gradient
            let myGradient = CGGradientCreateWithColors(myColorspace, cgColors, locations)
            
            // Normalise the 0-1 ranged inputs to the width of the image
            let myCentrePoint = CGPoint(x: frame.size.width / 2, y: frame
                .size.height / 2)
            let myRadius = min(frame.size.height, frame.size.width)
            CGContextDrawRadialGradient(UIGraphicsGetCurrentContext(), myGradient, myCentrePoint, 0, myCentrePoint, myRadius, CGGradientDrawingOptions.DrawsAfterEndLocation)
            // Grab it as an Image
            let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext()
            
            // Clean up
            UIGraphicsEndImageContext()
            
            return UIColor(patternImage: backgroundColorImage)
            
        case UIGradientStyle.UIGradientStyleTopToBottom:
            //Set out gradient's colors
            backgroundGradientLayer.colors = cgColors as [AnyObject]
            
            //Specify the direction our gradient will take
            backgroundGradientLayer.startPoint = CGPoint(x: 0, y: 0.2)
            backgroundGradientLayer.endPoint = CGPoint(x: 1, y: 1)
            
            //Convert our CALayer to a UIImage object
            UIGraphicsBeginImageContextWithOptions(backgroundGradientLayer.bounds.size, false, UIScreen.mainScreen().scale)
            backgroundGradientLayer.renderInContext(UIGraphicsGetCurrentContext()!)
            let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return UIColor(patternImage: backgroundColorImage)
        }
    }

}

enum UIGradientStyle : Int{
    case UIGradientStyleLeftToRight,UIGradientStyleRadial,UIGradientStyleTopToBottom
}