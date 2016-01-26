//
//  AISinglePickerView.swift
//  AIVeris
//
//  Created by tinkl on 1/26/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

public class AISinglePickerView: UIView {    
    
    @IBOutlet weak var pickOneView: UIPickerView!
    
    private var dataSource:[AIOptionModel] = {
        //构造函数
        
        var option1 = AIOptionModel()
        option1.desc = "2 bedrooms"
        option1.identifier = "4322345678"
        option1.isSelected = true
        option1.displayColor = "#534F5D"
        
        return [option1,option1,option1,option1,option1,option1,option1]
        
    }()
    
    public func show(){
        
        if let superView = UIApplication.sharedApplication().keyWindow {
            superView.addSubview(self)
            pickOneView.reloadAllComponents()
            //pickOneView.selectRow(3, inComponent: 1, animated: false)
            self.setWidth(superView.width)
            self.setTop(superView.height - self.height)
        }
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        self.removeFromSuperview()
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        
        
        self.removeFromSuperview()
        
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
        // let model = dataSource[row] as AIOptionModel
        
        
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        let model = dataSource[row] as AIOptionModel
        return model.desc
        
    }
    
}