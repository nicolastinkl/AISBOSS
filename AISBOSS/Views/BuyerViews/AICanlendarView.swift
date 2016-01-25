//
//  AICanlendarView.swift
//  AIVeris
//
//  Created by 王坜 on 16/1/21.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation


class AICanlendarView: UIView {
    
    //MARK: Constants
    
    
    //MARK: Variables
    
    var displayModel : AICanlendarViewModel?
    var textField : UITextField?
    var totalNumber : Int = 0
    var totalPriceLabel : UPLabel?
    
    //MARK: Override
    
    init(frame : CGRect, model: AICanlendarViewModel?) {
        super.init(frame: frame)
        displayModel = model
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func makeSubViews () {
        
        
    }
    
    
}