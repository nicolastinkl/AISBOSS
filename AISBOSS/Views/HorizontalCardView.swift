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
    
    var serviceListModelList : Array<ServiceList>!
    var cardCellViewList = Array<CardCellView>()
    var delegate : AISchemeProtocol?
    var multiSelect = false
    var maxCellNumber = 4
    
    let viewPadding : CGFloat = 9
    let cellPadding : CGFloat = 3
    let cellHeight : CGFloat = 75
    let cellY : CGFloat = 0

    // MARK: - init method
    override init(frame: CGRect) {
        super.init(frame: frame)
        //initEmptyCell()
    }
    
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
    func loadData(serviceListModelList : [ServiceList],multiSelect : Bool){
        self.serviceListModelList = serviceListModelList
//        if serviceListModelList.count > maxCellNumber{
//            self.serviceListModelList.removeRange(Range(start: maxCellNumber - 1,end: serviceListModelList.count - 1))
//        }
        if maxCellNumber > self.serviceListModelList.count{
            maxCellNumber = self.serviceListModelList.count
        }
        self.multiSelect = multiSelect
        buildLayout()
        //buildReuseLayout()
    }
    
    func buildLayout(){
        var isFirst = true
        var cellX : CGFloat = viewPadding
        var index = 0
        let cellPaddingAll = CGFloat(maxCellNumber - 1) * cellPadding
        let cellWidth = (self.bounds.size.width - (viewPadding * 2) - cellPaddingAll ) / CGFloat(maxCellNumber)
        let firstCellFrame = CGRectMake(cellX, cellY, cellWidth, cellHeight)
        //clear data first
        cardCellViewList.removeAll()
        self.subviews.map({
            $0.removeFromSuperview()
        })
        //build cell
        for var i = 0 ; i < maxCellNumber ; i++ {
        //for serviceListModel : ServiceList in serviceListModelList{
            let serviceListModel : ServiceList = serviceListModelList[i] as ServiceList
            var cellFrame:CGRect!
            
            let cardCellView = CardCellView.currentView()
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
            
            cardCellView.index = index
            bindCellEvent(cardCellView)
            cardCellViewList.append(cardCellView)
            self.addSubview(cardCellView)
            cardCellView.buildViewData(serviceListModel)
            //init select status
            cardCellView.selectAction()
            cellX = cellX + cellWidth + cellPadding
            index++
        }
    }
    
    //试验性服用cell方式尝试,先创建最多数量的cell，然后每次loadData时拿出来服用，再修改frame
    func buildReuseLayout(){
        var isFirst = true
        var cellX : CGFloat = viewPadding
        var index = 0
        let cellPaddingAll = CGFloat(serviceListModelList.count - 1) * cellPadding
        let cellWidth = (self.bounds.size.width - (viewPadding * 2) - cellPaddingAll) / CGFloat(serviceListModelList.count)
        let firstCellFrame = CGRectMake(cellX, cellY, cellWidth, cellHeight)
        
        //build cell
        for serviceListModel : ServiceList in serviceListModelList{
            
            if cardCellViewList.count == index {
                return
            }
            
            var cellFrame:CGRect!
            let cardCellView : CardCellView = CardCellView.currentView()
            // cardCellViewList[index] as CardCellView
            cardCellView.hidden = false
            if isFirst{
                cellFrame = firstCellFrame
                cardCellView.selected = true
                isFirst = false
            }else{
                cellFrame = CGRectMake(cellX, cellY, cellWidth, cellHeight)
                cardCellView.selected = false
            }
            cardCellView.frame = cellFrame
            cardCellView.reloadData(serviceListModel)
            
            //init select status
            cardCellView.selectAction()
            cellX = cellX + cellWidth + cellPadding
            index++
        }
        
        for _ in index ..< maxCellNumber {
            let cardCellView : CardCellView = cardCellViewList[index] as CardCellView
            cardCellView.hidden = true
        }
        self.layoutIfNeeded()
        
    }
    
    func initEmptyCell(){
        let cellFrame : CGRect = CGRectMake(0, 0, 120, 80)
        var index = 0
        for _ in 1 ... maxCellNumber{
            let cardCellView : CardCellView = CardCellView.currentView()
            cardCellView.frame = cellFrame
//            cardCellView.buildViewData()
            
            cardCellView.index = index
            bindCellEvent(cardCellView)
            cardCellViewList.append(cardCellView)
            self.addSubview(cardCellView)
            cardCellView.hidden = true
            index++
        }
    }
    
    func bindCellEvent(cardCellView : CardCellView){
        self.userInteractionEnabled = true
        let tapGuesture = UITapGestureRecognizer(target: self, action: "viewSelectAction:")
        cardCellView.addGestureRecognizer(tapGuesture)
    }
    
    //手工设定选中项目
    func setSelectedCel(indexs : [Int]){
        for cardCellView : CardCellView in cardCellViewList{
            for index : Int in indexs{
                if cardCellView.index == index{
                    cardCellView.selected = !cardCellView.selected
                    cardCellView.selectAction()
                }
            }
        }
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
            let model = chooseItemModel()
            model.scheme_item_id = selCardCellView.serviceListModel!.service_id
            model.scheme_item_price = selCardCellView.serviceListModel!.service_price.price.floatValue
            
            delegate?.chooseItem(model)
        }
        
    }
}
