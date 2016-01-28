//
//  ServiceCardTextView.swift
//  AIVeris
//
//  Created by tinkl on 1/22/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Cartography


class ServiceCardTextView: ServiceParamlView {
    
    //fonts
    //sizes
    let VIEW_LEFT_MARGIN : CGFloat = 35
    let VIEW_TOP_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(50)
    let CORNER_RADIOS_SIZE : CGFloat = AITools.displaySizeFrom1080DesignSize(67/2)
    let FLAG_LEFT_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(18)
    let FLAG_HEIGHT_MARGIN : CGFloat = AITools.displaySizeFrom1080DesignSize(30)
    let FLAG_LABEL_HEIGHT : CGFloat = AITools.displaySizeFrom1080DesignSize(60)
    let FLAG_MAX_WIDTH : CGFloat = UIScreen.mainScreen().bounds.width - 20
    let TITLE_HEIGHT : CGFloat = AITools.displaySizeFrom1080DesignSize(36)
    //fonts
    
    let TITLE_TEXT_FONT : UIFont = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(48))
    
    var dataSource : ServiceCellProductParamModel?
    
    private var flagContainer:UIView!
    
    private lazy var textView:UILabel = {
        let titleFrame = CGRectMake(0, 0, 0, 21)
        var titleLabel = UILabel(frame: titleFrame)
        titleLabel.font =  AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(48))
        titleLabel.textColor = UIColor.whiteColor()
        return titleLabel
    }()
    
    override func loadDataWithModelArray(models: ServiceCellProductParamModel!) {
        dataSource = models
        //initLayout()
        buildFlagsContainer()
        fixFrame()
    }
    
    func initLayout() {

        var arrayViews = [UILabel]()
        
        for item in (dataSource?.param_list as? [ServiceCellStadandParamModel])!{
            self.addSubview(textView)
            textView.text = item.param_name
            textView.associatedName = item.param_value
            arrayViews.append(textView)
        }

        constrain(arrayViews) { (ViewLayout: [LayoutProxy]) -> () in
            _ = ViewLayout.filter({ (layout) -> Bool in
                layout.edges  == inset(layout.superview!.edges, 20, 20, 40, 20)
                return true
            })
            //ViewLayout.edges == inset(view.superview!.edges, 20, 20, 40, 20)
        }
        
    }
    func fixFrame(){
        self.frame.size.height = flagContainer.frame.maxY
    }
    
    
    func buildFlagsContainer(){
        flagContainer = UIView(frame: CGRectMake(0,  AITools.displaySizeFrom1080DesignSize(44), self.bounds.width, 100))
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
        let width = text.sizeWithFont(TITLE_TEXT_FONT, forWidth: FLAG_MAX_WIDTH).width + CORNER_RADIOS_SIZE * 2
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
        
        let flagLabel = UILabel(frame: CGRectMake(x, y, width , FLAG_LABEL_HEIGHT))
        flagLabel.text = text
        flagLabel.font = TITLE_TEXT_FONT
        flagLabel.textColor = UIColor.whiteColor()
        flagLabel.textAlignment = NSTextAlignment.Left
        //MARK: - TODO
        flagContainer.addSubview(flagLabel)
        return flagLabel.frame
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}