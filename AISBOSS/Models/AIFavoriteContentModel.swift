//
//  AIFavoriteContentModel.swift
//  AI2020OS
//
//  Created by tinkl on 10/6/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import AISwiftyJSON


enum ExpandState {
    case Expanded
    case Collapsed
}

enum FavoriteTypeEnum: Int{
    case web  = 1
    case video  = 2
    case image  = 3
    case music   = 4
    
    func value() -> Int{
        switch self
        {
            case .web:
                return 1
            
            case .video:
                return 2
            
            case .image:
                return 3
            
            case .music:
                return 4
            
            default:
                break
        }
        return 0
    }
    
    
}

enum AIFavoriteStatu: Int {
    case Favorite = 2
    case Unfavorite = 0
    case Indifferent = -1
}

enum AIColorFlag: Int {
    case Red = 1, Orange, Cyan, Green, Blue
    case Unknow = -1
    case Favorite = 999
    
    func intValue() -> Int{
        if self == AIColorFlag.Red {
            return 1
        }
        if self == AIColorFlag.Orange {
            return 2
        }
        if self == AIColorFlag.Cyan {
            return 3
        }
        if self == AIColorFlag.Green {
            return 4
        }
        if self == AIColorFlag.Blue {
            return 5
        }
        return -1
    }
    
}

class AIFavoriteContentModel: JSONJoy {
 
    var id = 0
    var favoriteTitle : String?
    var favoriteDes : String?
    var favoriteFromWhere : String?
    var favoriteFromWhereURL : String?  /// 点击跳转链接
    var favoriteAvator : String?
    var favoriteCurrentTag : String?
    var favoriteType : Int?             //类型 (video txt music)
    var isFavorite : AIFavoriteStatu?
    var favoriteTags: Array<String>?
    var serverList: Array<AIServiceTopicModel>?
    var cellName:String = "MainCell"
    var isAttached:Bool = false
    var content_url : String?   //多媒体链接
    init(){
        isFavorite = AIFavoriteStatu.Indifferent
    }
    
    required init(_ decoder: JSONDecoder) {
        favoriteTitle = decoder["title"].string
        favoriteDes = decoder["des"].string
        favoriteFromWhere = decoder["from"].string
        favoriteAvator = decoder["avator"].string
        isFavorite = AIFavoriteStatu(rawValue: decoder["isfav"].integer!)
        favoriteType = decoder["type"].integer
        favoriteFromWhereURL = decoder["fromurl"].string
        content_url = decoder["content_url"].string
        decoder.getArray(&favoriteTags)
        
        if let sparam = decoder["service_param_list"].array {
            serverList = Array<AIServiceTopicModel>()
            for serviceParam in sparam {
                serverList?.append(AIServiceTopicModel(serviceParam))
            }
        }
    }

}

class AITransformContentModel: AIFavoriteContentModel {
 //   var favoriteFlag = AIFavoriteStatu.Indifferent
    var colors: [AIColorFlag]?
    var ctExpand = ExpandState.Collapsed
    
    override init() {
        super.init()
        colors = []
    }
    
    required init(_ decoder: JSONDecoder) {
        super.init()
        if let favoId = decoder["favorite_id"].integer  {
            id = favoId
        }
        favoriteTitle = decoder["content_title"].string
        favoriteDes = decoder["content_intro"].string
        favoriteFromWhere = decoder["content_origin"].string
        favoriteAvator = decoder["content_thumbnail_url"].string
        isFavorite = AIFavoriteStatu(rawValue: decoder["content_favorite_flag"].integer!)
        favoriteType = decoder["content_type"].integer


        decoder.getArray(&favoriteTags)
        decoder.getArray(&colors)

    }
}

class AIFavoritesContentsResult: JSONJoy {
    var contents = [AITransformContentModel]()
    
    init() {
        
    }
    
    required init(_ decoder: JSONDecoder) {
        if let jsonArray = decoder["collected_contents"].array {
            for subDecoder in jsonArray {
                contents.append(AITransformContentModel(subDecoder))
            }
        }
    }
}