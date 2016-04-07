//
//  AIPopupChoseBaseView.swift
//  AIVeris
//
//  Created by 刘先 on 16/3/22.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIPopupChooseBaseView: UIView {

    var cellViews = [AIPopupChooseCellView]()
    var cancelButton : UIButton!
    var confirmButton : UIButton!
    var bgView : UIImageView!
    
    var itemModels : [AIPopupChooseModel]?
    var delegate : AIPopupChooseViewDelegate?
    var businessType : PopupBusinessType!
    
    let cellViewHeight : CGFloat = AITools.displaySizeFrom1242DesignSize(70)
    let viewTopPadding : CGFloat = AITools.displaySizeFrom1242DesignSize(60)
    let cellViewPadding : CGFloat = AITools.displaySizeFrom1242DesignSize(83)
    let buttonPaddingTop : CGFloat = AITools.displaySizeFrom1242DesignSize(116)
    let buttonWidth : CGFloat = AITools.displaySizeFrom1242DesignSize(568)
    let buttonHeight : CGFloat = AITools.displaySizeFrom1242DesignSize(154)
    let buttonCorner : CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    func initView(){
        //self.backgroundColor = UIColor(patternImage: UIImage(named: "popup-bg")!)
        //self.clipsToBounds = true
        buildBackgroundView()
    }
    
    func loadData(models : [AIPopupChooseModel] , businessType : PopupBusinessType){
        itemModels = models
        self.businessType = businessType
        buildCellViews()
        buildHandleButtons()
        bindEvents()
        fixFrame()
    }
    
    func refreshLimits(models : [AILimitModel]){
        for (index,cellView) in cellViews.enumerate(){
            cellView.loadData(itemModels![index])
        }
    }
    
    func fixFrame(){
        if(cancelButton != nil){
            self.frame.size.height = CGRectGetMaxY(cancelButton.frame) + buttonPaddingTop
            bgView.frame = self.bounds
        }
        
    }
    
    private func buildCellViews(){
        //先清除所有的subView，才能重复构造
        for subView in self.subviews{
            if subView.isKindOfClass(AIPopupChooseCellView) {
                subView.removeFromSuperview()
            }
            
        }
        cellViews.removeAll()
        
        if let itemModels = itemModels{
            for (index,itemModel) in itemModels.enumerate(){
                let frame = CGRect(x: 0, y: viewTopPadding + (cellViewHeight + cellViewPadding) * CGFloat(index), width: self.frame.width, height: cellViewHeight)
                let cellView = AIPopupChooseCellView(frame: frame)
                cellView.loadData(itemModel)
                self.addSubview(cellView)
                cellViews.append(cellView)
            }
        }
        
    }
    
    private func buildBackgroundView(){
        bgView = UIImageView(frame: self.bounds)
        bgView.contentMode = .ScaleToFill
        bgView.image = UIImage(named: "popup-bg")
        self.addSubview(bgView)
    }
    
    private func buildHandleButtons(){
        var y : CGFloat = buttonPaddingTop
        if let lastCell = cellViews.last{
            y = CGRectGetMaxY(lastCell.frame) + buttonPaddingTop
        }
        let x1 = (self.width / 2 - buttonWidth) / 2
        let cancelFrame = CGRect(x: x1, y: y, width: buttonWidth, height: buttonHeight)
        cancelButton = UIButton(frame: cancelFrame)
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cancelButton.setBackgroundImage(UIColor(hex: "#3055ab").imageWithColor(), forState: UIControlState.Normal)
        cancelButton.titleLabel?.textColor = UIColor.whiteColor()
        cancelButton.alpha = 0.65
        cancelButton.layer.cornerRadius = buttonCorner
        cancelButton.layer.masksToBounds = true
        self.addSubview(cancelButton)
        
        let x2 = (self.width / 2 + self.width - buttonWidth) / 2
        let submitFrame = CGRect(x: x2, y: y, width: buttonWidth, height: buttonHeight)
        confirmButton = UIButton(frame: submitFrame)
        confirmButton.setTitle("Save", forState: UIControlState.Normal)
        confirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmButton.setBackgroundImage(UIColor(hex: "#0f86e8").imageWithColor(), forState: UIControlState.Normal)
        confirmButton.titleLabel?.textColor = UIColor.whiteColor()
        confirmButton.layer.cornerRadius = buttonCorner
        confirmButton.layer.masksToBounds = true
        self.addSubview(confirmButton)

    }
    
    private func bindEvents(){
        let cancelTapGuesture = UITapGestureRecognizer(target: self, action: "cancelAction")
        cancelButton.addGestureRecognizer(cancelTapGuesture)
        let confirmGuesture = UITapGestureRecognizer(target: self, action: "confirmAction")
        confirmButton.addGestureRecognizer(confirmGuesture)
    }
    
    func cancelAction(){
        if let delegate = delegate{
            delegate.didCancel(self)
        }
        //点击后发关闭通知
        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIRequirementClosePopupNotificationName, object: nil)
    }
    
    func confirmAction(){
        if let delegate = delegate{
            delegate.didConfirm(self,itemModels: itemModels!)
        }
        //点击后发关闭通知
        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIRequirementClosePopupNotificationName, object: nil)
    }
    
    func getFrameHeight() -> CGFloat{
        return CGRectGetMaxY(cancelButton.frame) + buttonPaddingTop
    }


}

