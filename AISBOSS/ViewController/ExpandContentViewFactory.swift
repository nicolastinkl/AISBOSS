//
//  ExpandContentViewFactory.swift
//  AIVeris
//
//  Created by Rocky on 15/10/26.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit


class ServiceOrderExpandContentViewFactory {
    static func createExpandContentView(param: InfoDetailModel) -> UIView? {
        var contentView: UIView?
        if param.type == 25043309 {
            let expandContent = ImageContent(frame: CGRect(x: 0, y: 0, width: 0, height: 180))
            
            expandContent.imgUrl = param.content
            
            contentView = expandContent
        } else if param.type == 25043310 {
            let expandContent = AIOrderCellEShopView(frame: CGRect(x: 0, y: 0, width: 0, height: 200))
            
            let s: NSString = param.content
            let convertString = s.stringByReplacingOccurrencesOfString("\\", withString: "")
            print(convertString)
            let itemList = GoodsListMode(string: convertString, error: nil)
            expandContent.goodsList = itemList
            contentView = expandContent
        }
        
        return contentView

    }
}