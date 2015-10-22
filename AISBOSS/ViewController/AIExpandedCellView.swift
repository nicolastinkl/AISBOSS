//
//  AIExpandedCellView.swift
//  AIVeris
//
//  Created by 刘先 on 15/10/21.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIExpandedCellView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func buildContent(){
        let testLabel = UILabel(frame: self.bounds)
        testLabel.text = "hello I am expanded cell!"
        testLabel.textColor = UIColor.whiteColor()
        self.backgroundColor = UIColor.grayColor()
    }
}


