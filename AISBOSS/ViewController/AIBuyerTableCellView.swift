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
        let folderCellView = self.contentView.subviews.first
        if (folderCellView?.hidden == false)  {
            var frame = self.contentView.frame
            frame.size.height += 10
            self.contentView.frame = frame
        
        }
        self.clipsToBounds = true
        self.contentView.clipsToBounds = true
    }
    
}

class AITableExpandedCellHolder : UITableViewCell{
    
}