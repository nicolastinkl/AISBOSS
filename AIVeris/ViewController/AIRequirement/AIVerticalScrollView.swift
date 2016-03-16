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
    
    //position
    let iconWidth : CGFloat = 30
    let iconPaddingTop : CGFloat = 15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadData(models : [IconServiceIntModel]){
        self.models = models
        
        buildIconViews()
        configScrollView()
    }
    
    func buildIconViews(){
        if let models = models {
            let iconX : CGFloat! = CGRectGetMidX(self.bounds) - iconWidth / 2
            for (index,model) in models.enumerate(){
                let frame = CGRect(x: iconX, y:  (iconWidth + iconPaddingTop) * CGFloat(index) + iconPaddingTop, width: iconWidth, height: iconWidth)
                insertIconView(frame,model: model,tag: index)
            }
            
        }
    }
    
    func configScrollView(){
        let finalSize = CGSize(width: self.bounds.width, height: CGFloat(models!.count) * (iconWidth + iconPaddingTop))
        self.contentSize = finalSize
    }
    
    func insertIconView(frame : CGRect , model : IconServiceIntModel , tag : Int){
        let iconView = UIImageView(frame: frame)
        //TODO 这里在正式代码中替换为sdImage加载网络图片
        iconView.image = UIImage(named: "Seller_Warning")
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

