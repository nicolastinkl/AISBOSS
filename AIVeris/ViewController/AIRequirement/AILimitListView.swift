//
//  AILimitListView.swift
//  MyWholeDemos
//
//  Created by 刘先 on 16/3/14.
//  Copyright © 2016年 wantsor. All rights reserved.
//

import Foundation
import UIKit

class AILimitListView: AIPopupChooseBaseView {
    
    var limitModels : [AILimitModel]?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadData(limitListModel limitListModel: [AILimitModel]) {
        itemModels = [AIPopupChooseModel]()
        for limitModel in limitListModel{
            let itemModel = AIPopupChooseModel(itemId: limitModel.limitId, itemTitle: limitModel.limitName, itemIcon: limitModel.limitIcon, isSelect: limitModel.hasLimit)
            itemModels?.append(itemModel)
        }
        super.loadData(itemModels! , businessType: PopupBusinessType.LimitConfig)
    }
}
