//
//  AIEventTimerView.swift
//  AIVeris
//
//  Created by tinkl on 1/26/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

public class AIEventTimerView: UIView {
    
    var newFrame : CGRect?
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var timeContent: UIButton!
    
    @IBAction func PickDateViewAction(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pickView:", name: AIApplication.Notification.AIDatePickerViewNotificationName, object: nil)
        let pickView = AIDatePickerView.currentView()
        pickView.show()
    }
    
    func pickView(notify: NSNotification){
        if let dic  = notify.object as? [String:String] {
            timeContent.setTitle("\(dic["month"] ?? "") \(dic["day"] ?? "")", forState: UIControlState.Normal)
        }
    }
    
    class func currentView()->AIEventTimerView{
        
        let selfview =  NSBundle.mainBundle().loadNibNamed("AIEventTimerView", owner: self, options: nil).first  as! AIEventTimerView
        selfview.title.font = AITools.myriadSemiCondensedWithSize(43/PurchasedViewDimention.CONVERT_FACTOR)
        selfview.timeContent.titleLabel?.font = AITools.myriadSemiCondensedWithSize(43/PurchasedViewDimention.CONVERT_FACTOR)
        return selfview
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if let _ = newFrame {
            
            newFrame?.size.height = CGRectGetHeight(self.frame)
            self.frame = newFrame!
        }
        
    }
    
    
}