//
//  BuyerMessageCell.swift
//  AIVeris
//
//  Created by Rocky on 16/3/23.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class BuyerMessageCell: UITableViewCell {

    @IBOutlet weak var serviceImage: UIImageView!
    
    @IBOutlet weak var servviceContent: UILabel!
    @IBOutlet weak var serviceTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        serviceImage.layer.cornerRadius = serviceImage.bounds.width / 2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func acceptAction(sender: AnyObject) {
        
    }
    
    @IBAction func refuseAction(sender: AnyObject) {
        
    }
}
