//
//  AIServiceDetailTool.swift
//  AIVeris
//
//  Created by Rocky on 15/12/16.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIServiceDetailTool {
    func findParamRelated(service: AIProposalServiceDetailModel, selectedParamValue: AIProposalServiceDetailParamValueModel) -> AIProposalServiceParamRelationModel? {
        guard let relations = service.service_param_rel_list else {
            return nil
        }
        
        var result: AIProposalServiceParamRelationModel?
        
        for item in relations {
            let relation = item as! AIProposalServiceParamRelationModel
            
            if selectedParamValue.id == relation.param.param_key {
                result = relation
            }
        }
        
        return result
    }
}