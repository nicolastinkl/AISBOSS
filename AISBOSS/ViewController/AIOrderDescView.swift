//
//  AIOrderDescView.swift
//  NestedTableViewDemo
//
//  Created by 刘先 on 15/10/21.
//  Copyright © 2015年 wantsor. All rights reserved.
//

import Foundation
import UIKit

//收起订单的展现方式枚举，
enum DESC_SERVICE_TYPE : Int{
    case DEFAULT  //
    case PLANE_TRAVEL=1
}

class AIOrderDescView: UIView {
    
    let TIME_TEXT = "Time"
    let NEW_TIME_TEXT = "New Time"
    let TEXT_HEIGHT : CGFloat = 21
    let TEXT_PADDING : CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func buildView(){
        let timeValueText = "02-19 9:10"
        let timeTextSize = caculateContentSize(timeValueText, fontSize: 18)
        let timeSize = caculateContentSize(TIME_TEXT, fontSize: 13)
        let timeValueLabelFrame = CGRectMake(self.bounds.width - timeTextSize.size.width, 0, timeTextSize.size.width + 2, TEXT_HEIGHT)
        let timeLabelFrame = CGRectMake(timeValueLabelFrame.origin.x - TEXT_PADDING - timeSize.size.width + 2, 0, timeSize.size.width, TEXT_HEIGHT)
        let descLabelFrame = CGRectMake(0, 0, timeLabelFrame.origin.x - TEXT_PADDING, 21)
        
        let descLabel = UILabel(frame: descLabelFrame)
        descLabel.text = "Delivery staff:Mike Liu"
        descLabel.textColor = UIColor.whiteColor()
        descLabel.font = UIFont.systemFontOfSize(14)
        let timeLabel = UILabel(frame: timeLabelFrame)
        timeLabel.text = TIME_TEXT
        timeLabel.alpha = 0.4
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.font = UIFont.systemFontOfSize(13)
        let timeValueLabel = UILabel(frame: timeValueLabelFrame)
        timeValueLabel.font = UIFont.systemFontOfSize(18)
        timeValueLabel.text = timeValueText
        timeValueLabel.textColor = UIColor.whiteColor()
        
        self.addSubview(descLabel)
        self.addSubview(timeLabel)
        self.addSubview(timeValueLabel)
    }
    
    
    // MARK : - utils
    func caculateContentSize(content:String,fontSize:CGFloat) -> CGRect{
        let size = CGSizeMake(150,100)
        let s:NSString = "\(content)"
        let contentSize = s.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin , attributes: [NSFontAttributeName:UIFont.systemFontOfSize(fontSize)], context: nil)
        return contentSize
    }
    
}