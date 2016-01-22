//
//  AIPriceView.swift
//  AIVeris
//
//  Created by 王坜 on 16/1/22.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Foundation

class AIPriceView: UIView {

    //MARK: Constants
    
    
    //MARK: Variables
    
    var displayModel : AIPriceViewModel?
    
    
    //MARK: Override
    
    init(frame : CGRect, model: AIPriceViewModel?) {
        super.init(frame: frame)
        //super.init()
        displayModel = model
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func makeSubViews () {

        if let dModel = displayModel {
            
            if (dModel.defaultPrice != nil) {
                let finalPrice = dModel.defaultPrice.currency + dModel.defaultPrice.price + dModel.defaultPrice.billingMode;
                let priceView : PriceAndStepperView = PriceAndStepperView(frame: self.bounds, price: finalPrice, showStepper: true, defaultValue: dModel.defaultNumber, minValue: dModel.minNumber, maxValue: dModel.maxNumber, onValueChanged: { (steper : PKYStepper!, number : Float) -> Void in
                    
                })
                self.addSubview(priceView)
            }
            else {
                
                let label : UPLabel = AIViews.normalLabelWithFrame(self.bounds, text: "In time billing price", fontSize: 16, color: UIColor.whiteColor())
                label.textAlignment = .Center
                self.addSubview(label)
            }

            
        }

    }
    
    
    func makeTotalPriceView ()
    {
        
    }
    
}
