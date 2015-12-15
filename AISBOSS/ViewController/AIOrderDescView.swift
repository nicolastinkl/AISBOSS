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
    
    let TIME_TEXT = "AIOrderDescView.time".localized
    let NEW_TIME_TEXT = "AIOrderDescView.newTime".localized
    let TEXT_HEIGHT : CGFloat = 21
    let TEXT_PADDING : CGFloat = 5
    let VIEW_PADDING : CGFloat = 1
    var SATE_LABEL_WIDTH : CGFloat = 26
    let PARAM_KEY_OTHER : String = "20151026"
    let PARAM_KEY_DESC : String = "25042643"
    
    let DESC_TEXT_FONT = PurchasedViewFont.SERVICE_TITLE
    let LABEL_TITLE_FONT = PurchasedViewFont.SERVICE_STATU
    let TIME_VALUE_FONT = PurchasedViewFont.ORDER_TIME_VALUE
    let ALERT_LABEL_FONT = PurchasedViewFont.ORDER_ALERT_LABEL
    
    var paramDictionary : NSDictionary?
    var descText : String!
    var timeValueText = ""
    var timeLabelText = ""
    var isDelayed = false
    
    
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
        //判断延误标志
        if serviceOrderModel.order_state == "Delayed"{
            isDelayed = true
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
        var timeValueFont = TIME_VALUE_FONT

        if let valueForTime = paramDictionary?.valueForKey("Time") as? String{
            if valueForTime != ""{
                timeValueText = valueForTime
                timeLabelText = TIME_TEXT
                timeSize = caculateContentSize(TIME_TEXT, font:LABEL_TITLE_FONT)
            }
        }
        if let valueForNewTime = paramDictionary?.valueForKey("New_Time") as? String{
            if valueForNewTime != ""{
                timeValueText = valueForNewTime
                timeLabelText = NEW_TIME_TEXT
                timeSize = caculateContentSize(NEW_TIME_TEXT, font:LABEL_TITLE_FONT)
            }
        }
        if let valueForArrive = paramDictionary?.valueForKey("Arrive") as? String{
            if valueForArrive != ""{
                timeValueText = valueForArrive
                timeLabelText = ""
                timeValueFont = DESC_TEXT_FONT
                timeSize = CGRectMake(0, 0, 0, 0)
            }
        }
        if let valueForOngoing = paramDictionary?.valueForKey("Ongoing") as? String{
            if valueForOngoing != ""{
                timeValueText = "AIOrderDescView.ongoing".localized
                timeLabelText = ""
                timeValueFont = DESC_TEXT_FONT
                timeSize = CGRectMake(0, 0, 0, 0)
            }
        }
        
        


        let timeTextSize = caculateContentSize(timeValueText, font: timeValueFont)
        let timeValueLabelFrame = CGRectMake(self.bounds.width - timeTextSize.size.width - VIEW_PADDING, 0, timeTextSize.size.width, TEXT_HEIGHT)
        let timeLabelFrame = CGRectMake(timeValueLabelFrame.origin.x - TEXT_PADDING - timeSize.size.width + 2, 0, timeSize.size.width, TEXT_HEIGHT)
        
        var descLabelFrame : CGRect!
        
        if isDelayed{
            let alertTextSize = caculateContentSize("AIOrderDescView.delayed".localized, font: ALERT_LABEL_FONT)
            let alertLabelFrame = CGRectMake(timeLabelFrame.origin.x - alertTextSize.width - 25, 0, alertTextSize.width, TEXT_HEIGHT)
            let alertLabel = UILabel(frame: alertLabelFrame)
            alertLabel.text = "AIOrderDescView.delayed".localized
            alertLabel.font = ALERT_LABEL_FONT
            alertLabel.textColor = UIColor(hex: "#dbb613")
            alertLabel.alpha = 0.6
            self.addSubview(alertLabel)
            
            descLabelFrame = CGRectMake(0, 0, alertLabelFrame.origin.x - TEXT_PADDING, 21)
        }
        else{
            descLabelFrame = CGRectMake(0, 0, timeLabelFrame.origin.x - TEXT_PADDING, 21)
        }
        
        
        descLabel = UILabel(frame: descLabelFrame)
        descLabel.text = descText ?? "AIOrderDescView.delivery".localized
        descLabel.textColor = UIColor.whiteColor()
        descLabel.font = DESC_TEXT_FONT
        let timeLabel = UILabel(frame: timeLabelFrame)
        timeLabel.text = timeLabelText
        timeLabel.textColor = PurchasedViewColor.TITLE
        timeLabel.font = LABEL_TITLE_FONT
        timeLabel.alpha = 0.6

        let timeValueLabel = UILabel(frame: timeValueLabelFrame)
        timeValueLabel.font = timeValueFont
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
        
        if Localize.currentLanguage() == "zh-Hans" {
            SATE_LABEL_WIDTH = 41
        }
        
        let gateValueSize = caculateContentSize(gateText, font: TIME_VALUE_FONT)
        let sateValueSize = caculateContentSize(sateText, font: TIME_VALUE_FONT)
        let sateValueLabelFrame = CGRectMake(self.bounds.width - sateValueSize.size.width - VIEW_PADDING, 0, sateValueSize.width, TEXT_HEIGHT)
        let sateLabelFrame = CGRectMake(sateValueLabelFrame.origin.x - SATE_LABEL_WIDTH - TEXT_PADDING, 0, SATE_LABEL_WIDTH, TEXT_HEIGHT)
        let gateValueLabelFrame = CGRectMake(sateLabelFrame.origin.x - TEXT_PADDING - gateValueSize.width, 0, gateValueSize.width, TEXT_HEIGHT)
        let gateLabelFrame = CGRectMake(gateValueLabelFrame.origin.x - TEXT_PADDING - SATE_LABEL_WIDTH, 0, SATE_LABEL_WIDTH, TEXT_HEIGHT)
        let descLabelFrame = CGRectMake(0, 0, gateLabelFrame.origin.x - TEXT_PADDING, 21)
        //build sub view
        descLabel = UILabel(frame: descLabelFrame)
        descLabel.text = descText ?? "AIOrderDescView.delivery".localized
        descLabel.textColor = UIColor.whiteColor()
        descLabel.font = DESC_TEXT_FONT
        
        let sateValueLabel = UILabel(frame: sateValueLabelFrame)
        sateValueLabel.text = sateText
        sateValueLabel.textColor = PurchasedViewColor.TITLE
        sateValueLabel.font = TIME_VALUE_FONT
        
        let sateLabel = UILabel(frame: sateLabelFrame)
        sateLabel.textColor = PurchasedViewColor.TITLE
        sateLabel.font = LABEL_TITLE_FONT
        sateLabel.text = "AIOrderDescView.seat".localized
        sateLabel.alpha = 0.6
        
        let gateValueLabel = UILabel(frame: gateValueLabelFrame)
        gateValueLabel.text = gateText
        gateValueLabel.textColor = PurchasedViewColor.TITLE
        gateValueLabel.font = TIME_VALUE_FONT
        
        let gateLabel = UILabel(frame: gateLabelFrame)
        gateLabel.textColor = PurchasedViewColor.TITLE
        gateLabel.font = LABEL_TITLE_FONT
        gateLabel.text = "AIOrderDescView.gate".localized
        gateLabel.alpha = 0.6

        self.addSubview(descLabel)
        self.addSubview(sateValueLabel)
        self.addSubview(sateLabel)
        self.addSubview(gateValueLabel)
        self.addSubview(gateLabel)
    }
    
    
    // MARK : - utils
    func caculateContentSize(content:String,fontSize:CGFloat) -> CGRect{
        let size = CGSizeMake(200,100)
        let s:NSString = "\(content)"
        let contentSize = s.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin , attributes: [NSFontAttributeName:UIFont.systemFontOfSize(fontSize)], context: nil)
        return contentSize
    }
    
    func caculateContentSize(content:String,font:UIFont) -> CGRect{
        let size = CGSizeMake(200,100)
        let s:NSString = "\(content)"
        let contentSize = s.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin , attributes: [NSFontAttributeName:font], context: nil)
        return contentSize
    }
    
    
    
}