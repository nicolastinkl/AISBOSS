//
//  UICustomsTags.swift
//  AIVeris
//
//  Created by tinkl on 19/11/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import AISpring
import AIAlertView

internal protocol AIElasticDownTagStateDelegete : class{
    func changeTagState(newState:tagState,viewModel:AIProposalServiceDetailLabelModel)
    func releaseTagState(newState:tagState,viewModel:AIProposalServiceDetailLabelModel)
}

public enum tagState : Int {
    case normal = 1 ,selected = 2
}

internal class UICustomsTags : SpringView {
    
    // MARK: -> Internal properties
    private let titleNormalBgColor = "#F9AA00"
    private let titleNormalFontColor = "#A22D02"
    
    private let titleSelectedBgColor = "#9B1C06"

    private let titleSelectedFontColor = "#B52910"
    
    private let roundNormalBgColor = "#FFDA80"
    private let roundNormalFontColor = "#F88C00"

    private let roundSelectedBgColor = "#A92007"
    private let roundSelectedFontColor = "#991B06"
    
    private var currentTagState = tagState.normal
    
    internal weak var delegateNew:AIElasticDownTagStateDelegete?
    
    // MARK: variables
    @IBOutlet weak var content: DesignableLabel!
    @IBOutlet weak var unReadNumber: DesignableLabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var wish_id:Int = 0
    
    var selfModel:AIProposalServiceDetailLabelModel?
    
    // MARK: currentView
    class func currentView()->UICustomsTags{
        let selfView = NSBundle.mainBundle().loadNibNamed("UICustomsTags", owner: self, options: nil).first  as! UICustomsTags
        
        //Init Font...
        selfView.content.font = AITools.myriadLightSemiCondensedWithSize(35/2.5)
        selfView.unReadNumber.font = AITools.myriadSemiCondensedWithSize(35/2.5)
        
        return selfView
    }
    
    func fillOfData(model: AIProposalServiceDetailLabelModel){
        selfModel = model
        let contentText = model.content ?? ""
        content.text = "    \(contentText)"
        
        unReadNumber.text = "\(model.selected_num ?? 0)"
    }
    
    func closeIntoEnable(){
        button.enabled = false
    }
    
    /**
     处理tag颜色标签处理
     */
    func updateStateLayout(model: tagState ){
        currentTagState = model
        if model == tagState.normal {
            content.backgroundColor = UIColor(hex: titleNormalBgColor)
            content.textColor = UIColor(hex: titleNormalFontColor)
            
            unReadNumber.backgroundColor = UIColor(hex: roundNormalBgColor)
            unReadNumber.textColor = UIColor(hex: roundNormalFontColor)
            
        }else{
            content.backgroundColor = UIColor(hex: titleSelectedBgColor)
            content.textColor = UIColor(hex: titleSelectedFontColor)
            
            unReadNumber.backgroundColor = UIColor(hex: roundSelectedBgColor)
            unReadNumber.textColor = UIColor(hex: roundSelectedFontColor)
        }
    }
    
    func changeTagStateByLocal(model: tagState ){
        currentTagState = model
        updateStateLayout(model)
        self.delegateNew?.changeTagState(self.currentTagState, viewModel: self.selfModel!)
        
        
    }
    
    /**
     改变tag的状态 并delegate通知其他view
     TODO: delegate是改变之后的状态
     */
    @IBAction func changeTagStats(sender: AnyObject) {
        
        if currentTagState == tagState.normal {
            currentTagState = tagState.selected
        }else{
            currentTagState = tagState.normal
        }
        
        updateSelfState {[weak self] () -> Void in
            if let strongSelf = self{
                strongSelf.delegateNew?.changeTagState(strongSelf.currentTagState, viewModel: strongSelf.selfModel!)
            }
        }
        
    }
    
    ///通用函数
    func updateSelfState(block:(Void)->Void){
        //处理网络请求
        if let model = selfModel{
            let message = AIMessageWrapper.updateWiskListTagStateWishID(self.wish_id, tagID: model.label_id, isChoose: currentTagState == tagState.selected)
            self.showProgressViewLoading()
            self.userInteractionEnabled = false
            AIRemoteRequestQueue().asyncRequset(self, message: message, successRequst: {[weak self] (subView,reponse) -> Void in
                subView.hideProgressViewLoading()
                subView.userInteractionEnabled = true
                if let strongSelf = self{
                    strongSelf.updateStateLayout(strongSelf.currentTagState)
                    block()
                    // 修改model 数据
                    if strongSelf.selfModel?.selected_flag == 0{
                        strongSelf.selfModel?.selected_flag = 1
                    }else{
                        strongSelf.selfModel?.selected_flag = 0
                    }
                }
                
                }, fail: { (errorView, error) -> Void in
                    
                    errorView.hideProgressViewLoading()
                    errorView.userInteractionEnabled = true
                    
                    if self.currentTagState == tagState.normal {
                        self.currentTagState = tagState.selected
                    }else{
                        self.currentTagState = tagState.normal
                    }
                    
                    //AIAlertView().showInfo(AIAudioMessageView.kERROR, subTitle:AIAudioMessageView.kINFO, closeButtonTitle: AIAudioMessageView.kCLOSE, duration: 3)
                    
            })
        }
        
   
    }

    @IBAction func backAction(sender: AnyObject) {
        updateSelfState {[weak self] () -> Void in
            if let strongSelf = self{
                strongSelf.delegateNew?.releaseTagState(strongSelf.currentTagState, viewModel: strongSelf.selfModel!)
            }
        }
        
     }
}