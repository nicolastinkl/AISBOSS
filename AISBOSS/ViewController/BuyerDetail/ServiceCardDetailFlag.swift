//
//  ServiceCardDetailFlag.swift
//  AIVeris
//
//  Created by 刘先 on 15/11/17.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class ServiceCardDetailFlag: UIView {
    
    //MARK: - uiViews
    var titleLabel : UILabel!
    var flagContainer : UIView!
    

    var dataSource : NSDictionary?
    var flags = ["aaa","bbb","ccc","ddddddd","eeeeeeeee"]
    let colorArray = [UIColor(hexString: "#ffffff"),UIColor(hexString: "#ffffff"),UIColor(hexString: "#ffffff"),UIColor(hexString: "#ffffff"),UIColor(hexString: "#ffffff"),UIColor(hexString: "#ffffff"),UIColor(hexString: "#ffffff"),UIColor(hexString: "#ffffff")]
    //MARK: - Constants
    //sizes
    let VIEW_LEFT_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(98)
    let CORNER_RADIOS_SIZE : CGFloat = AITools.displaySizeFrom1080DesignSize(33)
    let FLAG_LEFT_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(40)
    let FLAG_HEIGHT_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(50)
    let FLAG_LABEL_HEIGHT : CGFloat = AITools.displaySizeFrom1080DesignSize(50)
    let FLAG_MAX_WIDTH : CGFloat = UIScreen.mainScreen().bounds.width - 20
    let TITLE_HEIGHT : CGFloat = AITools.displaySizeFrom1080DesignSize(60)
    //fonts
    let FLAG_TEXT_FONT : UIFont = AITools.myriadRegularWithSize(12)
    let TITLE_TEXT_FONT : UIFont = AITools.myriadRegularWithSize(17)
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = AITools.displaySizeFrom1080DesignSize(300)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - load data
    func loadData(){
        layoutView()
    }
    
    func layoutView(){
        buildTitle()
        buildFlagsContainer()
        fixFrame()
    }
    
    //MARK: - build views
    func buildTitle(){
        let text = "Service Coverage"
        let titleFrame = CGRectMake(VIEW_LEFT_MARGIN, 0, FLAG_MAX_WIDTH, TITLE_HEIGHT)
        titleLabel = UILabel(frame: titleFrame)
        titleLabel.text = text
        titleLabel.font = TITLE_TEXT_FONT
        titleLabel.textColor = UIColor.whiteColor()
        self.addSubview(titleLabel)
    }
    
    func buildFlagsContainer(){
        flagContainer = UIView(frame: CGRectMake(0, titleLabel.frame.maxY + FLAG_HEIGHT_MARGIN, self.bounds.width, 100))
        self.addSubview(flagContainer)
        var curFrame = CGRectMake(0, 0, 0, FLAG_LABEL_HEIGHT)
        for text : String in flags {
            curFrame = buildFlag(curFrame, text: text)
        }
        //加载完subView后计算最后高度
        flagContainer.frame.size.height = curFrame.maxY + FLAG_HEIGHT_MARGIN * 2
    }
    
    func buildFlag(lastFrame : CGRect,text : String) -> CGRect {
        let width = text.sizeWithFont(FLAG_TEXT_FONT, forWidth: FLAG_MAX_WIDTH).width + CORNER_RADIOS_SIZE
        var x = lastFrame.maxX
        if x == 0 {
            x = x + VIEW_LEFT_MARGIN
        }
        else{
            x = x + FLAG_LEFT_MARGIN
        }
        var y = lastFrame.origin.y
        if (x + width + FLAG_LEFT_MARGIN) > self.bounds.width {
            x = VIEW_LEFT_MARGIN
            y = y + FLAG_HEIGHT_MARGIN + FLAG_LABEL_HEIGHT
        }
        let flagLabel = UILabel(frame: CGRectMake(x, y, width, FLAG_LABEL_HEIGHT))
        flagLabel.text = text
        flagLabel.font = FLAG_TEXT_FONT
        flagLabel.layer.cornerRadius = CORNER_RADIOS_SIZE
        flagLabel.layer.masksToBounds = true
        flagLabel.textAlignment = NSTextAlignment.Center
        //MARK: - TODO
        flagLabel.backgroundColor = colorArray[0]
        flagContainer.addSubview(flagLabel)
        return flagLabel.frame
    }
    
    func fixFrame(){
        self.frame.size.height = flagContainer.frame.maxY + FLAG_HEIGHT_MARGIN
    }
}
