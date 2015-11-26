//
//  UICustomsTags.swift
//  AIVeris
//
//  Created by tinkl on 19/11/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import AISpring

internal protocol AIElasticDownTagStateDelegete : class{
    func changeTagState(newState:tagState,viewModel:AIBuerSomeTagModel)
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
    
    internal var delegateNew:AIElasticDownTagStateDelegete?
    
    // MARK: variables
    @IBOutlet weak var content: DesignableLabel!
    @IBOutlet weak var unReadNumber: DesignableLabel!
    @IBOutlet weak var button: UIButton!
    
    private var selfModel:AIBuerSomeTagModel?
    
    // MARK: currentView
    class func currentView()->UICustomsTags{
        let selfView = NSBundle.mainBundle().loadNibNamed("UICustomsTags", owner: self, options: nil).first  as! UICustomsTags
        
        //Init Font...
        selfView.content.font = AITools.myriadLightSemiCondensedWithSize(35/2.5)
        selfView.unReadNumber.font = AITools.myriadSemiCondensedWithSize(35/2.5)
        
        return selfView
    }
    
    func fillOfData(model: AIBuerSomeTagModel){
        selfModel = model
        let contentText = model.tagName ?? ""
        content.text = "    \(contentText)"
        
        unReadNumber.text = "\(model.unReadNumber ?? 0)"
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
    
    /**
     改变tag的状态 并delegate通知其他view
     TODO: delegate是改变之后的状态
     */
    @IBAction func changeTagStats(sender: AnyObject) {
//        let button = sender as! UIButton
//        let viewSuper = button.superview?.superview
        
        if currentTagState == tagState.normal {
            currentTagState = tagState.selected
        }else{
            currentTagState = tagState.normal
        }
        
        updateStateLayout(currentTagState)
        delegateNew?.changeTagState(currentTagState, viewModel: selfModel!)
    }
    
}