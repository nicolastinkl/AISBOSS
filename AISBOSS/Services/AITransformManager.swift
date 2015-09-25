//
//  AITransformManager.swift
//  AITrans
//
//  Created by Rocky on 15/6/25.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

import Foundation
import AISwiftyJSON

protocol AITransformManager {
    func queryCollectedContents(pageNum: Int, pageSize: Int, tags: [AITagModel]?, origin: String?, favoriteFlag: AIFavoriteStatu?, colorFlags: [AIColorFlag]?, completion: (([AITransformContentModel], Error?)) -> Void)
    
    func deleteContent(contentId: Int, completion: (Error?) -> Void)

    func modifyFavoriteFlag(contentId: Int, favoriteFlag: AIFavoriteStatu, completion: (Error?) -> Void)
    
}

class AIMockTransformManager: AITransformManager {
    
    var contentList: [AITransformContentModel]
    
    init() {
        contentList = [AITransformContentModel]()
        var content = AITransformContentModel()
        content.id = 1
        content.favoriteAvator = "http://www.czgu.com/uploads/allimg/140904/0644594560-0.jpg"
        content.favoriteTitle = "History of Shanghaiy of Shanghai"

        content.favoriteType = FavoriteTypeEnum.music.value()
        content.favoriteFromWhere = "知乎"
        content.colors?.append(AIColorFlag.Red)
        content.favoriteFromWhereURL = "http://www.baidu.com"
        content.favoriteDes = "Shanghai is the largest Chinese city by population and the largest city proper by population in the world. It is one of the four direct-controlled municipalities of the People's Republic of China, with a population of more than 24 million as of 2013. It is a global financial center, and a transport hub with the world's busiest container port. Located in the Yangtze River Delta in East China, Shanghai sits on the south edge of the mouth of the Yangtze in the middle portion of the Chinese coast. The municipality borders the provinces of Jiangsu and Zhejiang to the north, south and west, and is bounded to the east by the East China Sea. of the four direct-controlled municipalities of the People's Republic of China, with a population of more than 24 million as of 2013. It is a global financial center, and a transport hub with the world's busiest container port. Located in the Yangtze River Delta in East China, Shanghai sits on the south edge of the mouth of the Yangtze in the middle portion of the Chinese coast. The municipal of the four direct-controlled municipalities of the People's Republic of China, with a population of more than 24 million as of 2013. It is a global financial center, and a transport hub with the world's busiest container port. Located in the Yangtze River Delta in East China, Shanghai sits on the south edge of the mouth of the Yangtze in the middle portion of the Chinese coast. The municipal of the four direct-controlled municipalities of the People's Republic of China, with a population of more than 24 million as of 2013. It is a global financial center, and a transport hub with the world's busiest container port. Located in the Yangtze River Delta in East China, Shanghai sits on the south edge of the mouth of the Yangtze in the middle portion of the Chinese coast. The municipal"
        contentList.append(content)
        
        
        content = AITransformContentModel()
        content.id = 2
        content.favoriteAvator = "http://brand.gzmama.com/attachments/gzmama/2012/09/8111699_2012091611055819bgd.jpg"
        content.favoriteTitle = "Yogae is a broad variety oaadsafweaq"

        content.favoriteType = FavoriteTypeEnum.video.value()
        content.favoriteFromWhere = "百度"
        content.favoriteFromWhereURL = "http://www.baidu.com"
        content.colors?.append(AIColorFlag.Green)
        content.favoriteDes = "Yoga is a physical, mental, and spiritual practice or discipline which originated in India. There is a broad variety of schools, practices and goals in Hinduism, Buddhism (including Vajrayana and Tibetan Buddhism) and Jainism. The best-known are Hatha yoga and Raja yoga."
        contentList.append(content)
        
        content = AITransformContentModel()
        content.id = 3
        content.favoriteAvator = "http://photocdn.sohu.com/20110809/Img315878985.jpg"
        content.favoriteTitle = "Badminton sport"
        content.favoriteFromWhere = "健身周刊"
        content.favoriteType = FavoriteTypeEnum.image.value()
        content.favoriteFromWhereURL = "http://www.baidu.com"
        content.colors?.append(AIColorFlag.Cyan)
        content.favoriteDes = "Badminton is a racquet sport played by either two opposing players (singles) or two opposing pairs (doubles), who take positions on opposite halves of a rectangular court divided by a net. Players score points by striking a shuttlecock with their racquet so that it passes over the net and lands in their opponents' half of the court. Each side may only strike the shuttlecock once before it passes over the net. A rally ends once the shuttlecock has struck the floor, or if a fault has been called by either the umpire or service judge or, in their absence, the offending player, at any time during the rally."
        contentList.append(content)
        
        
        content = AITransformContentModel()
        content.id = 4
        content.favoriteAvator = "http://hunjia.shangdu.com/file/upload/201403/20/16-39-25-78-972.jpg"
        content.favoriteTitle = "Feast day"
        content.favoriteFromWhere = "米兰"
        content.favoriteType = FavoriteTypeEnum.web.value()
        content.colors?.append(AIColorFlag.Blue)
        content.favoriteFromWhereURL = "http://www.baidu.com"
        content.colors?.append(AIColorFlag.Red)
        content.colors?.append(AIColorFlag.Orange)
        content.favoriteDes = "The calendar of saints is a traditional Christian method of organizing a liturgical year by associating each day with one or more saints and referring to the day as the feast day or feast of said saint. (The word \"feast\" in this context does not mean \"a large meal, typically a celebratory one\", but instead \"an annual religious celebration, a day dedicated to a particular saint\"."
        contentList.append(content)
         
        content = AITransformContentModel()
        content.id = 5
        content.favoriteAvator = "http://photocdn.sohu.com/20110809/Img315878985.jpg"
        content.favoriteTitle = "Badminton sport"
        content.favoriteFromWhere = "伦敦周刊"
        content.favoriteType = FavoriteTypeEnum.image.value()
        content.favoriteFromWhereURL = "http://www.baidu.com"
        content.colors?.append(AIColorFlag.Cyan)
        content.favoriteDes = "Badminton is a racquet sport played by either two opposing players (singles) or two opposing pairs (doubles), who take positions on opposite halves of a rectangular court divided by a net. Players score points by striking a shuttlecock with their racquet so that it passes over the net and lands in their opponents' half of the court. Each side may only strike the shuttlecock once before it passes over the net. A rally ends once the shuttlecock has struck the floor, or if a fault has been called by either the umpire or service judge or, in their absence, the offending player, at any time during the rally."
        contentList.append(content)
        
    }
    
