//
//  AIDatePickerView.swift
//  AIVeris
//
//  Created by tinkl on 1/25/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Cartography
import Spring

public enum UIPickViewTag:  Int {
    case month = 1
    case day = 2
}

public class AIDatePickerView: AIServiceParamBaseView {
    
    private let DIYSuperView = UIView()
    
    @IBOutlet weak var pickOneView: UIPickerView!
    
    @IBOutlet weak var pickTwoView: UIPickerView!
    
    private var selectSource = [String:String]()
    
    private  var months : [String]  = {
        return ["January","February","March","April","May","June","July","August","September","Octomber","Novermber","December"]
//        return (1...12).map({"\($0)月"})
    }()
    
    private var days : [String]  = {
        return (1...31).map({"\($0)th"})
    }()
    
    @IBAction func closeAction(sender: AnyObject) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.DIYSuperView.alpha = 0
            }, completion: { finished in
                self.DIYSuperView.removeFromSuperview()
                
        })
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        
        if selectSource.keys.count >= 2 {
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIDatePickerViewNotificationName, object: selectSource)
        }
        
        UIView.animateWithDuration(0.3, animations: {
            self.DIYSuperView.alpha = 0
            }, completion: { finished in
                self.DIYSuperView.removeFromSuperview()
                
        })
        
    }
    
    
    class func currentView()->AIDatePickerView{
        let view = NSBundle.mainBundle().loadNibNamed("AIDatePickerView", owner: self, options: nil).first as! AIDatePickerView
        
        return view
    }
    
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
            pickTwoView.reloadAllComponents()
            selectSource["day"] = days.first ?? ""
            selectSource["month"] = months.first ?? ""
            SpringAnimation.spring(0.3, animations: { () -> Void in
                self.alpha = 1
                self.DIYSuperView.alpha = 1
                self.setTop(self.DIYSuperView.height - self.height)
                
            })
            
            
        }
        
    }
    
    
       
}

extension AIDatePickerView: UIPickerViewDataSource,UIPickerViewDelegate {
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == UIPickViewTag.month.rawValue {
            return months.count
        }
        return days.count
    }
    
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == UIPickViewTag.month.rawValue {
            let currentMonth:String = months[row]
            selectSource["month"] = currentMonth
        }else{
           let currentDay:String = days[row]
            selectSource["day"] = currentDay
        }
       
    }
    
    
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == UIPickViewTag.month.rawValue {
            if row < months.count {
                return months[row]
            }else{
                return ""
            }
            
        }
        
        if row < days.count {
            return days[row]
        }
        return ""
    }
    
}