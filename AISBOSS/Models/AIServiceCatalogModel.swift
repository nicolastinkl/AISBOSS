//
//  ServiceCatalogModel.swift
//  AI2020OS
//
//  Created by admin on 15/5/29.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import AISwiftyJSON

struct AICatalogListModel : JSONJoy {
    var catalogArray = Array<AICatalogItemModel>()
    init() {

    }
    
    init(_ decoder: JSONDecoder) {
        
        if var jsonArray = decoder["catalog_list"].array {
            catalogArray = Array<AICatalogItemModel>()
            for subDecoder in jsonArray {
                catalogArray.append(AICatalogItemModel(subDecoder))
            }
        }
    }
}

struct AICatalogItemModel : JSONJoy{

    var catalog_id : Int?
    var catalog_name : String?
    var level: Int?
    var has_children: Bool?
    var parent_id: Int?
    
    init(){
        
    }
    
    init(_ decoder: JSONDecoder) {
        catalog_id = decoder["catalog_id"].integer
        catalog_name = decoder["catalog_name"].string
        level = decoder["level"].integer
        has_children = decoder["has_children"].bool
        parent_id = decoder["parent_id"].integer
    }
}