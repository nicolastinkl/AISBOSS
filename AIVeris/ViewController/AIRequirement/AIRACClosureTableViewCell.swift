//
//  AIRACClosureTableViewCell.swift
//  AIVeris
//
//  Created by tinkl on 3/11/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

import Spring

class AIRACClosureTableViewCell: UITableViewCell {

    private var iconImage = AIImageView()
    private var contentLabel: UILabel = {
        let desLabel = UILabel()
        desLabel.numberOfLines = 1
        desLabel.lineBreakMode =  NSLineBreakMode.ByCharWrapping
        desLabel.text = ""
        desLabel.font = AITools.myriadLightSemiExtendedWithSize(16)
        desLabel.textColor = UIColor.whiteColor()
        desLabel.textAlignment = NSTextAlignment.Left
        return desLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clearColor()
        
        self.contentView.addSubview(iconImage)
        self.contentView.addSubview(contentLabel)

        iconImage.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(self.contentView).offset(5)
            make.leading.equalTo(14)
            make.width.height.lessThanOrEqualTo(55)
        })        
        
        contentLabel.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(self.contentView).offset(5)
            make.leading.equalTo(iconImage.snp_right).offset(10)
            make.trailing.equalTo(-14)
            make.height.equalTo(25)
        })
        
    }
    
    func refereshData(model: AIIconTagModel){
        self.iconImage.setURL(NSURL(string: model.iconUrl ?? ""), placeholderImage: UIImage(named: "PlackHolder"))
        self.contentLabel.text = model.content ?? ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}