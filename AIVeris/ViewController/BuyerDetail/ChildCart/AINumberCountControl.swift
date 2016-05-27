//
//  AINumberCountControl.swift
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

class AINumberCountControl: UIView {
    
    @IBOutlet weak var subtractButton: DesignableButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var addButton: DesignableButton!
    @IBOutlet weak var textInput: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let keboard = PMCustomKeyboard()
//        keboard.textView = textInput
        
    }
    
    @IBAction func subStractAction(sender: AnyObject) {
        
        let text = textInput.text ?? ""
        var float = Int(text) ?? 0
        if float == 1 {
            return
        }
        
        if float > 0 {
            float = float - 1
            textInput.text = "\(float)"
        }
        
        if float == 1 {
            subtractButton.enabled = false
            subtractButton.backgroundColor = UIColor(hex: "#7E7DB6")
        }
    }     
    
    @IBAction func addAction(sender: AnyObject) {
        let text = textInput.text ?? ""
        var float = Int(text) ?? 0
        float = float + 1
        textInput.text = "\(float)"
        
        if float > 1 {
            subtractButton.enabled = true
            subtractButton.backgroundColor = UIColor(hex: "#008BDF")
        }
    }
    
    
     
    
}