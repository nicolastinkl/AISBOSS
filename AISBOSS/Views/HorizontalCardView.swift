//
//  HorizontalCardView.swift
//  AIVeris
//
//  Created by 刘先 on 15/9/15.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class HorizontalCardView: UIView {
    
    var serviceListModelList : [ServiceList]!
    
    let viewPadding : CGFloat = 5
    let cellPadding : CGFloat = 5
    let cellHeight : CGFloat = 100
    let cellY : CGFloat = 0

    // MARK: - init method
    init(frame: CGRect,serviceListModelList : [ServiceList]) {
        super.init(frame: frame)
        self.serviceListModelList = serviceListModelList
        buildLayout()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - build method
    func buildLayout(){
        var isFirst = false
        var cellX : CGFloat = viewPadding
        
        let cellWidth = (self.bounds.size.width - (viewPadding * 2)) / CGFloat(serviceListModelList.count)
        let firstCellFrame = CGRectMake(cellX, cellY, cellWidth, cellHeight)
        
        for serviceListModel : ServiceList in serviceListModelList{
            var cellFrame:CGRect!
            if isFirst{
                cellFrame = firstCellFrame
                isFirst = false
            }
            else{
                cellFrame = CGRectMake(cellX, cellY, cellWidth, cellHeight)
            }
            let cardCellView : CardCellView = CardCellView(frame: cellFrame)
            cardCellView.buildViewData(serviceListModel)
            self.addSubview(cardCellView)
            cellX = cellX + cellWidth + cellPadding
        }
    }
    
}
