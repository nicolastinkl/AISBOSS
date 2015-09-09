//
//  AIFavorServicesManager.swift
//  AI2020OS
//  收藏服务接口
//
//  Created by liliang on 15/6/9.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import AISwiftyJSON

protocol AIFavorServicesManager {
    // 获取收藏服务列表
    func getFavoriteServices(pageNum: Int, pageSize: Int, tags: [AITagModel], completion: (([AIServiceTopicModel], Error?)) -> Void)
    // 改变收藏服务的状态。 状态：是否是我喜欢的
    func changeFavoriteServiceState(isFavor: Bool, completion: (Error?) -> Void)
    // 获取收藏服务标签
    func getServiceTags(completion: (([String], Error?)) -> Void)
}

class AIMockFavorServicesManager : AIFavorServicesManager {
    
    private var favorServices = [AIServiceTopicModel]()
    private var tags = NSMutableSet()
    
    init() {
        var service = AIServiceTopicModel()
        service.service_name = "去上海出差"
        service.service_thumbnail_url = "http://www.czgu.com/uploads/allimg/140904/0644594560-0.jpg"
        service.contents.append("机票")
        service.contents.append("住宿")
        service.contents.append("接机")
        service.contents.append("宠物寄养")
        service.isFavor = true
        service.tags.append("工作")
        
        favorServices.append(service)
        tags.addObject(service.tags[0])
        
        service = AIServiceTopicModel()
        service.service_name = "做个柔软的胖子"
        service.service_thumbnail_url = "http://brand.gzmama.com/attachments/gzmama/2012/09/8111699_2012091611055819bgd.jpg"
        service.contents.append("场地")
        service.contents.append("瑜伽教练")
        service.isFavor = false
        service.tags.append("健身")
        favorServices.append(service)
        tags.addObject(service.tags[0])
        
        service = AIServiceTopicModel()
        service.service_name = "周末打羽毛球"
        service.service_thumbnail_url = "http://photocdn.sohu.com/20110809/Img315878985.jpg"
        service.contents.append("场地")
        service.contents.append("教练")
        service.isFavor = true
        service.tags.append("健身")
        favorServices.append(service)
        tags.addObject(service.tags[0])
        
        service = AIServiceTopicModel()
        service.service_name = "家宴"
        service.service_thumbnail_url = "http://hunjia.shangdu.com/file/upload/201403/20/16-39-25-78-972.jpg"
        service.contents.append("大厨")
        service.contents.append("食物代购")
        service.isFavor = false
        service.tags.append("生活")
        favorServices.append(service)
        tags.addObject(service.tags[0])
        
        service = AIServiceTopicModel()
        service.service_name = "同学聚会"
        service.service_thumbnail_url = "http://photocdn.sohu.com/20150603/mp17561615_1433325849459_1.jpeg"
        service.contents.append("场地")
        service.contents.append("食物代购")
        service.contents.append("代驾")
        service.contents.append("专车")
        service.isFavor = true
        service.tags.append("生活")
        favorServices.append(service)
        tags.addObject(service.tags[0])
    }
    
    func getFavoriteServices(pageNum: Int, pageSize: Int, tags: [AITagModel], completion: (([AIServiceTopicModel], Error?)) -> Void) {
        
        
        if tags.count == 0 {
            completion((favorServices, nil))
            return
        }
        
        var tempList = [AIServiceTopicModel]()
        
        for service in favorServices {
            
            for tag in service.tags {
                
                func isInTags(srcTagName: String, desTags: [AITagModel]) -> Bool {
                    if desTags.count == 0 {
                        return false
                    } else {
                        for tag in desTags {
                            if tag.tag_name == srcTagName {
                                return true
                            }
                        }
                        
                        return false
                    }
                }
                
                if isInTags(tag, desTags: tags) {
                    tempList.append(service)
                    break
                }
            }
        }
        
        completion((tempList, nil))
    }
    
    func queryFavoriteServices(tags: [String], completion: (([AIServiceTopicModel], Error?)) -> Void) {
        
        var tempList = [AIServiceTopicModel]()
        
        for service in favorServices {
                
            for tag in service.tags {
                
                func isInTags(srcTag: String, desTags: [String]) -> Bool {
                    if desTags.count == 0 {
                        return false
                    } else {
                        for tag in desTags {
                            if tag == srcTag {
                                return true
                            }
                        }
                        
                        return false
                    }
                }
                
                if isInTags(tag, desTags: tags) {
                    tempList.append(service)
                    break
                }
            }
        }
        
        completion((tempList, nil))
        
    }
    
    func changeFavoriteServiceState(isFavor: Bool, completion: (Error?) -> Void) {
        
    }
    
    func getServiceTags(completion: (([String], Error?)) -> Void) {
        
        var tagList = [String]()
        
        for obj in tags.allObjects {
            tagList.append(obj as! String)
        }
        
        completion((tagList, nil))
    }
    
}

class AIHttpFavorServicesManager : AIMockFavorServicesManager {
    
    var isLoading : Bool = false
    
    override func getFavoriteServices(pageNum: Int, pageSize: Int, tags: [AITagModel], completion: (([AIServiceTopicModel], Error?)) -> Void) {
        if isLoading {
            return
        }
        
        var listModel: AIFavoritesServicesResult?
        var responseError:Error?
        
        isLoading = true
        
        let arrayString: [String] = tags.map({
            obj in
            let item = obj as AITagModel
            return "\(item.toJson())"
        })
        
        let paras = [
            "data":[
                "page_no": pageNum,
                "page_size": pageSize,
                "service_tags": arrayString
            ],
            "desc":[
                "data_mode": 0,
                "digest": ""
            ]
        ]
     
        AIHttpEngine.postRequestWithParameters(AIHttpEngine.ResourcePath.QueryCollectedServices, parameters: paras) {  [weak self] (response, error) -> () in
            responseError = error
            if let strongSelf = self{
                strongSelf.isLoading = false
            }
            if let responseJSON: AnyObject = response {
                listModel =  AIFavoritesServicesResult(JSONDecoder(responseJSON))
            }
            
            if listModel == nil {
                listModel = AIFavoritesServicesResult()
            }
            
            completion((listModel!.services, responseError))
        }

    }

    override func getServiceTags(completion: (([String], Error?)) -> Void) {
        if isLoading {
            return
        }
        
        var listModel: AIFavoritesServiceTagsResult?
        var responseError:Error?
        
        isLoading = true
        
        AIHttpEngine.postRequestWithParameters(AIHttpEngine.ResourcePath.QueryServiceTags, parameters: ["":""]) {  [weak self] (response, error) -> () in
            responseError = error
            if let strongSelf = self{
                strongSelf.isLoading = false
            }
            if let responseJSON: AnyObject = response {
                listModel =  AIFavoritesServiceTagsResult(JSONDecoder(responseJSON))
            }
            
            if listModel == nil {
                listModel = AIFavoritesServiceTagsResult()
            }
            
            completion((listModel!.tags, responseError))
        }
    }
}