//
//  AIShoppingListViewCell.swift
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
import Cartography
import Spring


class AIShoppingListViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: AIImageView!

    @IBOutlet weak var title: UILabel!

    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var countView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.font = AITools.myriadSemiCondensedWithSize(14)
        price.font = AITools.myriadBoldWithSize(16)
        price.textColor = UIColor(hex: "#CBAB00")
        
        if let sview = AINumberCountControl.initFromNib() {
            countView.addSubview(sview)            
            sview.backgroundColor = UIColor.clearColor()
            
            constrain(sview) { (layout) in
                
                layout.right == layout.superview!.right
                layout.top == layout.superview!.top
                layout.height == 30
                layout.width == 100
                
            }
            
        }
        
    }
    
    func fillDataWithModel(model: AIShoppingModel){
        let url = NSURL(string: model.shopping_image_url ?? "")!
        iconImageView.setURL(url, placeholderImage: smallPlace())
        
        title.text = model.shopping_title ?? ""
        price.text = model.shopping_price ?? ""
        
        if let sview = countView.subviews.first as? AINumberCountControl {
            sview.textInput.text = "\(model.shopping_number ?? 0)"
        }        
        
    }
    
    
}