    func queryCollectedContents(pageNum: Int = 1, pageSize: Int = 10, tags: [AITagModel]?, origin: String?, favoriteFlag: AIFavoriteStatu?, colorFlags: [AIColorFlag]?, completion: (([AITransformContentModel], Error?)) -> Void) {
        
        var tempList = [AITransformContentModel]()

        for content in contentList {
            
            if !favoriteFilter(content, favoriteFlag: favoriteFlag) || !colorFilter(content, colorFlags: colorFlags) {
                continue
            }
            
            content.ctExpand = ExpandState.Collapsed
            tempList.append(content)
        }
        
        completion((tempList, nil))
    }
    
    func deleteContent(contentId: Int, completion: (Error?) -> Void) {
        var deleteIndex: Int?
        for var i = 0; i < contentList.count; i++ {
            if contentList[i].id == contentId {
                deleteIndex = i
                break
            }
        }
        
        var result: Error?
        
        if deleteIndex != nil {
            contentList.removeAtIndex(deleteIndex!)
            result = Error(message: "删除成功", code: Error.ResultCode.success.rawValue)
        } else {
            result = Error(message: "删除失败", code: Error.ResultCode.fail.rawValue)
        }
        
        completion(result)
    }

    func modifyFavoriteFlag(contentId: Int, favoriteFlag: AIFavoriteStatu, completion: (Error?) -> Void) {
//        for var i = 0; i < contentList.count; i++ {
//            if contentList[i].id == contentId {
//                contentList[i].isFavorite = favoriteFlag
//                break
//            }
//        }
        
        completion(nil)
    }
    
