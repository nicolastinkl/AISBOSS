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
    
    var ServiceModelList : Array<Service>!
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
    
    init(frame: CGRect,ServiceModelList : [Service]) {
        super.init(frame: frame)
        self.ServiceModelList = ServiceModelList
        buildLayout()
    }
    
    init(frame: CGRect,ServiceModelList : [Service],multiSelect : Bool) {
        super.init(frame: frame)
        self.multiSelect = multiSelect
        self.ServiceModelList = ServiceModelList
        buildLayout()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // MARK: - build method
    func loadData(ServiceModelList : [Service],multiSelect : Bool){
        self.ServiceModelList = ServiceModelList
//        if ServiceModelList.count > maxCellNumber{
//            self.ServiceModelList.removeRange(Range(start: maxCellNumber - 1,end: ServiceModelList.count - 1))
//        }
        if maxCellNumber > self.ServiceModelList.count{
            maxCellNumber = self.ServiceModelList.count
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
        _ = self.subviews.map({
            $0.removeFromSuperview()
        })
        //build cell
        for var i = 0 ; i < maxCellNumber ; i++ {
        //for ServiceModel : Service in ServiceModelList{
            let ServiceModel : Service = ServiceModelList[i] as Service
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
            cardCellView.buildViewData(ServiceModel)
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
        let cellPaddingAll = CGFloat(ServiceModelList.count - 1) * cellPadding
        let cellWidth = (self.bounds.size.width - (viewPadding * 2) - cellPaddingAll) / CGFloat(ServiceModelList.count)
        let firstCellFrame = CGRectMake(cellX, cellY, cellWidth, cellHeight)
        
        //build cell
        for ServiceModel : Service in ServiceModelList{
            
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
            cardCellView.reloadData(ServiceModel)
            
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
            var lastSelectedCardCellView : CardCellView
            var canceledService :Service?
            var selectedService : Service?
            for cardCellView : CardCellView in cardCellViewList{
                //支持多选的情况，只需要把selected取反
                if multiSelect{
                    if cardCellView.index == selCardCellView.index{
                        //如果是选中变不选中
                        if cardCellView.selected{
                            canceledService = selCardCellView.serviceModel
                        }
                        //如果是不选中变选中
                        else{
                            selectedService = selCardCellView.serviceModel
                        }
                        cardCellView.selected = !cardCellView.selected
                        cardCellView.selectAction()
                    }
                }
                //单选情况，要把其它所有都改为selected=false再置true选中的那个
                else{
                    if cardCellView.selected {
                        lastSelectedCardCellView = cardCellView
                        canceledService = lastSelectedCardCellView.serviceModel
                    }
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
            //单选的时候为选中赋值
            if !multiSelect{
                selectedService = selCardCellView.serviceModel
            }
            
            
            delegate?.chooseItem(selectedService, cancelItem: canceledService,fromView: self)
        }
        
    }
}
