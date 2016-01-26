//
//  AIInputView.swift
//  AIVeris
//
//  Created by 王坜 on 16/1/22.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Foundation

class AIInputView: UIView {

    //MARK: Constants
    let margin : CGFloat = 10
    
    //MARK: Variables
    
    var titleLabel : UPLabel?
    
    var textField : UITextField!
    
    var tailLabel : UPLabel?
    
    var textLabel : UPLabel!
    
    var maskedView : UIView?
    
    weak var root :UIViewController?
    
    var displayModel : AIInputViewModel?
    
    //MARK: Override
    
    init(frame : CGRect, model: AIInputViewModel?) {
        super.init(frame: frame)
        displayModel = model
        
        if let _ = model {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
            makeSubViews()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func makeSubViews () {
        
        let width = CGRectGetWidth(self.frame)
        var y : CGFloat = 0
        //TODO: make title
        
        if let title = displayModel?.title {
            let titleSize = title.sizeWithFont(AITools.myriadLightSemiCondensedWithSize(16), forWidth: width)
            titleLabel = AIViews.wrapLabelWithFrame(CGRectMake(0, y, width, titleSize.height), text: title, fontSize: 16, color: UIColor.whiteColor());
            self.addSubview(titleLabel!)
            
            y += titleSize.height + margin
        }
        
        //TODO: make textLabel
        
        let textSize : CGSize = CGSizeMake(width, 35)
        
//        if let defaultTitle = displayModel?.defaultText {
//            textSize = defaultTitle.sizeWithFont(AITools.myriadLightSemiCondensedWithSize(16), forWidth: width)
//        }
        
        textLabel = AIViews.wrapLabelWithFrame(CGRectMake(0, y, width, textSize.height), text: "", fontSize: 16, color: UIColor.whiteColor())
        textLabel.backgroundColor = UIColor.whiteColor()
        textLabel.layer.cornerRadius = 4
        textLabel.layer.masksToBounds = true
        textLabel.text = displayModel!.defaultText
        textLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "showKeyboard"))
        self.addSubview(textLabel)
        
        //TODO: make tailLabel
        if let tail = displayModel?.tail {
            y += textSize.height
            
            let tailSize = tail.sizeWithFont(AITools.myriadLightSemiCondensedWithSize(16), forWidth: width)
            
            tailLabel = AIViews.wrapLabelWithFrame(CGRectMake(0, y, width, tailSize.height), text: tail, fontSize: 16, color: UIColor.whiteColor())
            self.addSubview(tailLabel!)
        }
    
       
        
        
    }
    
    
    func showKeyboard () {
        // make textTield
        guard let _ = root else {
            return
        }
        
        maskedView = UIView(frame: root!.view.bounds)
        
        root!.view.addSubview(maskedView!)
        
        
        let blurEffect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = maskedView!.bounds
        
        
        //
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = NSNumber(float: 0)
        animation.toValue = NSNumber(float: 1)
        animation.duration = 0.2
        animation.removedOnCompletion = true
        blurView.layer.addAnimation(animation, forKey: "opacity")
        
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissMaskedView"))
        //
        
        maskedView?.addSubview(blurView)
        
        
        //TODO: add textField
        textField = UITextField(frame: CGRectMake(0, y, width, 35))
        textField.borderStyle = .RoundedRect
        textField.clearButtonMode = .WhileEditing
        textField.placeholder = "请输入..."
        textField.frame = CGRectMake(10, CGRectGetHeight(self.frame) / 2, CGRectGetWidth(self.frame) - 30, 35)
        if let text = displayModel?.defaultText {
            textField.text = text
        }
        textField.delegate = self
        textField.becomeFirstResponder()
        maskedView!.addSubview(textField!)
        
        
    }
    
    func dismissMaskedView () {
        if let _ = maskedView {
            maskedView?.removeFromSuperview()
            maskedView = nil
        }
        
        textLabel.text = textField.text
    }
    
    //MARK: Keyboard Notification
    func keyboardWillShow(notification : NSNotification) {
        
        if let userInfo = notification.userInfo {
           
            let keyboardRectValue : NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            let keyboardRect : CGRect = keyboardRectValue.CGRectValue()
            let keyboardHeight : CGFloat = min(CGRectGetHeight(keyboardRect), CGRectGetWidth(keyboardRect))
            
            if let _ = textField {
                
                textField.frame = CGRectMake(10, CGRectGetHeight(self.frame) - 30 - keyboardHeight, CGRectGetWidth(self.frame) - 30, 35)
                
            }
            
        }
    }
    
}

extension AIInputView: UITextFieldDelegate {
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        textField.text = textLabel.text
        return true
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textLabel.text = textField.text
        
        return true
    }
}
