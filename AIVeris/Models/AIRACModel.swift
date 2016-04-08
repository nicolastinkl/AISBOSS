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
        
        category = decoder["requirement_category"].string ?? decoder["block_category"].string
         ?? ""
        id = random()/100000000 // identity the cell Cache.
       
        if let category = category {
            
            if category == "tags" || category == "task" {
                type = 2
            }else if category == "message" {
                type = 1
            }else if category == "userData" {
                type = 3
            }else if category == "notes"{
                type = 1
            }
        }
        typeName = decoder["requirement_title"].string ?? decoder["block_title"].string ?? ""
        typeImageUrl = decoder["requirement_category_icon"].string ?? decoder["block_icon"].string ?? ""
        
        if let addrs = decoder["requirements"].array {
            childServices = Array<AIChildContentCellModel>()
            for addrDecoder in addrs {
                var childModel = AIChildContentCellModel(addrDecoder)
                childModel.backImgType = type
                childServices?.append(childModel)
            }
        }
        
    }
    
}



/**
 *  @author tinkl, 16-03-03 14:03:01
 *  内容cell 数据 Model
 */
internal struct AIChildContentCellModel : JSONJoy{
    
    var backImgType: Int? // tags ? notes ? message ？ data?
    var type : Int?  //text or audio
    var audioUrl : String?
    var audioLengh : Int?
    var bgImageUrl : String?
    var title : String?
    var text : String?
    var childServerIconArray : [AIIconTagModel]?
    
    var leftActionImages : [String]?
    var rightActionImages : [String]?
    // add new .
    var requirement_icon : String?
    var requirement_id: String?
    var wish_result_id: String?
    var service_inst_id: String?
    var service_id: String?
    var requirement_type: String?
    
    init() {
        
    }
    
    init(_ decoder: JSONDecoder) {
        
        var holderString = ""
        var holderUrl = ""
        var childServerIcon = ""
        if let requirement = decoder["requirement"].array {
            for requirementAddrDecoder in requirement {
                requirement_id = "\(requirementAddrDecoder["requirement_id"].integer ?? requirementAddrDecoder["id"].integer  ?? 0)"
                wish_result_id = "\(requirementAddrDecoder["wish_result_id"].integer ?? 0)"
                service_inst_id = "\(requirementAddrDecoder["service_instance_id"].integer ?? 0)"
                service_id = "\(requirementAddrDecoder["service_id"].integer ?? 0)"
                
                let desc = requirementAddrDecoder["requirement_desc"].string ?? requirementAddrDecoder["desc"].string ?? ""
                 title = requirementAddrDecoder["title"].string ?? ""
                if holderString == "" {
                    holderString = "\(desc)"
                }else{
                    holderString = "\(holderString)\n\(desc)"
                }
                
                let typeName = requirementAddrDecoder["requirement_type"].string ?? requirementAddrDecoder["type"].string ?? ""
                requirement_type =  typeName
                if typeName == "Text" || typeName == "text" {
                    type = 2
                }else{
                    type = 1
                }
                
                let newrequirement_icon = requirementAddrDecoder["requirement_icon"].string ?? ""
                childServerIcon = requirementAddrDecoder["service_icon"].string ?? ""
                if holderUrl == "" {
                    holderUrl = "\(newrequirement_icon)"
                }else{
                    holderUrl = "\(holderUrl),\(newrequirement_icon)"
                }

                
                if let title = title{
                    // A Audio message.
                    if  title.containsString(".aac") {
                        audioUrl = title
                        audioLengh = 1
                    }
                    
                }
                
            }
        }
        
        text = holderString
        
        requirement_icon = holderUrl

        if let icons = decoder["service_provider_icons"].array {
            childServerIconArray = Array<AIIconTagModel>()
            for addrDecoder in icons {
                var icontag = AIIconTagModel()
                icontag.iconUrl = addrDecoder["icon"].string ?? ""
                icontag.id =  addrDecoder["id"].integer ?? 0
                childServerIconArray?.append(icontag)
            }
        }else{
            childServerIconArray = Array<AIIconTagModel>()
            var icontag = AIIconTagModel()
            icontag.iconUrl = childServerIcon
            childServerIconArray?.append(icontag)
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


