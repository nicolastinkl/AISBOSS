//
//  AIAudioInputView.swift
//  AIVeris
//
//  Created by tinkl on 14/12/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import AISpring

// 新的语音实现界面 
class AIAudioInputView:UIView{
    
    class func currentView()->AIAudioInputView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AIAudioInputView", owner: self, options: nil).first  as! AIAudioInputView
        return selfView
    }
    
    @IBAction func closeViewAction(sender: AnyObject) {
        springWithCompletion(0.5, animations: { () -> Void in
            self.alpha = 0
            }) { (complate) -> Void in
                self.removeFromSuperview()
        }

    }
}