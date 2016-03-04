//
//  AIContentView.swift
//  AITrans
//
//  Created by admin on 7/1/15.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//

import Foundation
import Spring

class AIContentView: SpringView {

    @IBOutlet weak var Label_Content: UILabel!
    
    @IBOutlet weak var Image_Line: UIImageView!
    class func currentView()->AIContentView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AIContentView", owner: self, options: nil).first  as! AIContentView
        return selfView
    }
    
    /*
    override func drawRect(rect: CGRect) {
        
        let context:CGContextRef = UIGraphicsGetCurrentContext()
        
        CGContextBeginPath(context)
        
        CGContextSetLineWidth(context,0.5)//线宽度
        
        CGContextSetStrokeColorWithColor(context,UIColor.applicationMainColor().CGColor)
        
        let lengths:UnsafePointer<CGFloat> = {4,2}//先画4个点再画2个点
        
        CGContextSetLineDash(context, 0, lengths,2)
        
        CGContextMoveToPoint(context, 10.0, 20.0)
        
        CGContextAddLineToPoint(context, 310.0,20.0)
        
        CGContextStrokePath(context)
        
        CGContextClosePath(context)
    }
    
    */
}