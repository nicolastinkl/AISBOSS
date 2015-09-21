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
    var starRateView : UIView?
    // MARK: - uiview variables

    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var serviceDescLabel: UILabel!
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
    }
    
    
    // MARK: - utils
    
    func buildViewData(serviceListModel : ServiceList){
        serviceNameLabel.text = serviceListModel.service_name ?? ""
        serviceDescLabel.text = serviceListModel.service_intro ?? ""
        servicePriceLabel.text = serviceListModel.service_price ?? ""
        starRateView = CWStarRateView(frame: serviceRatingView.bounds, numberOfStars: 5)
        serviceRatingView.addSubview(starRateView!)
       //(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL);
        serviceImg.sd_setImageWithURL(serviceListModel.service_img?.toURL()!, placeholderImage: UIImage(named: "Placehold"),completed:{
            (image,error,cacheType,imageURL) -> Void in
            self.originBackgroundImg = image
        })
        //serviceImg
        //serviceImg.setURL(serviceListModel.service_img?.toURL()!, placeholderImage: UIImage(named: "Placehold"))
        
        buildLayout()
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
        }
        else{
            if let image = grayBackgroundImg{
                serviceImg.image = image
            }
            else{
                let originImg = serviceImg.image
                let grayImg = AITools.convertImageToGrayScale(originImg)
                grayBackgroundImg = grayImg
                serviceImg.image = grayImg
            }
            backGroundColorView.backgroundColor = UIColor(hex: "#444242")
            selectFlagImage.hidden = true
        }
    }
}
