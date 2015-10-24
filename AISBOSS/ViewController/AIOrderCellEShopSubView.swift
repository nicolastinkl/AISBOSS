//
//  AIOrderCellEShopSubView.swift
//  AIVeris
//
//  Created by 刘先 on 15/10/23.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIOrderCellEShopSubView: UIView {

    @IBOutlet weak var offerIconImageView: UIImageView!
    @IBOutlet weak var offerNameLabel: UILabel!    
    @IBOutlet weak var offerPriceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    // MARK: currentView
    class func currentView()->AIOrderCellEShopSubView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AIOrderCellEShopSubView", owner: self, options: nil).first  as! AIOrderCellEShopSubView
        
        //config statusLabel
        selfView.statusLabel.layer.borderWidth = 1
        selfView.statusLabel.layer.borderColor = UIColor.whiteColor().CGColor
        selfView.statusLabel.layer.cornerRadius = 8
        selfView.statusLabel.layer.masksToBounds = true
        return selfView
    }


}

class AIOrderCellEShopView : UIView {
    
    let SUB_VIEW_HEIGHT : CGFloat = 104
    
    let dataSource = ["0","1"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func buildSubViews(){
        let subView1 = AIOrderCellEShopSubView.currentView()
        let frame1 = CGRectMake(0, 0, self.frame.width, SUB_VIEW_HEIGHT)
        subView1.frame = frame1
        
        let subView2 = AIOrderCellEShopSubView.currentView()
        let frame2 = CGRectMake(0, SUB_VIEW_HEIGHT, self.frame.width, SUB_VIEW_HEIGHT)
        subView2.frame = frame2
        
        self.addSubview(subView1)
        self.addSubview(subView2)
        
        adjustViewFrame()
    }
    
    func adjustViewFrame(){
        
        self.frame.size.height = CGFloat(dataSource.count) * SUB_VIEW_HEIGHT
    }
}
