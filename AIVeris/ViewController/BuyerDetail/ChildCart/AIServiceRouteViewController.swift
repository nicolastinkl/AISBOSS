//
//  AIServiceRouteViewController.swift
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
import UIKit

import Cartography
import Spring
import AIAlertView

class  AIServiceRouteViewController: UIViewController {
     
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var preCacheView: UIView?
    
    private var buttonSelected: UIButton = {
        let button = UIButton(type: .Custom)
        button.titleLabel?.textColor = UIColor.whiteColor()
        button.titleLabel?.font = AITools.myriadSemiCondensedWithSize(15)
        button.setHeight(50)
        button.addBottomWholeSSBorderLine()
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize.height = 20
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Add Destination View and Departure View.
        
        if let routeView = AIServiceRouteView.initFromNib() {
            addNewSubView(routeView)
            (routeView as! AIServiceRouteView).refereshLine()
        }
        
        if let sview = AIDepartReahCityView.initFromNib() {
            addNewSubView(sview)
        }
        
        if let sview = AIStartEndTimeView.initFromNib() {
            addNewSubView(sview)
        }
        
        if let sview = AIEventCapacityView.initFromNib() {
            addNewSubView(sview)
        }
        
    }
    
    func addNewSubView(cview:UIView){
        scrollView.addSubview(cview)
        cview.setWidth(self.view.width)
        cview.setTop(scrollView.contentSize.height)
        cview.backgroundColor = UIColor.clearColor()
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), cview.top + cview.height)
        preCacheView = cview
        
    }
    
    func finishExecEvent(){
        self.cancelClick()
    }
    
    
}