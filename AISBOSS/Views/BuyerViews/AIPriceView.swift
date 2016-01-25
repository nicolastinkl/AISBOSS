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
    var priceView : PriceAndStepperView?
    var totalNumber : Int = 0
    var totalPriceLabel : UPLabel?
    
    //MARK: Override
    
    init(frame : CGRect, model: AIPriceViewModel?) {
        super.init(frame: frame)
        displayModel = model
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func makeSubViews () {
        
        if let dModel = displayModel {
            
            if (dModel.defaultPrice != nil) {
                makePriceView()
                makeTotalPriceView()
            }
            else {
                addBackgroundView(self.bounds)
                let label : UPLabel = AIViews.normalLabelWithFrame(self.bounds, text: "In time billing price", fontSize: 16, color: UIColor.whiteColor())
                label.textAlignment = .Center
                self.addSubview(label)
            }
            
        }

    }
    
    func addBackgroundView (frame : CGRect) {
        let bgImageView = UIImageView(image: UIImage(named: "Wave_BG"))
        addSubview(bgImageView)
        bgImageView.frame = frame
        self.addSubview(bgImageView)
    }
    
    
    func makePriceView () {
        let finalPrice = displayModel!.defaultPrice.currency + displayModel!.defaultPrice.price + displayModel!.defaultPrice.billingMode;
        weak var ws = self
        priceView = PriceAndStepperView(frame: self.bounds, price: finalPrice, showStepper: true, defaultValue: displayModel!.defaultNumber, minValue: displayModel!.minNumber, maxValue: displayModel!.maxNumber, onValueChanged: { (steper : PKYStepper!, number : Float) -> Void in
            ws!.changeTotalPrice (Int(number))
        })
        self.addSubview(priceView!)
    }
    
    func makeTotalPriceView ()
    {
        let frame = CGRectMake(0, CGRectGetMaxY(priceView!.frame), CGRectGetWidth(priceView!.frame), CGRectGetHeight(priceView!.frame))
        addBackgroundView(frame)
        let price : NSString = displayModel!.defaultPrice.price as NSString
        let totalPrice = Double(displayModel!.defaultNumber) * price.doubleValue
        let PriceStr = String("%.2f",totalPrice)
        
        totalPriceLabel = AIViews.normalLabelWithFrame(frame, text: PriceStr, fontSize: 16, color: UIColor.whiteColor())
        totalPriceLabel!.textAlignment = .Center
        self.addSubview(totalPriceLabel!)
    }
    
    //MARK: Action
    
    func changeTotalPrice (num : Int) {
        totalNumber = num
        let price : NSString = displayModel!.defaultPrice.price as NSString
        let totalPrice = Double(displayModel!.defaultNumber) * price.doubleValue
        let PriceStr = String("%.2f",totalPrice)
        
        totalPriceLabel?.text = PriceStr
        
    }
    
    //MARK: 输出数据
    
    func params() -> [String : AnyObject] {
        var params = [String : AnyObject]()
        params["price"] = displayModel?.defaultPrice.toDictionary()
        params["number"] = NSNumber(integer: totalNumber)
        
        return params
    }
    
}
