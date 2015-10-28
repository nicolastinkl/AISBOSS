//
//  UIPopView.swift
//  AIVeris
//
//  Created by tinkl on 26/10/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

import AISpring

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
        popTitle.text = model.proposal_name ?? ""
        popPrice.text = model.proposal_price ?? ""
        popBuyNumber.text = "\(model.order_times ?? 0)"
        
        popTitle.font = AITools.myriadLightSemiCondensedWithSize(20)
        popPrice.font = AITools.myriadBoldWithSize(21)
        popBuyNumber.font = AITools.myriadLightSemiExtendedWithSize(15)
        
        
        /// 添加logo小图标
        var i: Int = 0
        if let _ = model.service_list {
            for server in  model.service_list {
                let logoModel = server as! AIBuyerBubbleProportModel
                let position = centerForIconAtIndex(i)
                let imageView = AIImageView()
                imageView.setURL(NSURL(string: logoModel.service_thumbnail_icon ?? ""), placeholderImage:nil)
                imageView.frame = CGRectMake(position.x, position.y, 36/2, 36/2)
                self.addSubview(imageView)
                firstImageView = imageView
                i++
            }
        }
        
    }
    
    let kAngleOffset:CGFloat = CGFloat(M_PI_2) / 4.5
    let kSphereLength:CGFloat = 60
    let kSphereDamping:Float = 0.5
    let kSphereFixPosition:CGFloat = 7
    
    // 图标 弧形排列
    func centerForIconAtIndex(index:Int) -> CGPoint{
        let firstAngle:CGFloat = CGFloat(M_PI)*0.5 + (CGFloat(M_PI_2) - kAngleOffset) - CGFloat(index) * kAngleOffset
        //print(firstAngle)
        let startPoint = self.center
        let x = startPoint.x + cos(firstAngle) * kSphereLength - kSphereFixPosition - 2;
        let y = startPoint.y + sin(firstAngle) * kSphereLength - kSphereFixPosition;
        let position = CGPointMake(x, y);
        return position;
    }
    
    
}