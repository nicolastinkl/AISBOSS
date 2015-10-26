//
//  ProposalService.swift
//  AIVeris
//
//  Created by Rocky on 15/10/23.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

protocol ProposalService {
    func getProposalList(success: (responseData: ProposalListModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
}

class MockProposalService {
    func getProposalList(success: (responseData: ProposalListModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        if let path = NSBundle.mainBundle().pathForResource("customerOrderList", ofType: "json") {
            let data: NSData? = NSData(contentsOfFile: path)
            if let dataJSON = data {
                do {
                    let model = try ProposalListModel(data: dataJSON)
                    success(responseData: model)
                    
                    for proposal in model.proposal_order_list {
                        let proposalModel = proposal as! ProposalModel
                        
                        for service in proposalModel.order_list {
                            let serviceOrderModel = service as! ServiceOrderModel
                            
                            for para in serviceOrderModel.param_list {
                                let paraModel = para as! ParamModel
                                
                                if paraModel.param_key == "25043310" {
                                    let s: NSString = paraModel.param_value
                                    let convertString = s.stringByReplacingOccurrencesOfString("\\", withString: "")
                                    print(convertString)
                                    let itemList = GoodsListMode(string: convertString, error: nil)
                                    let model = itemList.item_list.first as! GoodsDetailItemModel
                                    print("list: \(model.item_url)")
                                }
                            }
                            
                        }
                    }
                } catch {
                    print("ProposalListModel JSON Parse err.")
                    fail(errType: AINetError.Format, errDes: "AIOrderPreListModel JSON Parse error.")
                }
            }
        }
    }
}

class BDKProposalService {
    func getProposalList(success: (responseData: ProposalListModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        let message = AIMessage()
        message.url = "http://171.221.254.231:3000/queryCustomerOrderList"
        
        let body = ["data":["order_role":2, "order_state": "0"],"desc":["data_mode":"0","digest":""]]
        message.body = NSMutableDictionary(dictionary: body)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                let dic = response as! [NSObject : AnyObject]
                let model = try ProposalListModel(dictionary: dic)
                success(responseData: model)
            } catch {
                fail(errType: AINetError.Format, errDes: "ProposalListModel JSON Parse error.")
            }
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }

    }
}


