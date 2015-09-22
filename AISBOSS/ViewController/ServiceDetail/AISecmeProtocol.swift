//
//  AISecmeProtocol.swift
//  AIVeris
//
//  Created by tinkl on 22/9/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

struct chooseItemModel{
    var service_P_id : Int = 0
    var service_id : Int = 0
    var service_price : Float = 0.0

}

protocol AISecmeProtocol {
    
    func chooseItem(model:chooseItemModel)
    
}