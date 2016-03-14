//
//  OrderAndBuyerInfoView.swift
//  AIVeris
//
//  Created by admin on 16/3/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class OrderAndBuyerInfoView: UIView {

    @IBOutlet weak var buyerIcon: UIImageView!
    @IBOutlet weak var messageNumber: UILabel!
    @IBOutlet weak var buyerName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var percentageNumber: UILabel!
    @IBOutlet weak var progressBar: YLProgressBar!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    static func createInstance() -> OrderAndBuyerInfoView {
        let viewThis = NSBundle.mainBundle().loadNibNamed("OrderAndBuyerInfoView", owner: self, options: nil).first  as! OrderAndBuyerInfoView
        
        viewThis.messageNumber.layer.cornerRadius = viewThis.messageNumber.frame.width / 2
        viewThis.messageNumber.layer.masksToBounds = true
        return viewThis
    }
    

}
