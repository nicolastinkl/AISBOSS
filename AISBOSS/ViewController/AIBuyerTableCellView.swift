//
//  AIBuyerTableCellView.swift
//  AIVeris
//
//  Created by 刘先 on 15/10/21.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AITableFoldedCellHolder: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        var frame = self.contentView.frame
//        frame.size.height += 10
//        self.contentView.frame = frame
        
        self.contentView.clipsToBounds = true
    }
    
}

class AITableExpandedCellHolder : UITableViewCell{
    
}