    /**
    * 按喜好标记过滤内容，true:通过筛选。false:未通过筛选
    */
    private func favoriteFilter(content: AITransformContentModel, favoriteFlag: AIFavoriteStatu?) -> Bool {
        if favoriteFlag != nil {
            if content.isFavorite != favoriteFlag! {
                return false
            }
        }
        return true
    }
    
    private func colorFilter(content: AITransformContentModel, colorFlags: [AIColorFlag]?) -> Bool {
        var result = true
        
        if colorFlags != nil && colorFlags?.count > 0 {
            if content.colors == nil {
                result = false
            } else if content.colors!.count == 0 {
                result = false
            } else {
                result = false
                for color in content.colors! {
                    if result {
                        break;
                    }
                    for tagColor in colorFlags! {
                        if color == tagColor {
                            result = true
                            break
                        }
                    }
                }
            }
        }
        
        return result
    }
}

class AIHttpTransformManager: AIMockTransformManager {
    var isLoading : Bool = false
    
    override func queryCollectedContents(pageNum: Int = 1, pageSize: Int = 10, tags: [AITagModel]?, origin: String?, favoriteFlag: AIFavoriteStatu?, colorFlags: [AIColorFlag]?, completion: (([AITransformContentModel], Error?)) -> Void) {
        
        if isLoading {
            return
        }
        
        var listModel: AIFavoritesContentsResult?
        var responseError: Error?
        
        isLoading = true
        
        var tagArray = [String]()
        
        if tags != nil {
            tagArray = tags!.map({
                obj in
                let item = obj as AITagModel
                return "\(item.toJson())"
            })
        }
        
        let originStr = (origin != nil) ? origin : ""
        let favoFlag = favoriteFlag != nil ? favoriteFlag : AIFavoriteStatu.Indifferent
        var colors = [Int]()
        
        if colorFlags != nil {
            for color in colorFlags! {
                colors.append(color.rawValue)
            }
        }
        
        let paras = [
            "data":[
                "page_no": pageNum,
                "page_size": pageSize,
                "content_tag": tagArray,
                "content_origin": originStr!,
                "content_favorite_flag": favoFlag!.rawValue,
                "content_color_flags": colors
            ],
            "desc":[
                "data_mode": 0,
                "digest": ""
            ]
        ]
        
        AIHttpEngine.postRequestWithParameters(AIHttpEngine.ResourcePath.QueryCollectedContents, parameters: paras) {  [weak self] (response, error) -> () in
            responseError = error
            if let strongSelf = self{
                strongSelf.isLoading = false
            }
            if let responseJSON: AnyObject = response {
                listModel =  AIFavoritesContentsResult(JSONDecoder(responseJSON))
            }
            
            if listModel == nil {
                listModel = AIFavoritesContentsResult()
            }
            
            completion((listModel!.contents, responseError))
        }
    }
    
    override func deleteContent(contentId: Int, completion: (Error?) -> Void) {
        if isLoading {
            return
        }
        
        var responseError: Error?
        
        isLoading = true
        
        let paras = [
            "data":[
                "favorite_id": contentId
            ],
            "desc":[
                "data_mode": 0,
                "digest": ""
            ]
        ]

        
        AIHttpEngine.postRequestWithParameters(AIHttpEngine.ResourcePath.DelContentFromFavorite, parameters: paras) {  [weak self] (response, error) -> () in
            responseError = error
            if let strongSelf = self {
                strongSelf.isLoading = false
            }
            
            completion(responseError)
        }
    }

    override func modifyFavoriteFlag(contentId: Int, favoriteFlag: AIFavoriteStatu, completion: (Error?) -> Void) {
        if isLoading {
            return
        }
        
        var responseError: Error?
        isLoading = true
        
        let paras = [
            "data":[
                "favorite_id": contentId,
                "content_favorite_flag": favoriteFlag.rawValue
            ],
            "desc":[
                "data_mode": 0,
                "digest": ""
            ]
        ]

        AIHttpEngine.postRequestWithParameters(AIHttpEngine.ResourcePath.ModifyFavoriteFlag, parameters: paras) {  [weak self] (response, error) -> () in
            responseError = error
            if let strongSelf = self {
                strongSelf.isLoading = false
            }
            
            completion(responseError)
        }
    }
}