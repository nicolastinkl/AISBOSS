//
//  AIOrderDetailService.swift
//  AI2020OS
//
//  Created by 郑鸿翔 on 15/5/30.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import AISwiftyJSON


class AIOrderDetailRequester {
    typealias OrderDetailRequesterCompletion = (data:OrderDetailModel,error:Error?) ->()
    private var isLoading : Bool = false
    
    //查询订单详情
    func queryOrderDetail(completion:OrderDetailRequesterCompletion){
        
        if isLoading {
            return
        }
        isLoading = true
        
        AIHttpEngine.postRequestWithParameters(AIHttpEngine.ResourcePath.GetOrderDetail,
            parameters: ["order_id":1]) {
            [weak self] (response, error) -> () in
            if let strongSelf = self{
                strongSelf.isLoading = false
            }
            
            
            if let responseJSON: AnyObject = response{
                let orderDetail =  OrderDetailModel(JSONDecoder(responseJSON))
                completion(data: orderDetail, error: error)
            }

        }
    }
    
    
}


