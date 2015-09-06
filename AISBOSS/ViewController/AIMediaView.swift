//
//  AIMediaView.swift
//  AITrans
//
//  Created by admin on 7/1/15.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//

import Foundation
import AISpring

class AIMediaView: SpringView {
    
    var mediaDelegate:playCellDelegate?
    
    @IBOutlet weak var Image_Media: AIImageView!
    
    @IBOutlet weak var Button_play: UIButton!
    
    @IBAction func playAction(sender: AnyObject) {
        mediaDelegate?.playMediaSource(self.associatedName! ?? "")        
    }
     
    class func currentView()->AIMediaView{
        var selfView = NSBundle.mainBundle().loadNibNamed("AIMediaView", owner: self, options: nil).first  as AIMediaView
        return selfView
    }
    
    
}