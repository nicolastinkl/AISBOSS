//
//  AIRequirementViewModel.swift
//  AIVeris
//
//  Created by 王坜 on 16/3/30.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//


//MARK: 全局模型




//MARK: 基本信息模型
//进入需求分析界面时，从服务器中获取的数据，包含三个部分。

class AIBusinessInfoModel: AIBaseViewModel {
    
    var serviceModels : [IconServiceIntModel]?
    
    var customerModel : BuyerOrderModel?
    
    var assignServiceInstModels : [AssignServiceInstModel]?
    
    var baseJsonValue : AIQueryBusinessInfos?
}


//MARK: 需求分析界面模型

class AIRequestMentAnalysisModel: AIBaseViewModel {
    
}



//MARK: 待分派需求分析界面模型
class AIRequestMentAssignModel: AIBaseViewModel {
    
}

//MARK: 任务管理界面模型

class AITaskManageModel: AIBaseViewModel {
    
}
