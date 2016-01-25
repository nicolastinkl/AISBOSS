//
//  AIDatePickerView.swift
//  AIVeris
//
//  Created by tinkl on 1/25/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

public enum UIPickViewTag:  Int {
    case month = 1
    case day = 2
}

public class AIDatePickerView: UIView {
    
    private lazy var months : [String]  = {
        return (1...12).map({"\($0)月"})
    }()
    
    private lazy var days : [String]  = {
        return (1...31).map({"\($0)"})
    }()
    
    @IBAction func closeAction(sender: AnyObject) {

    }
    
    @IBAction func doneAction(sender: AnyObject) {
        
    }
    
    @IBOutlet weak var pickOneView: UIPickerView!
    
    @IBOutlet weak var pickTwoView: UIPickerView!
    
    class func currentView()->AIDatePickerView{
        let view = NSBundle.mainBundle().loadNibNamed("AIDatePickerView", owner: self, options: nil).first as! AIDatePickerView
        return view
    }
    
}

extension AIDatePickerView: UIPickerViewDataSource,UIPickerViewDelegate {
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView.tag == UIPickViewTag.month.rawValue {
            12
        }
        return 31
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == UIPickViewTag.month.rawValue {
           
        }
       
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == UIPickViewTag.month.rawValue {
            12
        }
        return 31
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == UIPickViewTag.month.rawValue {
            return months[row]
        }
        return days[row]
    }
    
}