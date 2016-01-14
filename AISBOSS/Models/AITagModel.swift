//
//  AITagModel.swift
//  AI2020OS
//
//  Created by admin on 15/6/15.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

import SwiftyJSON

class AITagModel: JSONJoy {
    var id: Int?
    var tag_name: String?
    
    init() {
        id = 1
    }
    
    required init(_ decoder: JSONDecoder) {
        
    }
    
    func toJson() -> String{
        let dicData: NSMutableDictionary = NSMutableDictionary()
        if id != nil {
            dicData.setValue(id!, forKey: "tag_id")
        }
        
        if tag_name != nil {
            dicData.setValue(tag_name!, forKey: "tag_name")
        }
        
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dicData, options: NSJSONWritingOptions.PrettyPrinted)
            let jsonStr = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
            return (jsonStr ?? "") as String
            
        }catch {
            
        }
        
        return ""
        
        
    }
    
}
