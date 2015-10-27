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
//        popBackgroundView.image = UIColor.whiteColor().imageWithColor()
        popPrice.text = model.proposal_price ?? ""
        popBuyNumber.text = "\(model.order_times ?? 0)"
        
        /// 添加logo小图标
        var i: Int = 0
        for server in  model.service_list {
            let logoModel = server as! AIBuyerBubbleProportModel
            let position = centerForIconAtIndex(i)
            let imageView = AIImageView()
            imageView.setURL(NSURL(string: logoModel.service_thumbnail_icon ?? ""), placeholderImage: UIImage(named: "Placehold"))
            imageView.frame = CGRectMake(position.x, position.y, 36/2, 36/2)
            self.addSubview(imageView)
            firstImageView = imageView
            i++
        }
        
        /*
        if let someObject = model.service_list.first {

            let logoModel = someObject as! AIBuyerBubbleProportModel
            
            ImageLoader.sharedLoader.imageForUrl(logoModel.service_thumbnail_icon) { [weak self] image, url in
                if let strongSelf = self {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        strongSelf.popBackgroundView.alpha=0.2;
                        strongSelf.popBackgroundView.image =  image?.getBgImageFromImage()
                        strongSelf.backgroundColor = image?.pickImageDeepColor()
                        UIView.beginAnimations(nil, context: nil)
                        UIView.setAnimationDuration(0.5)
                        strongSelf.popBackgroundView.setNeedsDisplay()
                        strongSelf.popBackgroundView.alpha = 1;
                        UIView.commitAnimations()
                        
                        
                    })
                }
            }
        } /// someObject
        */
         
        
    }
    
    let kAngleOffset:CGFloat = CGFloat(M_PI_2) / 4.5
    let kSphereLength:CGFloat = 60
    let kSphereDamping:Float = 0.5
    let kSphereFixPosition:CGFloat = 8
    
    // 图标 弧形排列
    func centerForIconAtIndex(index:Int) -> CGPoint{
        let firstAngle:CGFloat = CGFloat(M_PI)/1.4 + (CGFloat(M_PI_2) - kAngleOffset) + CGFloat(index) * kAngleOffset
        print(firstAngle)
        let startPoint = self.center
        let x = startPoint.x - cos(firstAngle) * kSphereLength - kSphereFixPosition;
        let y = startPoint.y - sin(firstAngle) * kSphereLength ;
        let position = CGPointMake(x, y);
        return position;
    }
    
    
}