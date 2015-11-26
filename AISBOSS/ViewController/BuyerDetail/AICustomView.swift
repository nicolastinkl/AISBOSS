//
//  AICustomView.swift
//  AIVeris
//
//  Created by tinkl on 20/11/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import AISpring
import Cartography

internal class AICustomView : UIView{
    
    private let tagMargin:CGFloat = 5
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var unselectView: DesignableView!
    @IBOutlet weak var selectView: DesignableView!
    @IBOutlet weak var avator: DesignableImageView!
    
    private lazy var allTagsArray  = [AIBuerSomeTagModel]()
    private lazy var selectedTagsArray  = [AIBuerSomeTagModel]()
    // MARK: currentView
    class func currentView()->AICustomView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AICustomView", owner: self, options: nil).first  as! AICustomView
        
        selfView.title.font = AITools.myriadSemiCondensedWithSize(63/PurchasedViewDimention.CONVERT_FACTOR)
        selfView.content.font = AITools.myriadLightSemiCondensedWithSize(42/PurchasedViewDimention.CONVERT_FACTOR)
        
        return selfView
    }
    
    /**
     TODO: 处理数据填充和标签初始化
     */
    func fillTags(models:[AIBuerSomeTagModel],isNormal:Bool){
        allTagsArray = models //fill data..
        
        var x:CGFloat = tagMargin
        var y:CGFloat = 0
        var n = 0
        
        if isNormal {
            
        }else{
            y = 10
        }
        
        for model in models{
            
            let tag = UICustomsTags.currentView()
            let tags = UIView()
            if isNormal {
                unselectView.addSubview(tags)
            }else{
                selectView.addSubview(tags)
                tag.closeIntoEnable()
                
            }

            tags.addSubview(tag)
            
            tag.fillOfData(model) //处理数据刷新  // add into whole array with key-value.
            
            tag.delegateNew = self
            let ramdWidth = 30 + model.tagName!.length * 8
            let ramdHeigth:CGFloat = 35
            
            if (x + CGFloat(ramdWidth) + tagMargin) > (self.width - tagMargin) {
                n = 0
                x = tagMargin
                y += ramdHeigth + tagMargin
            } else {
                if n > 0 {
                    x = x + tagMargin
                }
            }
            
            n = n + 1  //   Add 1
            
            tags.setSize(CGSize(width: CGFloat(ramdWidth), height: ramdHeigth))
            tags.setOrigin(CGPointMake(x, y))
            //tag.frame = tags.frame
            
            layout(tag) { (ticketView) -> () in
                ticketView.left == ticketView.superview!.left
                ticketView.top == ticketView.superview!.top
                ticketView.right == ticketView.superview!.right
                ticketView.bottom ==  ticketView.superview!.bottom
                ticketView.width >= 28
            }
            
            tag.clipsToBounds = true
            x = x + CGFloat(ramdWidth)
            
        }
    }
}

// MARK: - AIElasticDownTagStateDelegete
extension AICustomView:AIElasticDownTagStateDelegete{
    /**
     处理可变数组数据的处理
     
     - parameter newState: tag改变之后的状态
     */
    func changeTagState(newState: tagState, viewModel: AIBuerSomeTagModel) {

        
        func refershUI(){
            
            _ = selectView.subviews.filter { (childView) -> Bool in
                childView.removeFromSuperview()
                return true
            }
            fillTags(selectedTagsArray, isNormal: false)

        }
        
        if newState == tagState.normal {
            //remove this view from list
            
            let array = selectedTagsArray.filter { (oldModel) -> Bool in
                return oldModel.bsId != viewModel.bsId
            }
            
            //remove
            selectedTagsArray = array

            //refersh UI
            refershUI()
            
        }else{
            //add  刷新处理
            selectedTagsArray.append(viewModel)
            
            //refersh UI
            refershUI()
        }
       
        
    }
}