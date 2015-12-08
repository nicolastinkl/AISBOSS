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
    
    private lazy var allTagsArray  = [AIProposalServiceDetail_label_list_listModel]()
    private lazy var selectedTagsArray  = [AIProposalServiceDetail_label_list_listModel]()
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
    func fillTags(models:[AIProposalServiceDetail_label_list_listModel],isNormal:Bool){
        allTagsArray = models //fill data..
        
        var x:CGFloat = tagMargin
        var y:CGFloat = 0
        var n = 0
        var currentX:CGFloat = 0
        var currentY:CGFloat = 0
        
        if isNormal {
            
        }else{
            y = 2
        }
        
        for model in models{
            
            let tag = UICustomsTags.currentView()
            let tags = UIView()
            if isNormal {
                unselectView.addSubview(tags)
                tag.backButton.hidden = true
            }else{
                selectView.addSubview(tags)
                tag.closeIntoEnable()
                tag.backButton.hidden = false
            }
            
            tags.addSubview(tag)
            
            tag.fillOfData(model) //处理数据刷新  // add into whole array with key-value.
            
            tag.delegateNew = self
            
            let ramdWidthOLD = 45 + model.content!.length * 6
            let sizenew = model.content.sizeWithFont(AITools.myriadLightSemiCondensedWithSize(35/2.5), forWidth: CGFloat(ramdWidthOLD))
            let ramdWidth = sizenew.width  + 55
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
            
            if  y < 10 && n < 3 {
                currentX = x
                
                if isNormal {
                    
                }else{
                    currentY = 2
                }
                
            } 
            
            if y > ramdHeigth*2 {
                tags.setOrigin(CGPointMake(currentX + tagMargin + CGFloat(ramdWidth), currentY))
            }else{
                tags.setOrigin(CGPointMake(x, y))
            }
            n = n + 1  //   Add 1
            tags.setSize(CGSize(width: CGFloat(ramdWidth), height: ramdHeigth))
           
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
     回调按钮处理
     
     - parameter newState:  newState description
     - parameter viewModel: viewModel description
     */
    func releaseTagState(newState: tagState, viewModel: AIProposalServiceDetail_label_list_listModel) {
        
        //处理已选按钮的释放
        let array = selectedTagsArray.filter { (oldModel) -> Bool in
            return oldModel.label_id != viewModel.label_id
        }
        
        //remove
        selectedTagsArray = array
        
        //refersh UI
        refershUI()
        
        
        //处理待选按钮的颜色切换
        
        _ = unselectView.subviews.filter { (childView) -> Bool in
            let tags = childView.subviews.first as! UICustomsTags
            if tags.selfModel?.label_id == viewModel.label_id {
                // 切换状态
                tags.updateStateLayout(newState)
            }
            return true
        }
        
    }
    
    func refershUI(){
        
        _ = selectView.subviews.filter { (childView) -> Bool in
            childView.removeFromSuperview()
            return true
        }
        fillTags(selectedTagsArray, isNormal: false)
        
    }
    
    
    /**
     处理可变数组数据的处理
     
     - parameter newState: tag改变之后的状态
     */
    func changeTagState(newState: tagState, viewModel: AIProposalServiceDetail_label_list_listModel) {
    
        if newState == tagState.normal {
            //remove this view from list
            
            let array = selectedTagsArray.filter { (oldModel) -> Bool in
                return oldModel.label_id != viewModel.label_id
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