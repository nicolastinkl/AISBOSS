//
//  AIRACModel.swift
//  AIVeris
//
//  Created by tinkl on 3/2/16.
//  Base on Tof Templates
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

// MARK: -
// MARK: AIRACModel
// MARK: -
internal struct AIRACModel : JSONJoy {
    var id: Int?
    
    init() {
        id = 1
    }
    
    init(_ decoder: JSONDecoder) {
        
    }
}


// MARK: -
// MARK: AILeftMenuModel 主要功能导航 列表 数据model
// MARK: -
internal struct AILeftMenuModel : JSONJoy {
    var id: Int?
    var type : Int?
    var selected : Bool? = false
    var iconUrl : String?
    
    
    init() {
        id = 1
    }
    
    init(_ decoder: JSONDecoder) {
        
    }
    
}

/**
 *  @author tinkl, 16-03-03 14:03:01
 *  内容cell 数据 Model
 */
internal struct AIContentCellModel : JSONJoy{
    var id: Int?
    var type : Int?  // tag  note message ...
    var typeName : String?
    var typeImageUrl : String?
    var childServices : [AIChildContentCellModel]?
    var category : String?
    
    init() {
        id = 1
    }
    
    init(_ decoder: JSONDecoder) {
        
        category = decoder["requirement_category"].string ?? ""
        let requirement_category = decoder["requirement_category"].string ?? ""
        id = 1

        if requirement_category == "tags" || requirement_category == "notes" || requirement_category == "task" {
            type = 2
        }else if requirement_category == "message" {
            type = 1
        }else if requirement_category == "data" {
            type = 3
        }else{
            type = 2
        }
        
        
        typeName = decoder["requirement_title"].string ?? ""
        typeImageUrl = decoder["requirement_category_icon"].string ?? ""
        
        if let addrs = decoder["requirements"].array {
            childServices = Array<AIChildContentCellModel>()
            for addrDecoder in addrs {
                childServices?.append(AIChildContentCellModel(addrDecoder))
            }
        }
        
    }
    
}



/**
 *  @author tinkl, 16-03-03 14:03:01
 *  内容cell 数据 Model
 */
internal struct AIChildContentCellModel : JSONJoy{
    var id: Int?
    var type : Int?  //text or audio
    var audioUrl : String?
    var audioLengh : Int?
    var bgImageUrl : String?
    var text : String?      //title
    var content : String?   //content
    var childServerIconArray : [AIIconTagModel]?
    var leftActionImages : [String]?
    var rightActionImages : [String]?
    var requirement_icon : String?
    var requirement_id: String?
    init() {
        id = 1
    }
    
    init(_ decoder: JSONDecoder) {
        
        var holderString = ""
        var holderUrl = ""
        if let requirement = decoder["requirement"].array {
            for requirementAddrDecoder in requirement {
                requirement_id = requirementAddrDecoder["requirement_id"].string ?? ""
                let desc = requirementAddrDecoder["requirement_desc"].string ?? ""
                if holderString == "" {
                    holderString = "\(desc)"
                }else{
                    holderString = "\(holderString)\n\(desc)"
                }
                
                let typeName = requirementAddrDecoder["requirement_type"].string ?? ""
                if typeName == "text" {
                    type = 2
                }else{
                    type = 1
                }
                
                let newrequirement_icon = requirementAddrDecoder["requirement_icon"].string ?? ""
                
                if holderUrl == "" {
                    holderUrl = "\(newrequirement_icon)"
                }else{
                    holderUrl = "\(holderUrl),\(newrequirement_icon)"
                }

                
            }
        }
        
        text = holderString
        requirement_icon = holderUrl

        
        if let icons = decoder["service_provider_icons"].array {
            childServerIconArray = Array<AIIconTagModel>()
            for addrDecoder in icons {
                var icontag = AIIconTagModel()
                icontag.iconUrl = addrDecoder.string ?? ""
                childServerIconArray?.append(icontag)
            }
        }
        
        
    }
    
}

/**
 *  @author tinkl, 16-03-03 14:03:51
 *
 *  子服务列表model
 */
internal struct AIIconTagModel : JSONJoy{
    var id: Int?
    var iconUrl : String?
    var content : String?
    var hasSelected : Bool?
    
    init() {
        id = 1
    }
    
    init(_ decoder: JSONDecoder) {
        
    }
    
}


