//
//  AIDottedLineLabelView.swift
//  AIVeris
//
//  Created by 刘先 on 16/5/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIDottedLineLabelView: UIView {

    var leftLineImage : UIImageView!
    var rightLineImage : UIImageView!
    var textLabel : UILabel!
    
    //Constants
    let dottedLineImage = UIImage(named: "dottedLine2")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildSubViews()
    }
    
    override func awakeFromNib() {
        //buildSubViews()
    }
    
    //便利构造方法
    convenience init(text : String){
        self.init()
        buildSubViews()
        loadData(text)
        
    }
    
    func loadData(text : String){
        textLabel.text = text
    }

    func buildSubViews(){
        buildLineView()
        buildTextLabel()
    }
    
    private func buildLineView(){
        leftLineImage = UIImageView()
        leftLineImage.image = dottedLineImage
        self.addSubview(leftLineImage)
        
        leftLineImage.snp_makeConstraints { (make) in
            make.centerY.leading.equalTo(self)
            make.height.equalTo(1)
        }
        
        rightLineImage = UIImageView()
        rightLineImage.image = dottedLineImage
        self.addSubview(rightLineImage)
        rightLineImage.snp_makeConstraints { (make) in
            make.centerY.trailing.equalTo(self)
            make.height.equalTo(1)
        }
    }
    
    private func buildTextLabel(){
        textLabel = UILabel()
        textLabel.text = "label"
        textLabel.textColor = UIColor.lightGrayColor()
        self.addSubview(textLabel)
        textLabel.snp_makeConstraints { (make) in
            make.leading.equalTo(leftLineImage.snp_trailing).offset(10)
            make.trailing.equalTo(rightLineImage.snp_leading).offset(-10)
            make.centerY.centerX.equalTo(self)
        }
        textLabel.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
    }
    
}
