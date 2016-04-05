//
//  AIRACClosureTableViewCell.swift
//  AIVeris
//
//  Created by tinkl on 3/11/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

import Spring

protocol AIRACClosureTableViewCellProtocol: class {
    
    func withSelectedCell(cellModel: AIServiceProvider, isSelect: Bool)
    
}

class AIRACClosureTableViewCell: UITableViewCell {
    
    private var iconImage = AIImageView()
    
    private var currentModel: AIServiceProvider?
    
    private var isSelected: Bool = false
    
    weak var delegateCell: AIRACClosureTableViewCellProtocol?
    
    private var contentLabel: UILabel = {
        let desLabel = UILabel()
        desLabel.numberOfLines = 1
        desLabel.lineBreakMode =  NSLineBreakMode.ByCharWrapping
        desLabel.text = ""
        desLabel.font = AITools.myriadLightSemiExtendedWithSize(14)
        desLabel.textColor = UIColor.whiteColor()
        desLabel.textAlignment = NSTextAlignment.Left
        return desLabel
    }()
    
    private var selectedddImage: DesignableLabel = {
        let bgLabel = DesignableLabel()
        bgLabel.backgroundColor = UIColor.clearColor()
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
            make.top.equalTo(5)
            make.leading.equalTo(10)
            make.width.height.equalTo(30)
        })
        
        contentLabel.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(9)
            make.leading.equalTo(50)
            make.width.greaterThanOrEqualTo(20)
            make.height.equalTo(25)
        })
                
        selectedddImage.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(5)
            make.trailing.equalTo(contentLabel).offset(10)
            make.top.equalTo(0)
            make.height.equalTo(42)
        }
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
        isSelected = !isSelected
        
        if selected == true {
            delegateCell?.withSelectedCell(currentModel!, isSelect: isSelected)
        }
        
        if isSelected == true {
            selectedddImage.backgroundColor = UIColor(hex: "#0f86E5")
        }else{
            selectedddImage.backgroundColor = UIColor.clearColor()
        }
    }
    
    func refereshData(model: AIServiceProvider){
        currentModel = model
        self.iconImage.setURL(NSURL(string: "\(model.portrait_icon)"), placeholderImage: UIImage(named: "PlackHolder"))
        
        self.contentLabel.text = "\(model.relservice_desc)pregnancy assistant"
        
        self.associatedName = "\(model.relservice_id.integerValue)"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
}