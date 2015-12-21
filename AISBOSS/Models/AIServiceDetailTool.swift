//
//  AIServiceDetailTool.swift
//  AIVeris
//
//  Created by Rocky on 15/12/16.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIServiceDetailTool: NSObject {
    static let MUSIC_SERVICE_ID: Int = 900001001000
    static let PARAMEDIC_SERVICE_ID: Int = 900001001003
    
    static func findParamRelated(service: AIProposalServiceDetailModel, selectedParamValue: AIProposalServiceDetailParamValueModel) -> AIProposalServiceParamRelationModel? {
        guard let relations = service.service_param_rel_list else {
            return nil
        }
        
        var result: AIProposalServiceParamRelationModel?
        
        for item in relations {
            let relation = item as! AIProposalServiceParamRelationModel
            
            if selectedParamValue.id == relation.param.param_value_key {
                result = relation
                break
            }
        }
        
        return result
    }
    
    static func createServiceSubmitModel(service: AIProposalServiceDetailModel, relation: AIProposalServiceParamRelationModel) -> JSONModel? {
        var data: JSONModel?
        
        let paramKey = relation.rel_param.param_key
        
        for item in service.service_param_list {
            let param = item as! AIProposalServiceDetailParamModel
            
            if param.param_key == paramKey {
                if param.param_source == "product" {
                    let productParam = AIProductParamItem()
                    productParam.product_id = "\(param.param_source_id)"
                    productParam.service_id = "\(service.service_id)"
                    productParam.role_id = "\(relation.rel_param.param_role)"
                    productParam.name = relation.rel_param.param_value
                    
                    data = productParam
                } else if param.param_source == "product_param" {
                    let serviceParam = AIServiceParamItem()
                    serviceParam.source = param.param_source
                    serviceParam.product_id = "\(param.param_source_id)"
                    serviceParam.service_id = "\(service.service_id)"
                    serviceParam.role_id = "\(relation.rel_param.param_role)"
                    serviceParam.param_key = "\(paramKey)"
                    serviceParam.param_value_id = [relation.param.param_value_key]
                    serviceParam.param_value = [relation.rel_param.param_value]
                    
                    data = serviceParam
                }
            }
        }
        
        return data
    }
    
    static func createServiceSubmitModel(service: AIProposalServiceDetailModel, param: AIProposalServiceDetailParamModel, paramContentDic: [String : AIProposalServiceDetailParamValueModel]) -> JSONModel? {
        var data: JSONModel?
        
        if param.param_source == "offering_param" {
            let serviceParam = AIServiceParamItem()
            serviceParam.source = param.param_source
            serviceParam.product_id = "\(param.param_source_id)"
            serviceParam.service_id = "\(service.service_id)"
            serviceParam.param_key = "\(param.param_key)"
            
            var values = [String]()
            
            for value in paramContentDic.values {
                values.append(value.content)
            }
            
            serviceParam.param_value = values
            
            data = serviceParam
        }
        
        return data
    }
}