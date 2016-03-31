//
//  VerticalScrollView.swift
//  MyWholeDemos
//
//  Created by 刘先 on 16/3/11.
//  Copyright © 2016年 wantsor. All rights reserved.
//

import Foundation
import UIKit

class AIVerticalScrollView: UIScrollView {
    
    var iconViews = [UIView]()
   
    var models : [IconServiceIntModel]?
    var myDelegate : VerticalScrollViewDelegate?
    //全选按钮
    var checkAllView : UIImageView!
    var isSelectAll = false
    let checkAllIcon = UIImage(named: "checkall")
    let unCheckAllIcon = UIImage(named: "checkall")
    
    //position
    let iconWidth : CGFloat = 86 / 3
    let iconPaddingTop : CGFloat = 12 //8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadData(models : [IconServiceIntModel]){
        self.models = models
        buildCheckAllView()
        buildIconViews()
        configScrollView()
    }
    
    func buildCheckAllView(){
        let iconX : CGFloat! = CGRectGetMidX(self.bounds) - iconWidth / 2
        let frame = CGRect(x: iconX, y:  0 + iconPaddingTop, width: iconWidth, height: iconWidth)
        checkAllView = UIImageView(frame: frame)
        
        //TODO 这里还要等市场部输出图
        checkAllView.image = checkAllIcon
        //增加全选事件
        let tapGuesture = UITapGestureRecognizer(target: self, action: "checkAllAction:")
        checkAllView.userInteractionEnabled = true
        checkAllView.addGestureRecognizer(tapGuesture)
        self.addSubview(checkAllView)
    }
    
    func checkAllAction(sender : AnyObject){
        isSelectAll = !isSelectAll
        if isSelectAll{
            checkAllView.image = checkAllIcon
        }
        else{
            checkAllView.image = unCheckAllIcon
        }
        for iconView in iconViews{
            let subViews = iconView.subviews.filter({ (subView) -> Bool in
                subView.isKindOfClass(AICircleProgressView)
            })
            if let circleView = subViews.first as? AICircleProgressView{
                circleView.changeSelect(isSelectAll)
            }
        }
    }
    
    func buildIconViews(){
        if let models = models {
            let iconX : CGFloat! = CGRectGetMidX(self.bounds) - iconWidth / 2
            for (index,model) in models.enumerate(){
                let frame = CGRect(x: iconX, y:  (iconWidth + iconPaddingTop) * CGFloat(index+1) + iconPaddingTop, width: iconWidth, height: iconWidth)
                insertIconView(frame,model: model,tag: index)
            }
            
        }
    }
    
    func configScrollView(){
        let finalSize = CGSize(width: self.bounds.width, height: CGFloat(models!.count + 1) * (iconWidth + iconPaddingTop))
        self.contentSize = finalSize
    }
    
    func insertIconView(frame : CGRect , model : IconServiceIntModel , tag : Int){
        let iconView = UIImageView(frame: frame)
        //TODO 这里在正式代码中替换为sdImage加载网络图片
        let url = NSURL(string: model.serviceIcon)
        iconView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Seller_Image2")!)
        iconView.backgroundColor = UIColor.clearColor()
        iconView.tag = tag
        self.addSubview(iconView)
        //进度条
        iconView.userInteractionEnabled = true
        
        let circleProgressView = AICircleProgressView(frame: iconView.bounds)
        circleProgressView.refreshProgress(CGFloat(model.executeProgress)/10)
        circleProgressView.delegate = self
        iconView.addSubview(circleProgressView)
        
        iconViews.append(iconView)
         
        if model.serviceInstStatus == 0 {
            //  为选中
            circleProgressView.changeSelect(false)
        }else{
            //  选中            
            circleProgressView.changeSelect(true)
        }
        
    }
    
    //让外部获取当前选中的信息
    func getSelectedModels() -> [IconServiceIntModel]{
        var selectedModels = [IconServiceIntModel]()
        if let models = models {
            for model in models{
                if model.isSelected{
                    selectedModels.append(model)
                }
            }
        }
        return selectedModels
    }
}

extension AIVerticalScrollView : CircleProgressViewDelegate{
    
    func viewDidSelect(circleView : AICircleProgressView){
        for (index,iconView) in iconViews.enumerate(){
            if circleView.superview! == iconView {
                if let models = models {
                    models[index].isSelected = circleView.isSelect
                }
                if let myDelegate = myDelegate{
                    myDelegate.viewCellDidSelect(self, index: index, cellView: iconView)
                }
                
                break
            }
        }
        
    }
}

//MARK: - delegate，处理选中事件
protocol VerticalScrollViewDelegate {
    
    func viewCellDidSelect(verticalScrollView : AIVerticalScrollView , index : Int , cellView : UIView)
}

