//
//  AIProviderDataObtainer.swift
//  AIVeris
//
//  Created by Rocky on 15/9/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

protocol ProviderDataObtainer {
    func getOrders(success: (responseData: AIOrderPreListModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
}

class MockProviderDataObtainer: ProviderDataObtainer {
    func getOrders(success: (responseData: AIOrderPreListModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        if let path = NSBundle.mainBundle().pathForResource("ProviderOrdersJsonTest", ofType: "json") {
            let data: NSData? = NSData(contentsOfFile: path)
            if let dataJSON = data {
                do {
                    let model = try AIOrderPreListModel(data: dataJSON)
                    success(responseData: model)
                } catch {
                    print("AIOrderPreListModel JSON Parse err.")
                    fail(errType: AINetError.Format, errDes: "AIOrderPreListModel JSON Parse error.")
                }
            }
        }
    }
}

class BDKProviderDataObtainer: MockProviderDataObtainer {
    override func getOrders(success: (responseData: AIOrderPreListModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message = AIMessage()
        message.url = "http://171.221.254.231:8282/sboss/queryHotSearch"
        
        let body = ["data":["order_role":9],"desc":["data_mode":"0","digest":""]]
        message.body = NSMutableDictionary(dictionary: body)
        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                let model = try AIOrderPreListModel(dictionary: response)
                success(responseData: model)
            } catch {
                fail(errType: AINetError.Format, errDes: "AIOrderPreListModel JSON Parse error.")
            }
            
            }) { (error:AINetError, errorDes:String!) -> Void in
                
                fail(errType: error, errDes: errorDes)
        }
        
    }
}