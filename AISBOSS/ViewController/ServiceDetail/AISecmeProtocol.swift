//
//  AISecmeProtocol.swift
//  AIVeris
//
//  Created by tinkl on 22/9/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class chooseItemModel{
    var section_id : Int = 0 //section id
    var scheme_id : Int = 0 //方案ID
    var scheme_item_id : Int = 0 //价格ID
    var scheme_item_price : Float = 0.0 //价格
    var scheme_item_quantity : Int = 0   //量化
}

protocol AISchemeProtocol {
    
    func chooseItem(model: chooseItemModel?, cancelItem: chooseItemModel?)
    
}