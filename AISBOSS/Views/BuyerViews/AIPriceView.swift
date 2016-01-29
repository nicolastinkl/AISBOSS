//
//  AIPriceView.swift
//  AIVeris
//
//  Created by 王坜 on 16/1/22.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Foundation

class AIPriceView: AIServiceParamBaseView {

    //MARK: Constants
    
    
    //MARK: Variables
    var originalY : CGFloat = 0
    var displayModel : AIPriceViewModel?
    var priceView : PriceAndStepperView?
    var totalNumber : Int = 0
    var totalPriceLabel : UPLabel?
    
    //MARK: Override
    
    init(frame : CGRect, model: AIPriceViewModel?) {
        super.init(frame: frame)
        if let _ = model {
            displayModel = model
            makeSubViews()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetFrame () {
        var frame = self.frame
        frame.size.height = originalY
        self.frame = frame
    }
    
    func makeSubViews () {
        
        if let dModel = displayModel {
            
            if (dModel.defaultPrice != nil) {
                makePriceView()
                makeTotalPriceView()
            }
            else {
                let frame = CGRectMake(0, originalY, CGRectGetWidth(self.frame), 40)
                addBackgroundView(frame)
                let label : UPLabel = AIViews.normalLabelWithFrame(self.bounds, text: "In time billing price", fontSize: 16, color: UIColor.whiteColor())
                label.textAlignment = .Center
                self.addSubview(label)
                originalY += 40
            }
            resetFrame()
        }

    }
    
    func addBackgroundView (frame : CGRect) {
        let bgImageView = UIImageView(image: UIImage(named: "Wave_BG"))
        addSubview(bgImageView)
        bgImageView.frame = frame
        self.addSubview(bgImageView)
    }
    
    
    func makePriceView () {
        
        var finalPrice : String = ""
        
        if let _ = displayModel?.defaultPrice.currency {
            finalPrice += (displayModel?.defaultPrice.currency)!
            finalPrice += " "
        }
        
        if let _ = displayModel?.defaultPrice.price {
            finalPrice += (displayModel?.defaultPrice.price)!
            finalPrice += " "
        }
        
        if let _ = displayModel?.defaultPrice.billingMode {
            finalPrice += (displayModel?.defaultPrice.billingMode)!
        }
        
        
        weak var ws = self
        let frame = CGRectMake(0, originalY, CGRectGetWidth(self.frame), 40)
        priceView = PriceAndStepperView(frame: frame, price: finalPrice, showStepper: true, defaultValue: displayModel!.defaultNumber, minValue: displayModel!.minNumber, maxValue: displayModel!.maxNumber, onValueChanged: { priceAndStepperView in
            ws?.changeTotalPrice(Int(priceAndStepperView.value))
        })
        self.addSubview(priceView!)
        
        originalY += 40
    }
    
    func makeTotalPriceView ()
    {
        let frame = CGRectMake(0, CGRectGetMaxY(priceView!.frame), CGRectGetWidth(priceView!.frame), 40)
        addBackgroundView(frame)
        let price : NSString = displayModel!.defaultPrice.price as NSString
        let totalPrice = Double(displayModel!.defaultNumber) * price.doubleValue
        var PriceStr = "Total "
        
        if let _ = displayModel?.defaultPrice.currency {
            PriceStr += (displayModel?.defaultPrice.currency)!
        }
        
        
        
        PriceStr += " \(totalPrice)"  //String("%.2f",totalPrice)
        let fontSize = AITools.displaySizeFrom1080DesignSize(63)
        totalPriceLabel = AIViews.normalLabelWithFrame(frame, text: PriceStr, fontSize: fontSize, color: UIColor.whiteColor())
        totalPriceLabel!.textAlignment = .Center
        totalPriceLabel!.textColor = AITools.colorWithR(0xf7, g: 0x9a, b: 0x00)
        totalPriceLabel?.font = AITools.myriadBoldWithSize(fontSize)
        self.addSubview(totalPriceLabel!)
        
        originalY = originalY * 2
    }
    
    //MARK: Action
    
    func changeTotalPrice (num : Int) {
        totalNumber = num
        let price : NSString = displayModel!.defaultPrice.price as NSString
//        let totalPrice = Double(displayModel!.defaultNumber) * price.doubleValue
        let totoalPrice = Double(totalNumber) * price.doubleValue
        let PriceStr = "Total€\(totoalPrice)"
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