class AIPopupChooseCellView: UIView {
    
    var itemModel : AIPopupChooseModel?
    
    var iconView : UIImageView!
    var contentLabel : UILabel!
    var confirmView : UIImageView!
    var iconNormalImage , iconHighlightImage : UIImage!
    var isSelect = false
    
    //position
    let iconSize : CGFloat = AITools.displaySizeFrom1242DesignSize(58)
    
    let confirmViewSize : CGFloat = AITools.displaySizeFrom1242DesignSize(70)
    let iconLeftPadding : CGFloat = AITools.displaySizeFrom1242DesignSize(54)
    let iconRightPadding : CGFloat = AITools.displaySizeFrom1242DesignSize(20)
    let confirmFrameRightPadding : CGFloat = AITools.displaySizeFrom1242DesignSize(54)
    let contentFontUnselect = AITools.myriadLightSemiCondensedWithSize(42 / 3)
    let contentFontSelect = AITools.myriadSemiCondensedWithSize(42 / 3)
    
    let iconSelect = UIImage(named: "popup-select")
    let iconUnselect = UIImage(named: "popup-unselect")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //不能在loadData时构造view，否则再次调用刷新数据时就重复添加subView了
    func loadData(itemModel : AIPopupChooseModel){
        self.itemModel = itemModel
        updateViewContent()
    }
    
    private func updateViewContent(){
        //TODO 设置为model传入的icon路径
        
        
        
        contentLabel.text = itemModel?.itemTitle
        //根据是否有权限决定是选中还是未选中
        if let itemModel = itemModel{
            if itemModel.isSelect {
                confirmView.image = iconSelect
                contentLabel.font = contentFontSelect
                let hightlightUrl = NSURL(string: (itemModel.itemIconHighlight))
                iconView.sd_setImageWithURL(hightlightUrl)
                isSelect = true
            }
            else{
                confirmView.image = iconUnselect
                contentLabel.font = contentFontUnselect
                let url = NSURL(string: (itemModel.itemIcon))
                iconView.sd_setImageWithURL(url)
                isSelect = false
            }
        }
    }
    
    private func buildView(){
        self.backgroundColor = UIColor.clearColor()
        //self.clipsToBounds = true
        buildLeftIcon()
        buildContentLabel()
        buildConfirmView()
        //buildSplitLine()
        bindEvents()
    }
    
    private func buildLeftIcon(){
        let y = (self.bounds.height - iconSize) / 2
        let frame = CGRect(x: iconLeftPadding, y: y, width: iconSize, height: iconSize)
        iconView = UIImageView(frame: frame)
        self.addSubview(iconView)
    }
    
    private func buildContentLabel(){
        let width = self.bounds.width - confirmViewSize - confirmFrameRightPadding - (CGRectGetMaxX(iconView.frame) + iconRightPadding)
        let frame = CGRect(x: CGRectGetMaxX(iconView.frame) + iconRightPadding, y: 0, width: width, height: self.bounds.height)
        contentLabel = UILabel(frame: frame)
        contentLabel.textColor = UIColor.whiteColor()
        
        
        self.addSubview(contentLabel)
    }
    
    private func buildSplitLine(){
        let frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 0.5)
        let splitLineView = UIView(frame: frame)
        splitLineView.backgroundColor = UIColor.grayColor()
        splitLineView.alpha = 0.7
        self.addSubview(splitLineView)
    }
    
    private func buildConfirmView(){
        let y = (self.bounds.height - confirmViewSize) / 2
        let x = self.bounds.width - confirmViewSize - confirmFrameRightPadding
        let frame = CGRect(x: x, y: y, width: confirmViewSize, height: confirmViewSize)
        confirmView = UIImageView(frame: frame)
        
        self.addSubview(confirmView)
    }
    
    private func bindEvents(){
        let tapGuesture = UITapGestureRecognizer(target: self, action: "tapAction:")
        self.addGestureRecognizer(tapGuesture)
    }
    
    func tapAction(sender : AnyObject){
        isSelect = !isSelect
        //给itemModel重新复制
        itemModel?.isSelect = isSelect
        if isSelect{
            confirmView.image = iconSelect
            contentLabel.font = contentFontSelect
            let hightlightUrl = NSURL(string: (itemModel!.itemIconHighlight))
            iconView.sd_setImageWithURL(hightlightUrl)
            
        }
        else{
            confirmView.image = iconUnselect
            contentLabel.font = contentFontUnselect
            let url = NSURL(string: (itemModel!.itemIcon))
            iconView.sd_setImageWithURL(url)            
        }
    }
}

protocol AIPopupChooseViewDelegate {
    func didConfirm(view : AIPopupChooseBaseView, itemModels : [AIPopupChooseModel])
    
    func didCancel(view : AIPopupChooseBaseView)
}

enum PopupBusinessType : Int{
    case LimitConfig = 1 , TimelineFilter
}