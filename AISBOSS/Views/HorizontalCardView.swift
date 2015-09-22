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
    var multiSelect = false
    
    let viewPadding : CGFloat = 10
    let cellPadding : CGFloat = 5
    let cellHeight : CGFloat = 75
    let cellY : CGFloat = 0

    // MARK: - init method
    init(frame: CGRect,serviceListModelList : [ServiceList]) {
        super.init(frame: frame)
        self.serviceListModelList = serviceListModelList
        buildLayout()
    }
    
    init(frame: CGRect,serviceListModelList : [ServiceList],multiSelect : Bool) {
        super.init(frame: frame)
        self.multiSelect = multiSelect
        self.serviceListModelList = serviceListModelList
        buildLayout()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - build method
    func buildLayout(){
        var isFirst = true
        var cellX : CGFloat = viewPadding
        var index = 0
        let cellPaddingAll = CGFloat(serviceListModelList.count - 1) * cellPadding
        let cellWidth = (self.bounds.size.width - (viewPadding * 2) - cellPaddingAll ) / CGFloat(serviceListModelList.count)
        let firstCellFrame = CGRectMake(cellX, cellY, cellWidth, cellHeight)
        
        for serviceListModel : ServiceList in serviceListModelList{
            var cellFrame:CGRect!
            
            let cardCellView : CardCellView = CardCellView.currentView()
            if isFirst{
                cellFrame = firstCellFrame
                cardCellView.selected = true
                isFirst = false
            }
            else{
                cellFrame = CGRectMake(cellX, cellY, cellWidth, cellHeight)
                cardCellView.selected = false
            }
            
            cardCellView.frame = cellFrame
            
            cardCellView.buildViewData(serviceListModel)
            cardCellView.index = index
            bindCellEvent(cardCellView)
            cardCellViewList.append(cardCellView)
            self.addSubview(cardCellView)
            //init select status
            cardCellView.selectAction()
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
                //支持多选的情况，只需要把selected取反
                if multiSelect{
                    if cardCellView.index == selCardCellView.index{
                        cardCellView.selected = !cardCellView.selected
                        cardCellView.selectAction()
                    }
                }
                //单选情况，要把其它所有都改为selected=false再置true选中的那个
                else{
                    if cardCellView.index == selCardCellView.index{
                        cardCellView.selected = true
                        cardCellView.selectAction()
                    }
                    else{
                        cardCellView.selected = false
                        cardCellView.selectAction()
                    }
                }
                
            }
            
            delegate?.didSelectCell!(self, cellIndex: selCardCellView.index)
        }
        
    }
}
