//
//  AITIMELINESDTITLEView.swift
//  AI2020OS
//
//  Created by tinkl on 19/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AITIMELINESDTITLEView: UIView {

    @IBOutlet weak var labelNow: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func currentView() -> AITIMELINESDTITLEView {
        return NSBundle(forClass: self).loadNibNamed("AITIMELINESDTITLEView", owner: self, options: nil).first as! AITIMELINESDTITLEView
    }
    
    
}