//
//  ServiceCardDetailFlag.swift
//  AIVeris
//
//  Created by 刘先 on 15/11/17.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit



class ServiceCardDetailFlag: ServiceParamlView {
    
    //MARK: - uiViews
    var titleLabel : UILabel!
    var flagContainer : UIView!
    

    var dataSource : ServiceCellProductParamModel?
//    var flags = ["Medicine Pickup","Queuing","Calling for Taxi","Check-in","Paramedic","Test Results Pickup"]
    let colorArray = [UIColor(hexString: "#1c789f"),UIColor(hexString: "#7b3990"),UIColor(hexString: "#619505"),UIColor(hexString: "#f79a00"),UIColor(hexString: "#d05126"),UIColor(hexString: "#b32b1d")]
    //MARK: - Constants
    //sizes
    let VIEW_LEFT_MARGIN : CGFloat = 35
    var VIEW_TOP_MARGIN : CGFloat = 0
    let CORNER_RADIOS_SIZE : CGFloat = AITools.displaySizeFrom1080DesignSize(67/2)
    let FLAG_LEFT_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(18)
    let FLAG_HEIGHT_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(30)
    let FLAG_LABEL_HEIGHT : CGFloat = AITools.displaySizeFrom1080DesignSize(67)
    let FLAG_MAX_WIDTH : CGFloat = UIScreen.mainScreen().bounds.width - 20
    let TITLE_HEIGHT : CGFloat = AITools.displaySizeFrom1080DesignSize(36)
    //fonts
    let FLAG_TEXT_FONT : UIFont = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(34))
    let TITLE_TEXT_FONT : UIFont = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(42))
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = AITools.displaySizeFrom1080DesignSize(300)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func isFirstView(isfirst: Bool) {
        if isfirst {
           VIEW_TOP_MARGIN = AITools.displaySizeFrom1080DesignSize(50)
        }
    }
    
    
    //MARK: - load data
    override func loadData(json jsonString : String){
        buildModel(jsonString)
        layoutView()
    }
    
    func buildModel(jsonString : String){
        dataSource = ServiceCellProductParamModel(string: jsonString, error: nil)
    }
    
    override func loadDataWithModelArray(models: ServiceCellProductParamModel!) {
        dataSource = models
        layoutView()
    }
    
    func layoutView(){
        buildTitle()
        buildFlagsContainer()
        fixFrame()
    }
    
    //MARK: - build views
    func buildTitle(){
        var titleFrame = CGRectMake(VIEW_LEFT_MARGIN, VIEW_TOP_MARGIN, FLAG_MAX_WIDTH, TITLE_HEIGHT)
        if dataSource?.product_name.isEmpty == true {
            titleFrame = CGRectMake(VIEW_LEFT_MARGIN, 0, FLAG_MAX_WIDTH, 0)
        }
        titleLabel = UILabel(frame: titleFrame)
        titleLabel.font = TITLE_TEXT_FONT
        titleLabel.textColor = UIColor.whiteColor()
        
        titleLabel.text = dataSource?.product_name
        self.addSubview(titleLabel)
    }
    
    func buildFlagsContainer(){
        flagContainer = UIView(frame: CGRectMake(0, titleLabel.frame.maxY + FLAG_HEIGHT_MARGIN, self.bounds.width, 0))
        if dataSource?.product_name.isEmpty == true {
            flagContainer.setY(5)
        }
        self.addSubview(flagContainer)
        var curFrame = CGRectMake(0, 0, 0, FLAG_LABEL_HEIGHT)

        for var i = 0 ; i < dataSource?.param_list.count ; i++ {
            let stadandParam = dataSource?.param_list[i] as! ServiceCellStadandParamModel
            let text = stadandParam.param_value
            curFrame = buildFlag(curFrame, text: text,number : i)
        }
        //加载完subView后计算最后高度
        flagContainer.frame.size.height = curFrame.maxY + FLAG_HEIGHT_MARGIN - 6
    }
    
    func buildFlag(lastFrame : CGRect,text : String,number : Int) -> CGRect {
        let width = text.sizeWithFont(FLAG_TEXT_FONT, forWidth: FLAG_MAX_WIDTH).width + CORNER_RADIOS_SIZE * 2
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
        flagLabel.textColor = UIColor.whiteColor()
        flagLabel.layer.cornerRadius = CORNER_RADIOS_SIZE
        flagLabel.layer.masksToBounds = true
        flagLabel.textAlignment = NSTextAlignment.Center
        //MARK: - TODO
        if let index = colorInfo.indexOf(text) {
            flagLabel.backgroundColor = colorArray[index]
        } else {
            flagLabel.backgroundColor = colorArray[number]
        }
        flagContainer.addSubview(flagLabel)
        return flagLabel.frame
    }
    
    let colorInfo = [
        "Medicine Pickup ",
        "Queuing ",
        "Calling for Taxi ",
        "Check-in ",
        "Paramedic ",
        "Test Results Pick"
    ]
    
    func fixFrame(){
        self.frame.size.height = flagContainer.frame.maxY
    }
}
