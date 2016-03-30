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
    var contentLabel : UILabel!
    var buttonsView : UIView?
    
    var model : AITimelineModel?
    var isLast = false
    
    // MARK: - Constants define
    let timeViewWidth : CGFloat = AITools.displaySizeFrom1242DesignSize(107)
    let timeViewBallSize : CGFloat = AITools.displaySizeFrom1242DesignSize(25)
    let titleLabelHeight : CGFloat = AITools.displaySizeFrom1242DesignSize(48)
    let timeLabelPadding : CGFloat = AITools.displaySizeFrom1242DesignSize(8)
    let timeLabelWidth : CGFloat = AITools.displaySizeFrom1242DesignSize(99)
    let timeLabelHeight : CGFloat = AITools.displaySizeFrom1242DesignSize(44)
    let rightViewLeftPadding : CGFloat = AITools.displaySizeFrom1242DesignSize(35)
    let titleContentPadding : CGFloat = AITools.displaySizeFrom1242DesignSize(28)
    let cellPadding : CGFloat = AITools.displaySizeFrom1242DesignSize(66)
    let contentLabelButtonPadding : CGFloat = AITools.displaySizeFrom1242DesignSize(35)
    let buttonViewHeight : CGFloat = AITools.displaySizeFrom1242DesignSize(103)
    let buttonsPadding : CGFloat = AITools.displaySizeFrom1242DesignSize(72)
    let buttonWidth : CGFloat = AITools.displaySizeFrom1242DesignSize(315)
    
    let titleFont = AITools.myriadSemiCondensedWithSize(48 / 3)
    let titleSpecFont = AITools.myriadLightSemiCondensedWithSize(48 / 3)
    let timeTextFont = AITools.myriadLightSemiCondensedWithSize(42 / 3)
    let buttonTextFont = AITools.myriadSemiCondensedWithSize(60 / 3)
    
    
    let timeViewBallColor = UIColor(hexString: "#575f88")
    let timeViewTextColor = UIColor(hexString: "#565c89")
    let contentViewTextColor = UIColor(hexString: "#a9b1ec")
    let lineViewColor = UIColor(hexString: "d8daf4",alpha: 0.3)
    let acceptButtonBgColor = UIColor(hexString: "#0f86e8")
    let acceptButtonTextColor = UIColor(hexString: "#231a66")
    
    var rightViewWidth : CGFloat!
    
    
    // MARK: - override
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        rightViewWidth = frame.width - timeViewWidth - timeViewBallSize
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
        let timeViewFrame = CGRect(x: 0, y: 0, width: timeViewWidth + timeViewBallSize / 2, height: 0)
        timeLabelView = UIView(frame: timeViewFrame)
        //timeLabelView.clipsToBounds = false
        contentView.addSubview(timeLabelView)
        
        //中间竖线
        let lineViewFrame = CGRect(x: timeViewWidth , y: 2, width: 0.5, height: 0)
        lineView = UIView(frame: lineViewFrame)
        lineView.backgroundColor = lineViewColor
        timeLabelView.addSubview(lineView)
        //时间内容view
        let timeLabelFrame = CGRect(x: timeLabelPadding, y: 0, width: timeLabelWidth, height: timeLabelHeight)
        let labelText = convertTimestamp()
        let timeLabel = UILabel(frame: timeLabelFrame)
        timeLabel.backgroundColor = UIColor.clearColor()
        timeLabel.text = labelText
        timeLabel.font = timeTextFont
        timeLabel.textColor = timeViewTextColor
        timeLabelView.addSubview(timeLabel)
        
        
        //小球
        let ballViewFrame = CGRect(x: timeViewWidth - timeViewBallSize / 2, y: 2,width : timeViewBallSize, height: timeViewBallSize)
        let ballView = UIView(frame: ballViewFrame)
        ballView.backgroundColor = timeViewBallColor
        ballView.layer.cornerRadius = timeViewBallSize / 2
        ballView.layer.masksToBounds = true
        timeLabelView.addSubview(ballView)
        
    }
    
    func buildTitleLabel(){
        let x = CGRectGetMaxX(timeLabelView.frame) + timeLabelPadding + rightViewLeftPadding
        let frame = CGRect(x: x, y: 0, width: rightViewWidth, height: titleLabelHeight)
        titleLabel = UILabel(frame: frame)
        titleLabel.textColor = UIColor.whiteColor()
        if let title = model?.title{
            let textAttribute = NSMutableAttributedString(string: title)
            textAttribute.addAttribute(NSFontAttributeName, value: titleFont, range: NSMakeRange(0, title.length))
            if let specRange = findSpecTextRange(title){
                textAttribute.addAttribute(NSFontAttributeName, value: titleSpecFont, range: specRange)
            }
            
            //TODO:如果range超范围了直接闪退
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
        
        scheduleContentView = UIView(frame: CGRectZero)
        contentView.addSubview(scheduleContentView)
        
        if let desc = model?.desc{
            let contentSize = desc.sizeWithFont(timeTextFont, forWidth: rightViewWidth)
            frame = CGRect(x: 0, y: 0, width: rightViewWidth, height: contentSize.height)
            textAttribute = NSMutableAttributedString(string: desc)
            if let status = model?.status{
                if status == TimelineStatus.Warning{
                    let textAttachement = NSTextAttachment(data: nil, ofType: nil)
                    textAttachement.image = UIImage(named: "timeline-warning")
                    textAttachement.bounds = CGRect(x: 0, y: -2, width: 40 / 3, height: 40 / 3)
                    let textAttachementString = NSAttributedString(attachment: textAttachement)
                    textAttribute.insertAttributedString(textAttachementString, atIndex: 0)
                    
                }
            }
            textAttribute.addAttribute(NSFontAttributeName, value: timeTextFont, range: NSMakeRange(0, desc.length))
            if let specRange = findSpecTextRange(desc){
                textAttribute.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: specRange)
            }
        }
        else{
            frame = CGRectZero
            textAttribute = NSMutableAttributedString(string: "")
        }
        contentLabel = UILabel(frame: frame)
        contentLabel.textColor = contentViewTextColor
        contentLabel.attributedText = textAttribute
        contentLabel.numberOfLines = 2
        scheduleContentView.addSubview(contentLabel)
        //如果有处理的，还要加上按钮
        //TODO 什么时候要加按钮的逻辑还没有
        if let status = model?.status{
            if status == TimelineStatus.Warning{
                buildButtonsView()
            }
        }
        
        //内容view的高度取决于内部元素
        let contentViewX = CGRectGetMaxX(timeLabelView.frame) + timeLabelPadding + rightViewLeftPadding
        var contentViewHeight : CGFloat
        //如果有buttonView,高度要重新计算
        if buttonsView != nil {
            contentViewHeight = contentLabel.frame.height + buttonViewHeight + contentLabelButtonPadding + cellPadding
        }
        else{
            contentViewHeight = contentLabel.frame.height + cellPadding
        }
        
        let contentViewFrame = CGRect(x: contentViewX, y: titleLabelHeight + titleContentPadding, width: contentLabel.frame.width, height: contentViewHeight)
        scheduleContentView.frame = contentViewFrame
        
    }
    
    func buildButtonsView(){
        let buttonViewFrame = CGRect(x: 0, y: CGRectGetMaxY(contentLabel.frame) + contentLabelButtonPadding, width: rightViewWidth, height: buttonViewHeight)
        buttonsView = UIView(frame: buttonViewFrame)
        scheduleContentView.addSubview(buttonsView!)
        
        let acceptButtonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonViewHeight)
        let acceptButton = UIButton(frame: acceptButtonFrame)
        acceptButton.backgroundColor = acceptButtonBgColor
        acceptButton.setTitleColor(acceptButtonTextColor, forState: UIControlState.Normal)
        acceptButton.setTitle("accept", forState: UIControlState.Normal)
        acceptButton.titleLabel?.font = buttonTextFont
        acceptButton.layer.cornerRadius = 5
        acceptButton.layer.masksToBounds = true
        buttonsView?.addSubview(acceptButton)
        
        let ignoreButtonFrame = CGRect(x: CGRectGetMaxX(acceptButton.frame) + buttonsPadding, y: 0, width: buttonWidth, height: buttonViewHeight)
        let ignoreButton = UIButton(frame: ignoreButtonFrame)
        ignoreButton.backgroundColor = UIColor.clearColor()
        ignoreButton.setTitleColor(acceptButtonBgColor, forState: UIControlState.Normal)
        ignoreButton.setTitle("ignore", forState: UIControlState.Normal)
        ignoreButton.titleLabel?.font = buttonTextFont
        ignoreButton.layer.cornerRadius = 5
        ignoreButton.layer.borderWidth = 1
        ignoreButton.layer.borderColor = acceptButtonBgColor.CGColor
        ignoreButton.layer.masksToBounds = true
        buttonsView?.addSubview(ignoreButton)
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
    
    //TODO 这是一个临时方法，现在还没定义特殊字符格式的规律，目前就通过用户名称去匹配
    func findSpecTextRange(text : String) -> NSRange? {
        let userNameArray = ["Ms.Customer A","Requests Authorization"]
        let nsStringText = NSString(string: text)
        for userName in userNameArray{
            let range = nsStringText.rangeOfString(userName)
            if range.length > 0{
                return range
            }
        }
        return nil
    }
    
    //找剩下的字符串的NSRange,也是临时方法
    func findLeftTextRange(text : String, specRange : NSRange) -> NSRange{
        let leftLocation = specRange.location + specRange.length
        let leftLength = text.length - leftLocation
        return NSMakeRange(leftLocation, leftLength)
    }
}
