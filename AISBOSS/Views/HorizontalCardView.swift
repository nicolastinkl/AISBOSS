//
//  HorizontalCardView.swift
//  AIVeris
//
//  Created by 刘先 on 15/9/15.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

@objc
protocol HorizontalCardViewDelegate {
    optional func didSelectCell(cardView : HorizontalCardView,cellIndex : Int)
}

class HorizontalCardView: UIView {
    
    var serviceListModelList : [ServiceList]!
    var cardCellViewList = Array<CardCellView>()
    var delegate : HorizontalCardViewDelegate?
    
    let viewPadding : CGFloat = 15
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
        var index = 0
        let cellPaddingAll = CGFloat(serviceListModelList.count - 1) * cellPadding
        let cellWidth = (self.bounds.size.width - (viewPadding * 2) - cellPaddingAll ) / CGFloat(serviceListModelList.count)
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
            let cardCellView : CardCellView = CardCellView.currentView()
            cardCellView.frame = cellFrame
            
            cardCellView.buildViewData(serviceListModel)
            cardCellView.index = index
            bindCellEvent(cardCellView)
            cardCellViewList.append(cardCellView)
            
            self.addSubview(cardCellView)
            cellX = cellX + cellWidth + cellPadding
            index++
        }
    }
    
    func bindCellEvent(cardCellView : CardCellView){
        self.userInteractionEnabled = true
        let tapGuesture = UITapGestureRecognizer(target: self, action: "viewSelectAction:")
        cardCellView.addGestureRecognizer(tapGuesture)
    }
    
    // MARK: - delegate
    func viewSelectAction(target : UITapGestureRecognizer){
        if let selCardCellView : CardCellView = target.view as? CardCellView{
            for cardCellView : CardCellView in cardCellViewList{
                if cardCellView.index == selCardCellView.index{
                    cardCellView.selectAction(true)
                }
                else{
                    cardCellView.selectAction(false)
                }
            }
            
            delegate?.didSelectCell!(self, cellIndex: selCardCellView.index)
        }
        
    }
}
