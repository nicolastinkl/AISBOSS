//
//  UIPopView.swift
//  AIVeris
//
//  Created by tinkl on 26/10/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class UIPopView: UIView {
    
    @IBOutlet weak var popTitle: UILabel!
    @IBOutlet weak var popBackgroundView: AIImageView!
    
    @IBOutlet weak var popPrice: UILabel!
    @IBOutlet weak var popBuyNumber: UILabel!
    
    // MARK: currentView
    class func currentView()->UIPopView{
        let selfView = NSBundle.mainBundle().loadNibNamed("UIPopView", owner: self, options: nil).first  as! UIPopView
        return selfView
    }
    
    /**
    数据填充处理
    
    - parameter model: MODEL
    */
    func fillDataWithModel(model: AIPopPropsalModel){
        //self.fill data
        popTitle.text = model.proposal_name ?? ""
        popBackgroundView.image = UIColor.whiteColor().imageWithColor()
        popPrice.text = model.proposal_price ?? ""
        
        popBuyNumber.text = "\(model.order_times ?? 0)"
    }
    
    
}