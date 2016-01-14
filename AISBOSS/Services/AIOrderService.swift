//
//  AIOrderService.swift
//  AI2020OS
//
//  Created by 刘先 on 15/5/28.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import SwiftyJSON

class AIOrderRequester {
    typealias OrderListRequesterCompletion = (data:[AIOrderListItemModel]) ->()
    private var isLoading : Bool = false
    
    func submitProposalOrder(proposalId: Int, success: () -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        message.url = AIApplication.AIApplicationServerURL.submitProposalOrder.description
        let body = ["data": ["proposal_id": proposalId], "desc": ["data_mode": "0", "digest": ""]]
        
        message.body = NSMutableDictionary(dictionary: body)
        AINetEngine.defaultEngine().postMessage(message, success: {(response) -> Void in
            success()            
            
            }) {(error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes ?? "")
        }
    }
    
    //查询订单列表 
    func queryOrderList(page :Int=1,completion:OrderListRequesterCompletion){
        
        if isLoading {
            return
        }
        isLoading = true
        
        AIHttpEngine.postRequestWithParameters(AIHttpEngine.ResourcePath.GetOrderList, parameters: ["page_num":"1","order_role":1]) {  [weak self] (response, error) -> () in
            if let strongSelf = self{
                strongSelf.isLoading = false
            }
            
            func fakeData() -> [AIOrderListItemModel]{

                let json = "[{order_id:5,order_number:12345}]"
                let data = NSString(string: json).dataUsingEncoding(NSUTF8StringEncoding)
                
                //let responseJSONS = "[{\"order_id\": 1001,\"order_number\": \"2015052811234\",\"order_state\":\"3\",\"order_state_name\":\"待处理\",\"order_create_time\": \"2015-5-23 15:30\",\"service_id\":\"1002\",\"service_name\":\"地陪小王\",\"provider_id\":\"1003\",\"service_type\":1,\"provider_portrait_url\":\"http://xxxx/image\",\"service_time_duration\":\"3月１７日－３月２２日\"}]"
                let orders =  AIOrderListModel(JSONDecoder(data as! AnyObject))
                return orders.orderArray!
            }
                        if let responseJSON: AnyObject = response{
                let orders =  AIOrderListModel(JSONDecoder(responseJSON))
                completion(data: orders.orderArray!)
            }else{
             
                if let _ = self{
                    return completion(data: fakeData())
                }
                else{
                    return completion(data:[])
                }
                
            }
        }
    }
    
    
}