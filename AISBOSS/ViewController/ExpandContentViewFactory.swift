//
//  ExpandContentViewFactory.swift
//  AIVeris
//
//  Created by Rocky on 15/10/26.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit


class ServiceOrderExpandContentViewFactory {
    static func createExpandContentView(param: ParamModel, contentViewFrame: CGRect) -> UIView {
        var contentView: UIView = UIView()
        if param.param_key == "25043309" {
            let expandContent = ImageContent(frame: contentViewFrame)
            
            expandContent.imgUrl = param.param_value
            
            contentView = expandContent
        }
        
        return contentView

    }
}