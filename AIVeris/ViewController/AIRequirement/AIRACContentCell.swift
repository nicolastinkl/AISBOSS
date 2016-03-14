//
//  AIRACContentCell.swift
//  AIVeris
//
//  Created by tinkl on 3/10/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation


@objc protocol ExpendTableViewCellDelegate: class {
    func expendTableViewCell(cell: AIRACContentCell, expendButtonPressed sender: AnyObject)
    func expendTableViewCellSizeDidChange(cell: AIRACContentCell)
}


/// Here is to define some protocol.
class AIRACContentCell: SESlideTableViewCell {
    
    // MARK: -> Internal static properties
    
    private lazy var editButton = UIButton(type: UIButtonType.Custom)
    private lazy var bgImageView = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var desLabel = UILabel()
    private lazy var lineImageView = UIImageView(image: UIImage(named:"orderline"))
    private lazy var iconView = UIView()
    
    var hasExpend: Bool = false
    
    weak var aiDelegate: ExpendTableViewCellDelegate?    
    
    func AddExpendCell(any : AnyObject){
        
        aiDelegate?.expendTableViewCell(self, expendButtonPressed: any)
    }
    
}

