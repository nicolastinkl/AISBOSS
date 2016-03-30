//
//  TimelineCellBaseView.swift
//  MyWholeDemos
//
//  Created by 刘先 on 16/3/7.
//  Copyright © 2016年 wantsor. All rights reserved.
//

import UIKit

class AITimelineCellBaseView: UITableViewCell {
    
    var timeLabelView : UIView!
    var titleLabel : UILabel!
    var scheduleContentView : UIView!
    var lineView : UIView!
    
    var model : AITimelineModel?
    var isLast = false
    
    let timeViewWidth : CGFloat = AITools.displaySizeFrom1242DesignSize(132)
    let timeViewBallSize : CGFloat = AITools.displaySizeFrom1242DesignSize(25)
    let titleLabelHeight : CGFloat = AITools.displaySizeFrom1242DesignSize(45)
    let timeLabelPadding : CGFloat = AITools.displaySizeFrom1242DesignSize(8)
    let timeLabelSize : CGFloat = 50
    var rightViewWidth : CGFloat!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        rightViewWidth = frame.width - timeViewWidth
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    ///传入生成view所需数据，并渲染view
    func setContent(model : AITimelineModel,isLast : Bool){
        self.model = model
        self.isLast = isLast
        buildTimeLabelView()
        buildTitleLabel()
        buildScheduleContentView()
        adjustFrameSize()
    }
    
    ///获取view高度
    func getContentHeight() -> CGFloat{
        return self.frame.height
    }
    
    // MARK: - 渲染view
    func buildTimeLabelView(){
        //中间竖线
        let lineViewFrame = CGRect(x: timeLabelSize / 2, y: 0, width: 0.5, height: 0)
        lineView = UIView(frame: lineViewFrame)
        lineView.backgroundColor = UIColor.grayColor()
        //时间内容view
        let timeLabelFrame = CGRect(x: 0, y: 0, width: timeLabelSize, height: timeLabelSize)
        let labelText = convertTimestamp()
        let timeLabel = UILabel(frame: timeLabelFrame)
        timeLabel.backgroundColor = UIColor.whiteColor()
        
        timeLabel.text = labelText
        timeLabel.layer.cornerRadius = 25
        timeLabel.layer.masksToBounds = true
        timeLabel.layer.borderWidth = 0.5
        timeLabel.layer.borderColor = UIColor.blueColor().CGColor
        
        let timeViewFrame = CGRect(x: 0, y: 0, width: timeViewWidth, height: 0)
        timeLabelView = UIView(frame: timeViewFrame)
        if !isLast {
            timeLabelView.addSubview(lineView)
        }        
        timeLabelView.addSubview(timeLabel)
        timeLabelView.clipsToBounds = false
        contentView.addSubview(timeLabelView)
    }
    
    func buildTitleLabel(){
        let frame = CGRect(x: timeViewWidth, y: 0, width: rightViewWidth, height: titleLabelHeight)
        titleLabel = UILabel(frame: frame)
        titleLabel.textColor = UIColor.whiteColor()
        if let title = model?.title{
            let textAttribute = NSMutableAttributedString(string: title)
            let fontBold = UIFont.systemFontOfSize(15)
            let fontNormal = UIFont.systemFontOfSize(12)
            textAttribute.addAttribute(NSFontAttributeName, value: fontBold, range: NSMakeRange(0, 6))
            //TODO:如果range超范围了直接闪退
            textAttribute.addAttribute(NSFontAttributeName, value: fontNormal, range: NSMakeRange(6, 8))
            titleLabel.attributedText = textAttribute
        }
        else{
            titleLabel.text =  "titletitle"
        }
        contentView.addSubview(titleLabel)
    }
    
    func buildScheduleContentView(){
        var frame:CGRect
        var textAttribute : NSMutableAttributedString
        if let desc = model?.desc{
            let contentSize = desc.sizeWithFontSize(15, forWidth: rightViewWidth)
            frame = CGRect(x: 0, y: 0, width: rightViewWidth, height: contentSize.height)
            textAttribute = NSMutableAttributedString(string: desc)
            textAttribute.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, 8))
            if let status = model?.status{
                if status == TimelineStatus.Warning{
                    let textAttachement = NSTextAttachment(data: nil, ofType: nil)
                    textAttachement.image = UIImage(named: "Seller_Warning")
                    let textAttachementString = NSAttributedString(attachment: textAttachement)
                    textAttribute.insertAttributedString(textAttachementString, atIndex: 0)
                }
            }
        }
        else{
            frame = CGRectZero
            textAttribute = NSMutableAttributedString(string: "")
        }
        let contentLabel = UILabel(frame: frame)
        contentLabel.textColor = UIColor.whiteColor()
        contentLabel.attributedText = textAttribute
        
        //内容view的高度取决于内部元素
        let contentViewFrame = CGRect(x: timeViewWidth, y: titleLabelHeight, width: contentLabel.frame.width, height: contentLabel.frame.height)
        scheduleContentView = UIView(frame: contentViewFrame)
        contentView.addSubview(scheduleContentView)
        scheduleContentView.addSubview(contentLabel)
    }
    
    func adjustFrameSize(){
        let viewHeight = CGRectGetMaxY(scheduleContentView.frame)
        self.frame.size.height = viewHeight
        lineView.frame.size.height = viewHeight
        timeLabelView.frame.size.height = viewHeight
    }

    // MARK: - 工具方法
    func convertTimestamp() -> String{
        if let timestamp = model?.timestamp {
            let date = NSDate(timeIntervalSince1970: timestamp)
            let dateToStringFormatter = NSDateFormatter()
            dateToStringFormatter.dateFormat = "HH:mm"
            return dateToStringFormatter.stringFromDate(date)
        }
        else{
            return ""
        }
    }
}
