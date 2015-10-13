//
//  AICustomerModels.swift
//  AITrans
//
//  Created by 刘先 on 15/7/16.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

import Foundation
import AISwiftyJSON

struct AICustomerServiceSolutionModel : JSONJoy {
    var service_id : Int?
    var service_name : String?
    var service_total_cost : String?
    var service_order_mount : Int?
    var service_source : String?
    var service_price : String?
    var service_items : [AICustomerServiceSolutionItemModel]?
    var service_flag : Int?
    var service_cells : NSArray?    
    var is_comp_service : Int?
    
    init(){
        
    }
    
    init(_ decoder: JSONDecoder) {
        
    }
}


struct AICustomerServiceSolutionCellsModel {
    
}




struct AICustomerServiceSolutionItemModel : JSONJoy {
    var status : Int?
    var service_content : String?
    var provider_portrait_url : String?
    
    init(){
        
    }
    
    init(_ decoder: JSONDecoder) {
        
    }
}

enum AICustomerFilterFlag: Int {
    case Timer = 1, Favorite, CompService
    case Unknow = -1
    
    func intValue() -> Int{
        if self == AICustomerFilterFlag.Timer {
            return 1
        }
        if self == AICustomerFilterFlag.Favorite {
            return 2
        }
        if self == AICustomerFilterFlag.CompService {
            return 3
        }
        return -1
    }
    
}
