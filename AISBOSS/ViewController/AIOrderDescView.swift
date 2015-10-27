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
    
    var descLabel: UILabel!
    
    let TIME_TEXT = "Time"
    let NEW_TIME_TEXT = "New Time"
    let TEXT_HEIGHT : CGFloat = 21
    let TEXT_PADDING : CGFloat = 5
    let VIEW_PADDING : CGFloat = 13
    let SATE_LABEL_WIDTH : CGFloat = 26
    let PARAM_KEY_OTHER : String = "20151026"
    let PARAM_KEY_DESC : String = "25042643"
    
    var paramDictionary : NSDictionary?
    var descText : String!
    var timeValueText = ""
    var timeLabelText = ""
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //load data
    func loadData(serviceOrderModel : ServiceOrderModel){
        if let paramModelArray = serviceOrderModel.param_list as? [ParamModel]{
            for paramModel : ParamModel in paramModelArray{
                if paramModel.param_key == PARAM_KEY_OTHER {
                     let jsonData = paramModel.param_value.dataUsingEncoding(NSUTF8StringEncoding)
                     paramDictionary = try? NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                }
                else if paramModel.param_key == PARAM_KEY_DESC{
                    descText = paramModel.param_value
                }
            }
        }
        
        buildView()
    }
    
    func buildView(){
        if let valueForGate = paramDictionary?.valueForKey("GATE") as? String{
            if valueForGate != ""{
                buildPlaneView()
            }
            else{
                buildDefaultView()
            }
        }
    }
    
    //默认的文字描述＋时间的布局
    func buildDefaultView(){
        var timeSize : CGRect!
        
        if let valueForTime = paramDictionary?.valueForKey("Time") as? String{
            if valueForTime != ""{
                timeValueText = valueForTime
                timeLabelText = TIME_TEXT
                timeSize = caculateContentSize(TIME_TEXT, fontSize: 13)
            }
        }
        if let valueForNewTime = paramDictionary?.valueForKey("New_Time") as? String{
            if valueForNewTime != ""{
                timeValueText = valueForNewTime
                timeLabelText = NEW_TIME_TEXT
                timeSize = caculateContentSize(NEW_TIME_TEXT, fontSize: 13)
            }
        }
        if let valueForArrive = paramDictionary?.valueForKey("Arrive") as? String{
            if valueForArrive != ""{
                timeValueText = valueForArrive
                timeLabelText = ""
                timeSize = CGRectMake(0, 0, 0, 0)
            }
        }


        let timeTextSize = caculateContentSize(timeValueText, font: AITools.myriadLightSemiCondensedWithSize(18))
        let timeValueLabelFrame = CGRectMake(self.bounds.width - timeTextSize.size.width - VIEW_PADDING, 0, timeTextSize.size.width, TEXT_HEIGHT)
        let timeLabelFrame = CGRectMake(timeValueLabelFrame.origin.x - TEXT_PADDING - timeSize.size.width + 2, 0, timeSize.size.width, TEXT_HEIGHT)
        let descLabelFrame = CGRectMake(0, 0, timeLabelFrame.origin.x - TEXT_PADDING, 21)
        
        descLabel = UILabel(frame: descLabelFrame)
        descLabel.text = descText ?? "Delivery staff:Mike Liu"
        descLabel.textColor = UIColor.whiteColor()
        descLabel.font = PurchasedViewFont.SERVICE_TITLE
        let timeLabel = UILabel(frame: timeLabelFrame)
        timeLabel.text = timeLabelText
        timeLabel.textColor = PurchasedViewColor.TITLE
        timeLabel.font = AITools.myriadLightSemiCondensedWithSize(13)
        timeLabel.alpha = 0.4

        let timeValueLabel = UILabel(frame: timeValueLabelFrame)
        timeValueLabel.font = AITools.myriadLightSemiCondensedWithSize(18)

        timeValueLabel.text = timeValueText
        timeValueLabel.textColor = UIColor.whiteColor()
        
        self.addSubview(descLabel)
        self.addSubview(timeLabel)
        self.addSubview(timeValueLabel)
    }
    
    //机票登机描述的布局
    func buildPlaneView(){
        var gateText = ""
        var sateText = ""
        if let valueForGate = paramDictionary?.valueForKey("GATE") as? String{
            if valueForGate != ""{
                gateText = valueForGate
            }
        }
        if let valueForSate = paramDictionary?.valueForKey("SATE") as? String{
            if valueForSate != ""{
                sateText = valueForSate
            }
        }
        
        let gateValueSize = caculateContentSize(gateText, fontSize: 18)
        let sateValueSize = caculateContentSize(sateText, fontSize: 18)
        let sateValueLabelFrame = CGRectMake(self.bounds.width - sateValueSize.size.width - VIEW_PADDING, 0, sateValueSize.width, TEXT_HEIGHT)
        let sateLabelFrame = CGRectMake(sateValueLabelFrame.origin.x - SATE_LABEL_WIDTH - TEXT_PADDING, 0, SATE_LABEL_WIDTH, TEXT_HEIGHT)
        let gateValueLabelFrame = CGRectMake(sateLabelFrame.origin.x - TEXT_PADDING - gateValueSize.width, 0, gateValueSize.width, TEXT_HEIGHT)
        let gateLabelFrame = CGRectMake(gateValueLabelFrame.origin.x - TEXT_PADDING - SATE_LABEL_WIDTH, 0, SATE_LABEL_WIDTH, TEXT_HEIGHT)
        let descLabelFrame = CGRectMake(0, 0, gateLabelFrame.origin.x - TEXT_PADDING, 21)
        //build sub view
        descLabel = UILabel(frame: descLabelFrame)
        descLabel.text = descText ?? "Delivery staff:Mike Liu"
        descLabel.textColor = UIColor.whiteColor()
        descLabel.font = PurchasedViewFont.SERVICE_TITLE
        
        let sateValueLabel = UILabel(frame: sateValueLabelFrame)
        sateValueLabel.text = sateText
        sateValueLabel.textColor = PurchasedViewColor.TITLE
        sateValueLabel.font = AITools.myriadLightSemiCondensedWithSize(18)
        
        let sateLabel = UILabel(frame: sateLabelFrame)
        sateLabel.textColor = PurchasedViewColor.TITLE
        sateLabel.font = AITools.myriadLightSemiCondensedWithSize(13)
        sateLabel.text = "SATE"
        sateLabel.alpha = 0.4
        
        let gateValueLabel = UILabel(frame: gateValueLabelFrame)
        gateValueLabel.text = gateText
        gateValueLabel.textColor = PurchasedViewColor.TITLE
        gateValueLabel.font = AITools.myriadLightSemiCondensedWithSize(18)
        
        let gateLabel = UILabel(frame: gateLabelFrame)
        gateLabel.textColor = PurchasedViewColor.TITLE
        gateLabel.font = AITools.myriadLightSemiCondensedWithSize(13)
        gateLabel.text = "GATE"
        gateLabel.alpha = 0.4

        self.addSubview(descLabel)
        self.addSubview(sateValueLabel)
        self.addSubview(sateLabel)
        self.addSubview(gateValueLabel)
        self.addSubview(gateLabel)
    }
    
    
    // MARK : - utils
    func caculateContentSize(content:String,fontSize:CGFloat) -> CGRect{
        let size = CGSizeMake(150,100)
        let s:NSString = "\(content)"
        let contentSize = s.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin , attributes: [NSFontAttributeName:UIFont.systemFontOfSize(fontSize)], context: nil)
        return contentSize
    }
    
    func caculateContentSize(content:String,font:UIFont) -> CGRect{
        let size = CGSizeMake(150,100)
        let s:NSString = "\(content)"
        let contentSize = s.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin , attributes: [NSFontAttributeName:font], context: nil)
        return contentSize
    }
    
    
    
}