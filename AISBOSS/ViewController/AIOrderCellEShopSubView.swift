//
//  AIOrderCellEShopSubView.swift
//  AIVeris
//
//  Created by 刘先 on 15/10/23.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring

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
        selfView.statusLabel.layer.cornerRadius = 3
        selfView.statusLabel.layer.masksToBounds = true
        selfView.statusLabel.font = AITools.myriadLightSemiCondensedWithSize(36 / PurchasedViewDimention.CONVERT_FACTOR)
        selfView.offerNameLabel.font = PurchasedViewFont.ESHOP_OFFER_NAME
        selfView.offerPriceLabel.font = AITools.myriadLightSemiCondensedWithSize(56 / PurchasedViewDimention.CONVERT_FACTOR)
        return selfView
    }
    
    func setGoods(model: GoodsDetailItemModel) {
        offerNameLabel.text = model.item_desc
        offerPriceLabel.text = model.item_price
        statusLabel.text = model.item_state
        
        ImageLoader.sharedLoader.imageForUrl(model.item_url) { (image, url) -> () in
            if let img = image {
                self.offerIconImageView.image = img
            }
        }
    }


}

class AIOrderCellEShopView : UIView {
    
    let SUB_VIEW_HEIGHT : CGFloat = 104
    
    private var goodsListModel: GoodsListMode?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var goodsList: GoodsListMode? {
        get {
            return goodsListModel
        }
        
        set {
            goodsListModel = newValue
            if let models = goodsListModel {
                for subView in subviews {
                    subView.removeFromSuperview()
                }
                
                for var index = 0; index < models.item_list.count; index++ {
                    if let model = models.item_list[index] as? GoodsDetailItemModel {
                        let subView = AIOrderCellEShopSubView.currentView()
                        subView.frame = CGRectMake(0, SUB_VIEW_HEIGHT * CGFloat(index), self.frame.width, SUB_VIEW_HEIGHT)
                        subView.setGoods(model)
                        addSubview(subView)
                    }
                }
                
                adjustViewFrame()
            }
        }
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
        if let models = goodsListModel {
            frame.size.height = CGFloat(models.item_list.count) * SUB_VIEW_HEIGHT
        }
    }
}
