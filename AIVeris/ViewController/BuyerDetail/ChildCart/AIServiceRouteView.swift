//
//  AIServiceRouteView.swift
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
import Spring

/// Route 路线规划视图
class AIServiceRouteView: UIView {
    
    private let tagMargin:CGFloat = 5
    
    private var cityArray: [String]?
    
    @IBOutlet weak var tagView: UIView!
    
    private let lineColor: String = "#D2D5E7"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cityArray = ["Beijing","Tianjin","Qingdao","Anhui","Wuhan","Qingdao"]
        
        
    }
    
    func refereshCitys(){
        self.refereshCitysUI()
    }
    
    func refereshCitysUI(){
        
        
        var x:CGFloat = tagMargin
        var y:CGFloat = 0
        var n = 0
        
        for city in cityArray! {
            
            let label = DesignableLabel()
            label.font = AITools.myriadLightSemiCondensedWithSize(14)
            label.text = city
            label.textColor = UIColor.whiteColor()
            label.borderColor = UIColor.whiteColor()
            label.borderWidth = 0.5
            label.cornerRadius = 4
            label.textAlignment = .Center
            label.alpha = 0
            tagView.addSubview(label)
            
            let ramdWidthOLD = 45 + city.length * 6
            let sizenew = city.sizeWithFont(AITools.myriadLightSemiCondensedWithSize(35/2.5), forWidth: CGFloat(ramdWidthOLD))
            let ramdWidth = sizenew.width  + 10
            let ramdHeigth:CGFloat = 20
            
            if (x + CGFloat(ramdWidth) + tagMargin) > (tagView.width - tagMargin) {
                n = 0
                x = tagMargin
                y += ramdHeigth + tagMargin
                
            } else {
                if n > 0 {
                    x = x + tagMargin
                }
            }
            
            label.setOrigin(CGPointMake(x, y))
            
            n = n + 1  //   Add 1
            label.setSize(CGSize(width: CGFloat(ramdWidth), height: ramdHeigth))
            
            x = x + CGFloat(ramdWidth)
            
            SpringAnimation.springEaseIn(0.3, animations: { 
                label.alpha = 1
            })
        }
        
    }
    
    
}

