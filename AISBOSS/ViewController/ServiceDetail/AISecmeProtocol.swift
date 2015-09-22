//
//  AISecmeProtocol.swift
//  AIVeris
//
//  Created by tinkl on 22/9/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

struct chooseItemModel{
    var scheme_id : Int = 0
    var scheme_item_id : Int = 0
    var scheme_item_price : Float = 0.0
    var scheme_item_quantity : Int = 0
}

protocol AISchemeProtocol {
    
    func chooseItem(model:chooseItemModel)
    
}