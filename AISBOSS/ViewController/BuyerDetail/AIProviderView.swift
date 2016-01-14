//
//  AIProviderView.swift
//  AIVeris
//
//  Created by tinkl on 1/8/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import Spring

/** AIProviderView Class

*/
class AIProviderView :  UIView {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var avator: DesignableImageView!
    @IBOutlet weak var content: UILabel!
    
    // MARK: currentView
    class func currentView()->AIProviderView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AIProviderView", owner: self, options: nil).first  as! AIProviderView
        
        selfView.title.font = AITools.myriadSemiCondensedWithSize(63/PurchasedViewDimention.CONVERT_FACTOR)
        selfView.content.font = AITools.myriadLightSemiCondensedWithSize(42/PurchasedViewDimention.CONVERT_FACTOR)
        
        return selfView
    }
    
    func imageViewLoad(url:String?){
        let s = url ?? ""
        self.avator.sd_setImageWithURL(NSURL(string: "\(s)"))
    }
}
