//
//  AIConfirmOrderCellView.swift
//  AIVeris
//
// Copyright (c) 2016 ___ASIAINFO___
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/// 确定订单确认视图Cell
class AIConfirmOrderCellView: UIView {
    
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.title.font = AITools.myriadLightSemiCondensedWithSize(48 / PurchasedViewDimention.CONVERT_FACTOR)
        
        self.price.font = AITools.myriadLightSemiCondensedWithSize(56 / PurchasedViewDimention.CONVERT_FACTOR)
        
        self.price.textColor = UIColor(hexString: "fee300", alpha: 1)
        
    }
    
    func initData(model : AIProposalServiceModel){
        
        title.text = model.service_desc
        
        price.text = "\(model.service_price.original)"
        
        imageview.setImageWithURL(NSURL(string: "\(model.service_thumbnail_icon)"))
        
    }
    
}