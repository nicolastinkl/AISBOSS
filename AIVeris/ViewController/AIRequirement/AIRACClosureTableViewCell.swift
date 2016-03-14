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
    
    private var selectedddImage: DesignableLabel = {
        let bgLabel = DesignableLabel()
        bgLabel.backgroundColor = UIColor.grayColor()
        bgLabel.cornerRadius = 6
        bgLabel.layer.masksToBounds = true
        return bgLabel
        }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle =  UITableViewCellSelectionStyle.None
        self.backgroundColor = UIColor.clearColor()
        
        self.contentView.addSubview(selectedddImage)
        self.contentView.addSubview(iconImage)
        self.contentView.addSubview(contentLabel)

        iconImage.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(self.contentView).offset(5)
            make.leading.equalTo(10)
            make.width.height.equalTo(25)
        })        
        
        contentLabel.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(self.contentView).offset(5)
            make.leading.equalTo(iconImage.snp_right).offset(10)
            make.width.greaterThanOrEqualTo(20)
//            make.trailing.equalTo(-14)
            make.height.equalTo(25)
        })
        
        selectedddImage.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(iconImage.snp_left).offset(-5)
            make.trailing.equalTo(contentLabel.snp_right).offset(10)
            make.top.equalTo(iconImage.top).offset(0)
            make.height.equalTo(35)
        }
       
        
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        if selected == true {
            selectedddImage.backgroundColor = UIColor(hex: "#1D86E5")
        }else{
            selectedddImage.backgroundColor = UIColor.clearColor()
        }
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