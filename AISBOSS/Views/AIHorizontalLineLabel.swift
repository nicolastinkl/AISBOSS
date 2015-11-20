//
//  AIHorizontalLineLabel.swift
//  AIVeris
//
//  Created by admin on 15/11/20.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIHorizontalLineLabel: UILabel {

    private var textRect: CGRect!
    var linePosition = AIHorizontalLinePosition.Bottom
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(rect)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        CGContextSetStrokeColorWithColor(ctx, textColor.CGColor);
        CGContextSetLineWidth(ctx, 1);
        
        var offsetX: CGFloat = 0
        
        switch textAlignment {
        case .Right:
            offsetX = rect.width - textRect.width
        case .Center:
            offsetX = (rect.width - textRect.width) / 2
        default:
            offsetX = 0
        }
        
        
        var offsetY: CGFloat = 0
        
        switch linePosition {
        case .Bottom:
            offsetY = rect.height
        case .Middle:
            offsetY = rect.height / 2
        default:
            offsetY = 0
        }
        
        let PADDING: CGFloat = 1

        let leftPoint = CGPointMake(rect.origin.x + offsetX - PADDING, rect.origin.y + offsetY)
        let rightPoint = CGPointMake(rect.origin.x + offsetX + textRect.width + PADDING, rect.origin.y + offsetY);
        
        CGContextMoveToPoint(ctx, leftPoint.x, leftPoint.y);
        CGContextAddLineToPoint(ctx, rightPoint.x, rightPoint.y);
        CGContextStrokePath(ctx);
    }
    
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        textRect = super.textRectForBounds(bounds, limitedToNumberOfLines: numberOfLines)
        return textRect
    }
    
}

public enum AIHorizontalLinePosition : Int {
    case Bottom
    case Middle
    case Top
}
