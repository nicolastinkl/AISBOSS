//
//  UIPopView.swift
//  AIVeris
//
//  Created by tinkl on 26/10/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

import Spring

@objc public class UIPopView: UIView {
    
    @IBOutlet weak var popTitle: UILabel!
    @IBOutlet weak var popBackgroundView: AIImageView!    
    @IBOutlet weak var popPrice: UILabel!
    @IBOutlet weak var popBuyNumber: UILabel!
    
    var firstImageView:AIImageView?
    
    // MARK: currentView
    class func currentView()->UIPopView{
        let selfView = NSBundle.mainBundle().loadNibNamed("UIPopView", owner: self, options: nil).first  as! UIPopView
        return selfView
    }
    
    /**
    数据填充处理
    */
    public func fillDataWithModel(model: AIBuyerBubbleModel) -> Void{
        //self.fill data
        popPrice.text = model.proposal_price ?? ""
        popPrice.textColor = UIColor(hex: "272727")
        popBuyNumber.text = "\(model.order_times ?? 0)"
        popTitle.font = AITools.myriadLightSemiCondensedWithSize(22+3)

        /**
        //这里处理换行
        let stringTitle = NSString(string: model.proposal_name ?? "")
        let strArray = stringTitle.componentsSeparatedByString(" ")
        if let s = strArray.first {
            let firstString = "\(s)\n"
            let newArray = NSMutableArray(array: strArray)
            newArray.removeObjectAtIndex(0)
            let content = newArray.componentsJoinedByString(" ")
           
            popTitle.text = firstString + content
        }
        */
        
        popTitle.text = model.proposal_name ?? ""
        let price =  model.proposal_price ?? ""
        if price.length > 9 {
            popPrice.font = AITools.myriadBoldWithSize(14)
        }else{
            popPrice.font = AITools.myriadBoldWithSize(21+3)
        }
        
        popBuyNumber.font = AITools.myriadLightSemiExtendedWithSize(15)
        
        /// 添加logo小图标
        var i: Int = 0
        if let _ = model.service_list {
            for server in  model.service_list {
                let logoModel = server as! AIBuyerBubbleProportModel
                let position = centerForIconAtIndex(i)
                let imageView = AIImageView()
                imageView.setURL(NSURL(string: logoModel.service_thumbnail_icon ?? AIApplication.AIImagePlaceHolder.AIDefaultPlaceHolder), placeholderImage:UIColor(hex: "#4b4960").imageWithColor())
                
                //36^
                imageView.frame = CGRectMake(position.x, position.y, 29/2.5, 29/2.5)
                self.addSubview(imageView)
                firstImageView = imageView
                i++
            }
        }
    }
    
    let kAngleOffset:CGFloat = CGFloat(M_PI_2)/5.6 //5.2 //CGFloat(M_PI_2) / 4.5
    let kSphereLength:CGFloat = 61
    let kSphereDamping:Float = 0.7
    let kSphereFixPosition:CGFloat = 7
    
    // 图标 弧形排列
    func centerForIconAtIndex(index:Int) -> CGPoint{
        let firstAngle:CGFloat = CGFloat(M_PI)*0.48 + (CGFloat(M_PI_2) - kAngleOffset) - CGFloat(index) * kAngleOffset
        //print(firstAngle)
        let startPoint = self.center
        let x = startPoint.x + cos(firstAngle) * kSphereLength - kSphereFixPosition;
        let y = startPoint.y + sin(firstAngle) * kSphereLength - kSphereFixPosition + 2;
        let position = CGPointMake(x, y);
        return position;
    }
    
    
}