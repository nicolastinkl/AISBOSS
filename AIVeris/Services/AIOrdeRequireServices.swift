//
//  AIOrdeRequireServices.swift
//  AIVeris
//
//  Created by tinkl on 3/14/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

struct AIOrdeRequireServices {
    
    func requestChildServices(contentModel : AIChildContentCellModel, completionss: ([AIIconTagModel] -> Void)){
        
        Async.main(after: 0.1) { () -> Void in
            
            var i1 = AIIconTagModel()
            i1.iconUrl = "http://171.221.254.231:3000/upload/proposal/3e7Sx8n4vozQj.png"
            i1.content = "2. Maternity Consulting - Music Theray"
            
            var i2 = AIIconTagModel()
            i2.iconUrl = "http://171.221.254.231:3000/upload/proposal/LATsJIV2vKdgp.png"
            i2.content = "2. Paramedk Cleaner"
            
            var i3 = AIIconTagModel()
            i3.iconUrl = "http://171.221.254.231:3000/upload/proposal/LATsJIV2vKdgp.png"
            i3.content = "3. Paramedk Cleaner"
            // [i1,i2],Error(message: "", code: 0)
            // let error = Error(message: "", code: 0)
            // completion([i1,i2], error)
            completionss([i1,i2,i3])
        }
        
        
    }
    
}