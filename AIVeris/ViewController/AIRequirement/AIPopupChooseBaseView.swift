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
    
    var itemModels : [AIPopupChooseModel]?
    var delegate : AIPopupChooseViewDelegate?
    
    let cellViewHeight : CGFloat = 40
    let buttonPaddingTop : CGFloat = 10
    let buttonWidth : CGFloat = 100
    let buttonHeight : CGFloat = 30
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
        self.backgroundColor = UIColor(patternImage: UIImage(named: "AIRequirebg1")!)
        //self.clipsToBounds = true
    }
    
    func loadData(models : [AIPopupChooseModel]){
        itemModels = models
        buildView()
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
        }
        
    }
    
    private func buildView(){
        //先清除所有的subView，才能重复构造
        for subView in self.subviews{
            subView.removeFromSuperview()
        }
        cellViews.removeAll()
        if let itemModels = itemModels{
            for (index,itemModels) in itemModels.enumerate(){
                let frame = CGRect(x: 0, y: cellViewHeight * CGFloat(index), width: self.frame.width, height: cellViewHeight)
                let cellView = AIPopupChooseCellView(frame: frame)
                cellView.loadData(itemModels)
                self.addSubview(cellView)
                cellViews.append(cellView)
            }
        }
        
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
        cancelButton.backgroundColor = UIColor(hex: "#146EE2")
        cancelButton.titleLabel?.textColor = UIColor.whiteColor()
        cancelButton.layer.cornerRadius = buttonCorner
        cancelButton.layer.masksToBounds = true
        self.addSubview(cancelButton)
        
        let x2 = (self.width / 2 + self.width - buttonWidth) / 2
        let submitFrame = CGRect(x: x2, y: y, width: buttonWidth, height: buttonHeight)
        confirmButton = UIButton(frame: submitFrame)
        confirmButton.setTitle("Save", forState: UIControlState.Normal)
        confirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        confirmButton.backgroundColor = UIColor(hex: "#146EE2")
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
    }
    
    func confirmAction(){
        if let delegate = delegate{
            delegate.didConfirm(self)
        }
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
    var isSelect = false
    
    //position
    let iconSize : CGFloat = 20
    let viewPadding : CGFloat = 10
    let confirmViewSize : CGFloat = 20
    
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
        let url = NSURL(string: (itemModel?.itemIcon)!)
        iconView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Seller_Location")!)
        contentLabel.text = itemModel?.itemTitle
        //根据是否有权限决定是选中还是未选中
        if let itemModel = itemModel{
            if itemModel.isSelect {
                confirmView.image = UIImage(named: "Type_On")
                isSelect = true
            }
            else{
                confirmView.image = UIImage(named: "Type_Off")
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
        let frame = CGRect(x: 0, y: y, width: iconSize, height: iconSize)
        iconView = UIImageView(frame: frame)
        self.addSubview(iconView)
    }
    
    private func buildContentLabel(){
        let frame = CGRect(x: iconSize + viewPadding, y: 0, width: self.bounds.width - iconSize - confirmViewSize - viewPadding * 2, height: self.bounds.height)
        contentLabel = UILabel(frame: frame)
        contentLabel.textColor = UIColor.whiteColor()
        //TODO 设置为市场部给的字体
        contentLabel.font = UIFont.systemFontOfSize(14)
        
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
        let x = CGRectGetMaxX(contentLabel.frame)
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
        itemModel?.isSelect = isSelect
        if isSelect{
            confirmView.image = UIImage(named: "Type_On")
        }
        else{
            confirmView.image = UIImage(named: "Type_Off")
        }
    }
}

protocol AIPopupChooseViewDelegate {
    func didConfirm(view : AIPopupChooseBaseView)
    
    func didCancel(view : AIPopupChooseBaseView)
}