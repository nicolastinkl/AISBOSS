//
//  AICustomerBannerView.swift
//  AIVeris
//
//  Created by 刘先 on 16/5/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AICustomerBannerView: UIView {
    
//    override init(coder: aDecoder)
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var customerDescLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelfFromXib()
    }
 
    
    init() {
        super.init(frame: .zero)
        self.initSelfFromXib()
    }
    
    func loadData(){
        userIconImageView.image = UIImage(named: "Avatorbibo")
    }
}
