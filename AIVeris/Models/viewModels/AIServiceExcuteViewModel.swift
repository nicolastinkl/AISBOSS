//
//  AIServiceExcuteModel.swift
//  AIVeris
//
//  Created by 刘先 on 16/5/10.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

//MARK: - view模型
class AIIconLabelViewModel : AIBaseViewModel{
    var labelText : String
    var iconUrl : String
    
    init(labelText : String , iconUrl : String){
        self.labelText = labelText
        self.iconUrl = iconUrl
    }
}