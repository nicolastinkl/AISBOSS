//
//  AISecmeProtocol.swift
//  AIVeris
//
//  Created by tinkl on 22/9/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class chooseItemModel{
    var service_P_id : Int
    var service_id : Int
    var service_price : Float

}


protocol AISecmeProtocol {
    
    func chooseItem(model:chooseItemModel)
    
}