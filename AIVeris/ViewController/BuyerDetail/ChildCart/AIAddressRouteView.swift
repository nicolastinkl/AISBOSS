//
//  AIAddressRouteView.swift
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

/// 横向滚动路径规划视图
class AIAddressRouteView: UIView {
    
    @IBOutlet weak var address: DesignableLabel!
    
    @IBOutlet weak var line: UIView!
    
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        line.backgroundColor = UIColor(hexString: AIApplication.AIColor.MainSystemLineColor, alpha: 0.2)
    }
    
    func fillData(model: AIServiceRouteAddressModel){
        address.hidden = false
        time.hidden = false
        address.text = model.sr_address_name
        time.text = "\(model.sr_address_hour) days"
    }
    
    func clearText(){
        address.hidden = true
        time.hidden = true
        line.hidden = true
        address.text = ""
        time.text = ""
    }
}