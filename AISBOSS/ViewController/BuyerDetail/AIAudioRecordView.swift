//
//  AIAudioRecordView.swift
//  AIVeris
//
//  Created by tinkl on 24/11/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation


class AIAudioRecordView: UIView {
    class func currentView()->AIAudioRecordView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AIAudioRecordView", owner: self, options: nil).first  as! AIAudioRecordView
        return selfView
    }
}