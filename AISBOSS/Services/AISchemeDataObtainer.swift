//
//  AISchemeDataObtainer.swift
//  AIVeris
//
//  Created by Rocky on 15/9/28.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol SchemeDataObtainer {
    func getServiceSchemes(sheme_id: Int, success: (responseData: AIServiceSchemeModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void)
}

class MockchemeDataObtainer: SchemeDataObtainer {
    func getServiceSchemes(sheme_id: Int, success: (responseData: AIServiceSchemeModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        if let path = NSBundle.mainBundle().pathForResource("AIServiceSchemeModelTEST", ofType: "json") {
            _ = NSData(contentsOfFile: path)
            
        }
        
    }

}

class BDKSchemeDataObtainer:  MockchemeDataObtainer {
    override func getServiceSchemes(sheme_id: Int, success: (responseData: AIServiceSchemeModel) -> Void, fail: (errType: AINetError, errDes: String) -> Void) {
        
        let message: AIMessage = AIMessageWrapper.getServiceSchemeWithServiceID("\(sheme_id)")
        message.url = AIApplication.AIApplicationServerURL.getServiceScheme.description        
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            
            
            if let responseJSON: AnyObject = response {
                let model =  AIServiceSchemeModel(JSONDecoder(responseJSON))
                success(responseData: model)
            }else{
                fail(errType: AINetError.Format, errDes: "AIServiceSchemeModel JSON Parse error.")
            }
            
            }) { (error: AINetError, errorDes: String!) -> Void in
                fail(errType: error, errDes: errorDes)
        }
    }
}