//
//  AISinglePickerView.swift
//  AIVeris
//
//  Created by tinkl on 1/26/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

//pickview 选择器
public class AISinglePickerView: UIView {    
    
    @IBOutlet weak var pickOneView: UIPickerView!

    var superViewID:String = ""
    
    private let DIYSuperView = UIView()
    
    private var dataSource:[AIOptionModel] = {
        //构造函数
        
        var option1 = AIOptionModel()
        option1.desc = "2 bedrooms"
        option1.identifier = "4322345678"
        option1.isSelected = true
        option1.displayColor = "#534F5D"
        
        var option2 = AIOptionModel()
        option2.desc = "bedrooms False"
        option2.identifier = "213456"
        option2.isSelected = false
        option2.displayColor = "#534F5D"
        
        return [option1,option2,option2,option2]
        
    }()
    
    private var currentModel:AIOptionModel?
    
    public func show(){
        
        if let superView = UIApplication.sharedApplication().keyWindow {
            DIYSuperView.frame = superView.frame
            superView.addSubview(DIYSuperView)
            DIYSuperView.backgroundColor = UIColor(hexString: "#534F5D", alpha: 0.5)
            DIYSuperView.alpha = 0
            
            DIYSuperView.addSubview(self)
            self.alpha = 0
            self.setWidth(superView.width)
            pickOneView.reloadAllComponents() 
            
            currentModel = dataSource.first
            
            SpringAnimation.spring(0.3, animations: { () -> Void in
                self.alpha = 1
                self.DIYSuperView.alpha = 1
                self.setTop(self.DIYSuperView.height - self.height)
                
            })
            
        }
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.DIYSuperView.alpha = 0
            }, completion: { finished in
                self.DIYSuperView.removeFromSuperview()
                
        })
        
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        if let model = currentModel{
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AISinglePickerViewNotificationName, object: ["model":model,"ID":superViewID])
        }
        
        UIView.animateWithDuration(0.3, animations: {
            self.DIYSuperView.alpha = 0
            }, completion: { finished in
                self.DIYSuperView.removeFromSuperview()
                
        })
    }
    
    
    class func currentView()->AISinglePickerView{
        
        let selfview =  NSBundle.mainBundle().loadNibNamed("AISinglePickerView", owner: self, options: nil).first  as! AISinglePickerView
        return selfview
    }
    
}

extension AISinglePickerView: UIPickerViewDataSource,UIPickerViewDelegate {
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let model = dataSource[row] as AIOptionModel
        currentModel = model
        
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        let model = dataSource[row] as AIOptionModel
        return model.desc
        
    }
    
}