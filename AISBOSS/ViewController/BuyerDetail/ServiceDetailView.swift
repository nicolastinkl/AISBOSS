//
//  ServiceView.swift
//  AIVeris
//
//  Created by Rocky on 15/11/6.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class ServiceParamlView: UIView {

    var paramData : NSDictionary?
    
    func loadData(paramData : NSDictionary) {
        self.paramData = paramData
    }

    func getStringContent(key : String) -> String {
        var str: String = ""
        
        if let data = paramData {
            let s = data.valueForKey(key) as? String
            if s != nil {
                str = s!
            }
        }
        
        return str
    }
    
    func loadData(json jonsStr: String) {
        
    }

}

