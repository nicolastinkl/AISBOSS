//
//  CardCellView.swift
//  AIVeris
//
//  Created by 刘先 on 15/9/15.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class CardCellView: UIView {
    
    var selected = false
    var index : Int!
    var grayBackgroundImg : UIImage?
    var originBackgroundImg : UIImage?
    var starRateView : CWStarRateView?
    var serviceNameScrollLabel : AIScrollLabel?
    var serviceDescScrollLabel : AIScrollLabel?
    var serviceListModel : ServiceList?
    var firstLayout = true
    // MARK: - uiview variables
    
    
    @IBOutlet weak var serviceDescView: UIView!
    @IBOutlet weak var serviceNameView: UIView!
    @IBOutlet weak var servicePriceLabel: UILabel!
    @IBOutlet weak var serviceRatingView: UIView!
    @IBOutlet weak var serviceImg: AIImageView!
    @IBOutlet weak var backGroundColorView: UIImageView!
    @IBOutlet weak var selectFlagImage: UIImageView!
    
    // MARK: currentView
    class func currentView()->CardCellView{
        let selfView = NSBundle.mainBundle().loadNibNamed("CardCellView", owner: self, options: nil).first  as! CardCellView
        
        let serviceNameScrollLabel = AIScrollLabel(frame:selfView.serviceNameView.bounds, text: "", color: UIColor.whiteColor(), scrollEnable: true)
        selfView.serviceNameView.addSubview(serviceNameScrollLabel)
        
        let serviceDescScrollLabel = AIScrollLabel(frame: selfView.serviceDescView.bounds, text: "", color: UIColor.whiteColor(), scrollEnable: true)
        selfView.serviceDescView.addSubview(serviceDescScrollLabel)
        
        return selfView
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //return
        if firstLayout && serviceListModel != nil {
            
            if let starRateView = serviceRatingView.subviews.last as!
                CWStarRateView? {
                    let frame = serviceRatingView.bounds
                    starRateView.frame = frame
            }
            if let nameLabel = serviceNameView.subviews.last as! AIScrollLabel? {
                if let nameLabelText = serviceListModel!.service_name {
                    nameLabel.frame = serviceNameView.bounds
                    nameLabel.text = nameLabelText as String
                    if selected {
                        nameLabel.startScroll()
                    }
                }
            }
            
            if let descLabel = serviceDescView.subviews.last as! AIScrollLabel?{
                if let descLabelText = serviceListModel!.service_intro {
                    descLabel.frame = serviceDescView.bounds
                    descLabel.text = descLabelText as String
                    if selected {
                        descLabel.startScroll()
                    }
                }
            }
            firstLayout = false
        }
        
    }
    
    // MARK: - utils
    
    func buildViewData(serviceListModel: ServiceList){
        
        self.serviceListModel = serviceListModel
        
        //        if let nameLabel = serviceNameView.subviews.last as! AIScrollLabel? {
        //            if let nameLabelText = serviceListModel.service_name {
        //                nameLabel.text = nameLabelText as String
        //                nameLabel.startScroll()
        //            }
        //        }
        //
        //        if let descLabel = serviceDescView.subviews.last as! AIScrollLabel? {
        //            if let descLabelText = serviceListModel.service_intro {
        //                descLabel.text = descLabelText as String
        //                descLabel.startScroll()
        //            }
        //
        //        }
        
        if let sPriceModel = serviceListModel.service_price{
            servicePriceLabel.text = sPriceModel.price_show as String
        }
        starRateView = CWStarRateView(frame: serviceRatingView.bounds, numberOfStars: 5)
        starRateView?.allowIncompleteStar = true
        starRateView!.scorePercent = CGFloat(serviceListModel.service_rating!)
        serviceRatingView.addSubview(starRateView!)
        
        if let url = serviceListModel.service_intro_img {
            serviceImg.sd_setImageWithURL(url.toURL() , placeholderImage: UIImage(named: "Placehold"),completed:{
                (image,error,cacheType,imageURL) -> Void in
                if let _ = image {
                    self.originBackgroundImg = image
                    self.grayBackgroundImg = AITools.convertImageToGrayScale(image)
                }
                else{
                    self.originBackgroundImg = UIImage(named: "Placehold")
                    self.grayBackgroundImg = AITools.convertImageToGrayScale(self.originBackgroundImg)
                }
                //
                if !self.selected {
                    self.serviceImg.image = self.grayBackgroundImg
                }
            })
        }
        
        //        let frame = serviceRatingView.bounds
        //        starRateView?.frame = frame
        
        buildLayout()
        
    }
    
    func reloadData(serviceListModel : ServiceList){
        self.serviceListModel = serviceListModel
        let price = serviceListModel.service_price.price_show as String
        servicePriceLabel.text = price
        starRateView!.scorePercent = CGFloat(serviceListModel.service_rating!)
        serviceImg.sd_setImageWithURL(serviceListModel.service_intro_img?.toURL()!, placeholderImage: UIImage(named: "Placehold"),completed:{
            (image,error,cacheType,imageURL) -> Void in
            if let _ = image {
                self.originBackgroundImg = image
                self.grayBackgroundImg = AITools.convertImageToGrayScale(image)
            }
            else{
                self.originBackgroundImg = UIImage(named: "Placehold")
                self.grayBackgroundImg = AITools.convertImageToGrayScale(self.originBackgroundImg)
            }
            if !self.selected {
                self.serviceImg.image = self.grayBackgroundImg
            }
        })
        
        firstLayout = true
        
        
    }
    
    func buildLayout(){
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.userInteractionEnabled = true
    }
    
    func selectAction(){
        if selected{
            serviceImg.image = originBackgroundImg
            backGroundColorView.backgroundColor = UIColor(hex: "#9f97c6")
            selectFlagImage.hidden = false
            if let scrollLabel1 = serviceNameView.subviews.last as! AIScrollLabel?{
                scrollLabel1.startScroll()
            }
            if let scrollLabel2 = serviceDescView.subviews.last as! AIScrollLabel?{
                scrollLabel2.startScroll()
            }
        }
        else{
            serviceImg.image = grayBackgroundImg
            backGroundColorView.backgroundColor = UIColor(hex: "#444242")
            selectFlagImage.hidden = true
            if let scrollLabel1 = serviceNameView.subviews.last as! AIScrollLabel?{
                scrollLabel1.stopScroll()
            }
            if let scrollLabel2 = serviceDescView.subviews.last as! AIScrollLabel?{
                scrollLabel2.stopScroll()
            }
        }
    }
}
