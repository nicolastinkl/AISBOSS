//
//  AIDetailNetService.swift
//  AIVeris
//
//  Created by tinkl on 21/9/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
/*
class AIDetailNetService {
    
    /*!
    获取scheme列表
    
    :param: sheme_id   id
    :param: completion completion
    */
    func requestListServices(sheme_id: Int, completion: (AIServiceSchemeModel) -> Void) {
        
        AINetEngine.defaultEngine().postMessage(AIMessageWrapper.getServiceSchemeWithServiceID("\(sheme_id)"), success: { ([NSObject : AnyObject]!) -> Void in
            
//            if let strongSelf = self{
//                let model =  AIServiceSchemeModel(string: strongSelf.JSON, error:nil)
//                completion(model)
//            }
            
            }) { (error, str) -> Void in
                
        }
        
        if let path = NSBundle.mainBundle().pathForResource("AIServiceSchemeModelTEST", ofType: "json") {
            let data: NSData? = NSData(contentsOfFile: path)
            if let dataJSON = data {
                do {
                    let model2 = try AIServiceSchemeModel(data: dataJSON)
                    completion(model2)
                } catch{
                    print("AIServiceSchemeModel JSON Parse Cash2.")
                }
            }
        }
        
    }
    
}
*/