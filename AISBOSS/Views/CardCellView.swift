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
    var serviceListModel : ServiceList!
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
        return selfView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        starRateView?.frame = serviceRatingView.bounds
        if firstLayout{
            let serviceName : String = serviceListModel.service_name ?? ""
            serviceNameScrollLabel = AIScrollLabel(frame: serviceNameView.bounds, text: serviceName, color: UIColor.whiteColor(), scrollEnable: true)
            serviceNameView.addSubview(serviceNameScrollLabel!)
            let serviceDesc : String = serviceListModel.service_intro ?? ""
            serviceDescScrollLabel = AIScrollLabel(frame: serviceDescView.bounds, text: serviceDesc, color: UIColor.whiteColor(), scrollEnable: true)
            serviceDescView.addSubview(serviceDescScrollLabel!)
            
            firstLayout = false
        }
        
    }
    
    
    // MARK: - utils
    
    func buildViewData(serviceListModel : ServiceList){
        self.serviceListModel = serviceListModel
        
        servicePriceLabel.text = serviceListModel.service_price ?? ""
        starRateView = CWStarRateView(frame: serviceRatingView.bounds, numberOfStars: 5)
        serviceRatingView.addSubview(starRateView!)
       //(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL);
        serviceImg.sd_setImageWithURL(serviceListModel.service_img?.toURL()!, placeholderImage: UIImage(named: "Placehold"),completed:{
            (image,error,cacheType,imageURL) -> Void in
            if imageURL == ""{
                self.originBackgroundImg = UIImage(named: "Placehold")
                self.grayBackgroundImg = AITools.convertImageToGrayScale(self.originBackgroundImg)

            }
            else{
                self.originBackgroundImg = image
                self.grayBackgroundImg = AITools.convertImageToGrayScale(image)
            }
            
        })
        //serviceImg
        //serviceImg.setURL(serviceListModel.service_img?.toURL()!, placeholderImage: UIImage(named: "Placehold"))
        
        buildLayout()
    }
    
    func reloadData(serviceListModel : ServiceList){
        self.serviceListModel = serviceListModel
        servicePriceLabel.text = serviceListModel.service_price ?? ""
        starRateView!.scorePercent = CGFloat(serviceListModel.service_rating!)
        serviceImg.sd_setImageWithURL(serviceListModel.service_img?.toURL()!, placeholderImage: UIImage(named: "Placehold"),completed:{
            (image,error,cacheType,imageURL) -> Void in
            if imageURL == ""{
                self.originBackgroundImg = UIImage(named: "Placehold")
                self.grayBackgroundImg = AITools.convertImageToGrayScale(self.originBackgroundImg)
                
            }
            else{
                self.originBackgroundImg = image
                self.grayBackgroundImg = AITools.convertImageToGrayScale(image)
            }
            
        })
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
            if let scrollLabel1 = serviceNameScrollLabel{
                scrollLabel1.startScroll()
            }
            if let scrollLabel2 = serviceDescScrollLabel{
                scrollLabel2.startScroll()
            }
        }
        else{
            serviceImg.image = grayBackgroundImg
            backGroundColorView.backgroundColor = UIColor(hex: "#444242")
            selectFlagImage.hidden = true
            if let scrollLabel1 = serviceNameScrollLabel{
                scrollLabel1.stopScroll()
            }
            if let scrollLabel2 = serviceDescScrollLabel{
                scrollLabel2.stopScroll()
            }
        }
    }
}
