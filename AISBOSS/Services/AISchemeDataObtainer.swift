//
//  AISchemeDataObtainer.swift
//  AIVeris
//
//  Created by Rocky on 15/9/28.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

protocol SchemeDataObtainer {
    func getServiceSchemes(sheme_id: Int, success: (responseData: AIServiceSchemeModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
}

class MockchemeDataObtainer: SchemeDataObtainer {
    func getServiceSchemes(sheme_id: Int, success: (responseData: AIServiceSchemeModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        if let path = NSBundle.mainBundle().pathForResource("AIServiceSchemeModelTEST", ofType: "json") {
            let data: NSData? = NSData(contentsOfFile: path)
            if let dataJSON = data {
                do {
                    let model = try AIServiceSchemeModel(data: dataJSON)
                    success(responseData: model)
                } catch{
                    fail(errType: AINetError.Format, errDes: "AIServiceSchemeModel JSON Parse error.")
                }
            }
        }
        
    }

}

class BDKSchemeDataObtainer:  MockchemeDataObtainer {
    override func getServiceSchemes(sheme_id: Int, success: (responseData: AIServiceSchemeModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message: AIMessage = AIMessageWrapper.getServiceSchemeWithServiceID("\(sheme_id)")
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            do {
                let dic = response as! NSDictionary
                let model = try AIServiceSchemeModel(dictionary: dic as [NSObject : AnyObject])
                print(dic)
                success(responseData: model)
            } catch {
                fail(errType: AINetError.Format, errDes: "AIServiceSchemeModel JSON Parse error.")
            }
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }
    }
}