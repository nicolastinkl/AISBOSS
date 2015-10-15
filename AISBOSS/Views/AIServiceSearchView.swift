//
//  AIServiceSearchView.swift
//  AITrans
//
//  Created by wantsor on 15/7/8.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

import UIKit
import AISpring

protocol ServiceSearchViewDelegate : class{
    func complateWithTextView(text:String?)
}

class AIServiceSearchView: UIView,UITextFieldDelegate {

    let buttonMarginRight:CGFloat = 12
    let buttonMarginTop:CGFloat = 10
    let buttonHeight:CGFloat = 20
    let resultViewPaddingTop:CGFloat = 15
    let resultViewPaddingLeft:CGFloat = 12
    
    let searchResultViewHeight:CGFloat = 80
    
    var isSearching = false
    
    weak var searchDelegate: ServiceSearchViewDelegate?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    // MARK: - outlet variable
    @IBOutlet weak var searchResultView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var dotImage: UIImageView!
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var arrowTopImage: UIImageView!
    
    @IBAction func closeSearchAction(sender: UIButton) {
        springWithCompletion(1, animations: { () -> Void in
            self.alpha = 0
            self.setTop(UIScreen.mainScreen().bounds.height)
        }) { (complete) -> Void in
            //self.removeFromSuperview()
        }
        searchTextField.resignFirstResponder()
    }
    
    // MARK: - textfield delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print(textField.text)
        buildSearchResult()
        setSearchingViewAttr()
        return true
    }
    
    func textChangedAction(sender:UITextField){
        print("value changed ,text:\(sender.text)")
        buildSearchResult()
        setSearchingViewAttr()
    }
    
    
    func initDefaultViewAttr() {
        searchResultView.layer.cornerRadius = 10
        searchResultView.layer.masksToBounds = true
        searchTextField.keyboardType = UIKeyboardType.Default
        searchTextField.returnKeyType = UIReturnKeyType.Search
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: "textChangedAction:", forControlEvents: UIControlEvents.EditingChanged)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "submitSearchAction", name: uik, object: <#AnyObject?#>)
        
       setInitViewAttr()
    }
    
    func setInitViewAttr(){
        //初始是隐藏搜索结果框的
        searchResultView.alpha = 0
        searchResultView.setHeight(0)
        dotImage.alpha = 0
        lineLabel.alpha = 0
        arrowTopImage.alpha = 0
        searchTextField.text = ""
        isSearching = false
    }
    
    func setSearchingViewAttr(){
        if !isSearching {
            spring(1, animations: {
                self.searchResultView.alpha = 1
                self.searchResultView.setHeight(self.searchResultViewHeight)
                self.dotImage.alpha = 1
                self.lineLabel.alpha = 1
                self.arrowTopImage.alpha = 1
            })
            isSearching = true
        }
    }
    
    // MARK: - view function
    func buildSearchResult(){
        let serviceList = [["air","affects","alpha","animation"],["bounds","buildResultButton","button","buttonPointY","blue shit","backup"],["code","complete","currentView","customer","cutoff"]]
        clearSearchResult()
        var rect = CGRectMake(0, resultViewPaddingTop, 0, 0)
        let randomInt:Int = Int(arc4random() % 3)
        for serviceName in serviceList[randomInt] {
            let newButton = buildResultButton(serviceName,rect : rect)
            rect = newButton.frame
            self.searchResultView.addSubview(newButton)
        }
    }
    
    func clearSearchResult(){
        //remove subview first
        for subView in searchResultView.subviews as [UIView] {
            if subView.isMemberOfClass(UIButton){
                subView.removeFromSuperview()
            }
        }
    }
    
    func buildResultButton(serviceName:String,rect:CGRect) -> UIButton{
        let button = UIButton()
        let point = rect.origin
        let size = rect.size
        let font = UIFont.systemFontOfSize(12)
        let stringSize = NSString(string: serviceName).sizeWithAttributes([NSFontAttributeName:font])
        let resultViewWidth = searchResultView.frame.width
        let newButtonWidth = stringSize.width + 15
        //if is first button ,x equals buttonMarginRight
        let calPointX = point.x == 0 ? resultViewPaddingLeft : point.x + size.width + buttonMarginRight
        let buttonPointX = calPointX + newButtonWidth > resultViewWidth ? buttonMarginRight : calPointX
        let buttonPointY = calPointX + newButtonWidth > resultViewWidth ? point.y + buttonMarginTop + buttonHeight : point.y
        
        button.frame = CGRectMake(buttonPointX, buttonPointY
            , newButtonWidth, buttonHeight)
        button.titleLabel?.font = font
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle(serviceName, forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "search_result_button_normal"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "search_result_button_pressed"), forState: UIControlState.Highlighted)
        button.addTarget(self, action: "selectResultAction:", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
    func selectResultAction(sender:UIButton){
        springWithCompletion(1, animations: { () -> Void in
            self.alpha = 0
            self.setTop(UIScreen.mainScreen().bounds.height)
            }) { (complete) -> Void in
                //self.removeFromSuperview()
        }
        searchDelegate?.complateWithTextView(sender.titleLabel?.text)
        searchTextField.resignFirstResponder()
    }
    
    class func currentView()->AIServiceSearchView{
        let view = NSBundle.mainBundle().loadNibNamed("AIServiceSearchView", owner: self, options: nil).first as! AIServiceSearchView
        view.initDefaultViewAttr()
        return view
    }
}
