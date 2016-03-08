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
internal struct AIChildContentCellModel : JSONJoy{
    var id: Int?
    var type : Int?  //text or audio
    var audioUrl : String?
    var audioLengh : Int?
    var bgImageUrl : String?
    var text : String?
    var content : String?
    var childServerIconArray : [AIIconTagModel]?
    var leftActionImages : [String]?
    var rightActionImages : [String]?
    
    
    init() {
        id = 1
    }
    
    init(_ decoder: JSONDecoder) {
        
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
    
    init() {
        id = 1
    }
    
    init(_ decoder: JSONDecoder) {
        
    }
    
}


