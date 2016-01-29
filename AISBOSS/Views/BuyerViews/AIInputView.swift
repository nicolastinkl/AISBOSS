//
//  AIInputView.swift
//  AIVeris
//
//  Created by 王坜 on 16/1/22.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Foundation

class AIInputView: AIServiceParamBaseView {

    //MARK: Constants
    let margin : CGFloat = 10
    
    //MARK: Variables
    
    var keyboardDidShow: Bool = false
    
    var titleLabel: UPLabel?
    
    var textField: UITextField!
    
    var tailLabel: UPLabel?
    
    var textLabel: UPLabel!
    
    var maskedView: UIView?
    
    weak var root: UIViewController?
    
    var displayModel: AIInputViewModel?
    
    //MARK: Override
    
    init(frame : CGRect, model: AIInputViewModel?) {
        super.init(frame: frame)
        displayModel = model
        
        if let _ = model {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
            makeSubViews()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeSubViews () {
        
        let width = CGRectGetWidth(self.frame)
        let height:CGFloat = 35
        let margin:CGFloat = 5
        
        textLabel = AIViews.wrapLabelWithFrame(CGRectMake(0, 0, width, height), text: displayModel?.defaultText ?? "", fontSize: 16, color: UIColor.whiteColor())
        textLabel.backgroundColor = UIColor.whiteColor()
        textLabel.textColor = UIColor.grayColor()
        textLabel.layer.cornerRadius = 4
        textLabel.layer.masksToBounds = true
        textLabel.text = displayModel!.defaultText ?? ""
        textLabel.userInteractionEnabled = true
        textLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "showKeyboard"))
        
        self.addSubview(textLabel)
        if let title = displayModel?.title {
            let titleSize = title.sizeWithFont(AITools.myriadLightSemiCondensedWithSize(16), forWidth: width)
            titleLabel = AIViews.wrapLabelWithFrame(CGRectMake(0, 0, width, titleSize.height), text: title, fontSize: 16, color: UIColor.whiteColor());
            titleLabel?.sizeToFit()
            titleLabel?.setCenterY(height/2)
            self.addSubview(titleLabel!)
            
            textLabel.setLeft((titleLabel?.right)!+margin)
            textLabel.setWidth(textLabel.width - (titleLabel?.width)! - margin)
        }
        
        //TODO: make textLabel
        
        
        //TODO: make tailLabel
        if let tail = displayModel?.tail {
            let tailSize = tail.sizeWithFont(AITools.myriadLightSemiCondensedWithSize(16), forWidth: width)
            tailLabel = AIViews.wrapLabelWithFrame(CGRectMake(0, 0, width, tailSize.height), text: tail, fontSize: 16, color: UIColor.whiteColor())
            tailLabel?.sizeToFit()
            tailLabel?.setCenterY(height/2)
            tailLabel?.setRight(width)
            textLabel.setWidth(textLabel.width - (tailLabel?.width)! - margin)
            self.addSubview(tailLabel!)
        }
        
    
        var frame = self.frame
        frame.size.height = textLabel.height
        self.frame = frame
        
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
        textField = UITextField(frame: CGRectMake(0, CGRectGetHeight(maskedView!.frame) - 35, width, 35))
        textField.borderStyle = .RoundedRect
        textField.clearButtonMode = .WhileEditing
        textField.placeholder = "请输入..."
        textField.frame = CGRectMake(10, CGRectGetHeight(maskedView!.frame) - 35, CGRectGetWidth(self.frame) - 20, 35)
        if let text = displayModel?.defaultText {
            textField.text = text
        }
        textField.delegate = self
        textField.becomeFirstResponder()
        maskedView!.addSubview(textField!)
    }
    
    func dismissMaskedView () {
        if let _ = maskedView {
            textLabel.text = textField.text
            maskedView?.removeFromSuperview()
            maskedView = nil
        }
    }
    
    //MARK: Keyboard Notification
    func keyboardWillShow(notification : NSNotification) {
        if keyboardDidShow {
            return
        }
        
        if let userInfo = notification.userInfo {
           
            let keyboardRectValue : NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            let keyboardRect : CGRect = keyboardRectValue.CGRectValue()
            let keyboardHeight : CGFloat = min(CGRectGetHeight(keyboardRect), CGRectGetWidth(keyboardRect))
            let duration : NSNumber = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
            if keyboardHeight > 0 {
                keyboardDidShow = true
                if let _ = textField {
                    
                    weak var wf = self
                    UIView.animateWithDuration(duration.doubleValue as NSTimeInterval, animations: { () -> Void in
                        wf!.textField.frame = CGRectMake(10, CGRectGetHeight(wf!.maskedView!.frame) - 130 - keyboardHeight, CGRectGetWidth(wf!.maskedView!.frame) - 20, 35)
                    })
                }
            }
        }
    }
    
    func keyboardDidHide(notification : NSNotification) {
        keyboardDidShow = false
    }
    
    override func serviceParamsList() -> [AnyObject]! {
        
        var params : [AnyObject] = [AnyObject]()
        let source : String? = displayModel?.displayParams["param_source"] as? String
        var serviceParam = [NSObject : AnyObject]()
        serviceParam["source"] = source ?? ""
        serviceParam["role_id"] = ""
        serviceParam["service_id"] = displayModel?.service_id_save ?? ""
        serviceParam["product_id"] = ""
        serviceParam["param_key"] = displayModel?.displayParams["param_key"] ?? ""
        serviceParam["param_value"] = [textLabel?.text ?? ""]
        serviceParam["param_value_id"] = ""
        params.append(serviceParam)
        
        
        return params
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
