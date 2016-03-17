//
//  AILimitListView.swift
//  MyWholeDemos
//
//  Created by 刘先 on 16/3/14.
//  Copyright © 2016年 wantsor. All rights reserved.
//

import Foundation
import UIKit

class AILimitListView: UIView {
    
    var cellViews = [AILimitCellView]()
    var limitModels : [AILimitModel]?
    
    let cellViewHeight : CGFloat = 30

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    func initView(){
        self.backgroundColor = UIColor(patternImage: UIImage(named: "cell_background")!)
        self.clipsToBounds = true
    }
    
    func loadData(models : [AILimitModel]){
        limitModels = models
        buildView()
        //fixFrame()
    }
    
    func refreshLimits(models : [AILimitModel]){
        for (index,cellView) in cellViews.enumerate(){
            cellView.loadData(models[index])
        }
    }
    
    private func buildView(){
        //先清除所有的subView，才能重复构造
        for subView in self.subviews{
            subView.removeFromSuperview()
        }
        cellViews.removeAll()
        if let limitModels = limitModels{
            for (index,limitModel) in limitModels.enumerate(){
                let frame = CGRect(x: 0, y: cellViewHeight * CGFloat(index), width: self.frame.width, height: cellViewHeight)
                let cellView = AILimitCellView(frame: frame)
                cellView.loadData(limitModel)
                self.addSubview(cellView)
                cellViews.append(cellView)
            }
        }
        
    }
    
    func getFrameHeight() -> CGFloat{
        if let lastCellView = cellViews.last{
            return CGRectGetMaxY(lastCellView.frame)
        }
        return 0
    }
    
}

class AILimitCellView: UIView {
    
    var limitModel : AILimitModel?
    
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
    func loadData(limitModel : AILimitModel){
        self.limitModel = limitModel
        updateViewContent()
    }
    
    private func updateViewContent(){
        //TODO 设置为model传入的icon路径
        let url = NSURL(string: (limitModel?.limitIcon)!)
        iconView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Seller_Location")!)
        contentLabel.text = limitModel?.limitName
        //根据是否有权限决定是选中还是未选中
        if let limitModel = limitModel{
            if limitModel.hasLimit {
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
        self.clipsToBounds = true
        buildLeftIcon()
        buildContentLabel()
        buildConfirmView()
        buildSplitLine()
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
        if isSelect{
            confirmView.image = UIImage(named: "Type_On")
        }
        else{
            confirmView.image = UIImage(named: "Type_Off")
        }
    }
}