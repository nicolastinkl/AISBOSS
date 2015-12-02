//
//  AIConnectToolModel.swift
//  AITrans
//
//  Created by admin on 6/25/15.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//

import Foundation
import AISwiftyJSON

class AIConnectToolModel : JSONJoy{
    
    var ctType : Int?   // 0 text, 1 image , 2 video , 3  radio
    var ctTitle : String?
    var ctTypeName : String?
    var ctTypeImageNames : [String]?
    var ctContentImageUrl : String?
    var ctContent : String?
    var ctLinkUrl : String?
    var ctExpend : Int?
    
    init(){
        
    }
    
    required init (_ decoder: JSONDecoder) {
        ctType = decoder["ctType"].integer
        ctTitle = decoder["ctTitle"].string
        ctTypeName = decoder["ctTypeName"].string
        ctContentImageUrl = decoder["ctContentImageUrl"].string
        ctContent = decoder["ctContent"].string
        ctLinkUrl = decoder["ctLinkUrl"].string
        
        decoder["ctTypeImageNames"].getArray(&ctTypeImageNames)
        
    }
}