//
//  AIIconLabelView.swift
//  AIVeris
//
//  Created by 刘先 on 16/5/10.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIIconLabelVerticalContainerView: UIView {

    var models : [AIIconLabelViewModel]?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadData(models : [AIIconLabelViewModel]){
        self.models = models
        buildView()
    }
    
    func buildView(){
        guard let models = models else {return}
        var previousSubView : AIIconLabelVerticalView!
        for (index,model) in models.enumerate(){
            let subView = AIIconLabelVerticalView(model: model)
            self.addSubview(subView)
            subView.snp_makeConstraints(closure: { (make) in
                make.leading.trailing.equalTo(self)
                if index == 0{
                    make.top.equalTo(self)
                }
                else{
                    make.top.equalTo(previousSubView.snp_bottom).offset(1)
                    make.height.equalTo(previousSubView)
                }
                if index == models.count - 1{
                    make.bottom.equalTo(self)
                }
                
            })
            previousSubView = subView
        }
    }
    
    func fixFrame(){
        
    }

}

class AIIconLabelVerticalView: UIView {
    
    var model : AIIconLabelViewModel?
    
    //Constants
    let TEXT_FONT = AITools.myriadLightSemiCondensedWithSize(48 / 3)

    
    var iconImageView : UIImageView!
    var labelView : UILabel!
    
    init(){
        super.init(frame: .zero)
        buildView()
    }
    
    convenience init(model : AIIconLabelViewModel){
        self.init()
        loadData(model)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func buildView(){
        iconImageView = UIImageView()
        self.addSubview(iconImageView)
        labelView = UILabel()
        labelView.font = TEXT_FONT
        labelView.textColor = UIColor.whiteColor()
        labelView.textAlignment = NSTextAlignment.Center
        labelView.numberOfLines = 3
        self.addSubview(labelView)
        iconImageView.snp_makeConstraints { (make) in
            make.centerX.top.equalTo(self)
            make.bottom.equalTo(labelView.snp_top).offset(-10)
        }
        labelView.snp_makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
        }
    }
    
    func loadData(model : AIIconLabelViewModel){
        self.model = model
        labelView.text = model.labelText
        //如果文本比较长，就从左边对其
//        if model.labelText.length > 10 {
//            labelView.textAlignment = NSTextAlignment.Left
//        }
        //TODO暂时为了ui效果设置成本地图片
        iconImageView.image = UIImage(named: "se_time_icon_big")
        //iconImageView.sd_setImageWithURL(NSURL(string: model.iconUrl), placeholderImage: UIImage(named: "icon_price_big"))    
    }
}