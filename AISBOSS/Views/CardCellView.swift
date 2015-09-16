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
    // MARK: - uiview variables

    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var serviceDescLabel: UILabel!
    @IBOutlet weak var servicePriceLabel: UILabel!
    @IBOutlet weak var serviceRatingView: UIView!
    @IBOutlet weak var serviceImg: AIImageView!
    
    // MARK: - init method
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - utils
    
    func buildViewData(serviceListModel : ServiceList){
        serviceNameLabel.text = serviceListModel.service_name
        serviceDescLabel.text = serviceListModel.service_intro ?? ""
        servicePriceLabel.text = serviceListModel.service_price
        let starRateView : UIView = CWStarRateView(frame: serviceRatingView.bounds, numberOfStars: 5)
        serviceRatingView.addSubview(starRateView)
        //serviceImg
        serviceImg.setURL(NSURL(string: serviceListModel.service_img), placeholderImage: UIImage(named: "Placeholder"))
        
    }
    
    func selectAction(selected : Bool){
        if selected{
            
        }
        else{
            
        }
    }
}
