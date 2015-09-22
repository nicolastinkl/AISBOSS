//
//  AIProviderDataObtainer.swift
//  AIVeris
//
//  Created by Rocky on 15/9/22.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

protocol ProviderDataObtainer {
    func getOrders() -> [AIOrderPreListModel]
}

class MockProviderDataObtainer: ProviderDataObtainer {
    func getOrders() -> [AIOrderPreListModel] {
        /*
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
*/
        return []
    }
}