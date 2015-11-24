//
//  AIAudioMessageView.swift
//  AIVeris
//
//  Created by tinkl on 23/11/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import AISpring


class AIAudioMessageView: UIView {
    
    // MARK: currentView
    
    @IBOutlet weak var audioBg: DesignableLabel!
    @IBOutlet weak var audioGifImageView: UIImageView!
    @IBOutlet weak var audioLength: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    class func currentView()->AIAudioMessageView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AIAudioMessageView", owner: self, options: nil).first  as! AIAudioMessageView
        return selfView
    }
    
    @IBAction func playAction(sender: AnyObject) {
        
    }
}