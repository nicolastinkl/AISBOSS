//
//  AIServiceParamView.swift
//  AIVeris
//
//  Created by 王坜 on 16/1/20.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation


enum AIServiceDetailDisplayType : String {
    case Input =                  "Input"          // 输入控件
    case TitleLabel =             "TitleLabels"    // 彩色标签
    case Price =                  "Price"          // 价格
    case TextDetail =             "TextDetail"     // 描述信息
    case SingalOption =           "SingalOption"   // 单选
    case ComplexLabel =           "ComplexLabel"   // 复合标签组
    case Picker =                 "Picker"         // pick选择
    case Calendar =               "Calendar"       // 日历
    case Services =               "Services"       // 切换服务商
}


class AIServiceParamView : UIView {
    
    
    //MARK: Constants
    
    
    //MARK: Variables
    
    
    //MARK: Override
    
    init(params: [AIServiceDetailDisplayModel]?) {
        super.init(frame: CGRectZero)
        //super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: Method

    //MARK: 解析数据模型
    func parseModel(models : [AIServiceDetailDisplayModel]?) {
        guard let _ = models else {
            return
        }
        
        
        
        
        
    }
    
}