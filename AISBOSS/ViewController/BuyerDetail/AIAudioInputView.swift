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
    
    let holdViewHeigh:CGFloat = 290.0
    
    private var currentAudioState: Bool = false
    
    @IBOutlet weak var changeButton: DesignableButton!
    
    @IBOutlet weak var textInput: DesignableTextField!
    
    @IBOutlet weak var audioButtonView: UIView!
    
    @IBOutlet weak var inputButtomValue: NSLayoutConstraint!
    
    class func currentView()->AIAudioInputView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AIAudioInputView", owner: self, options: nil).first  as! AIAudioInputView
        return selfView
    }
    
    @IBAction func ChangeAction(sender: AnyObject) {
        currentAudioState = !currentAudioState
        //切换状态
        
        let bgImage:UIImage?
        if currentAudioState {
            //语音模式
            bgImage = UIImage(named: "ai_keyboard_button_change")
            textInput.resignFirstResponder()
        }else{
            //文字模式
            bgImage = UIImage(named: "ai_audio_button_change")
            textInput.becomeFirstResponder()
        }
        if let m = bgImage {
            changeButton.setImage(m, forState: UIControlState.Normal)
        }
        
    }
    
    @IBAction func closeViewAction(sender: AnyObject) {
        springWithCompletion(0.5, animations: { () -> Void in
            self.alpha = 0
            }) { (complate) -> Void in
                self.removeFromSuperview()
        }

    }
}