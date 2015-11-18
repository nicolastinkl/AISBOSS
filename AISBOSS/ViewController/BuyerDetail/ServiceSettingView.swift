//
//  ServiceSettingView.swift
//  服务卡片底部自定义消息视图
//  AIVeris
//
//  Created by Rocky on 15/11/17.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class ServiceSettingView: UIView {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var state: UIImageView!

    var tags: [String] = [String]()
    
    override func awakeFromNib() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = collectionView.collectionViewLayout
        let flow = layout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        collectionView.registerClass(AIMsgTagCell.self,
            forCellWithReuseIdentifier: "CONTENT")
    }
    
    static func createInstance() -> ServiceSettingView {
        return NSBundle.mainBundle().loadNibNamed("ServiceSettingView", owner: self, options: nil).first  as! ServiceSettingView
    }
}

extension ServiceSettingView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CONTENT", forIndexPath: indexPath) as! AIMsgTagCell
        
        cell.maxWidth = collectionView.bounds.size.width
        
        
        let tagName = tags[indexPath.item]
        
        cell.text = tagName
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            indexPath.row
            
            let tagName = tags[indexPath.item]
            
            let size = AIMsgTagCell.sizeForContentString(tagName,
                forMaxWidth: collectionView.bounds.size.width / 2)
            
            return size
    }

}

class AIMsgTagCell: UICollectionViewCell {
    static var defaultFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody).fontWithSize(CGFloat(18.0))
    var label: UILabel!
    var text: String! {
        get {
            return label.text
        }
        set(newText) {
            label.text = newText
            var newLabelFrame = label.frame
            var newContentFrame = contentView.frame
            let textSize = AIMsgTagCell.sizeForContentString(newText,
                forMaxWidth: maxWidth)
            newLabelFrame.size = textSize
            newContentFrame.size = textSize
            label.frame = newLabelFrame
            contentView.frame = newContentFrame
        }
    }
    var maxWidth: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UILabel(frame: self.contentView.bounds)
        label.opaque = false
        label.textColor = UIColor.whiteColor()
        label.layer.borderColor = UIColor.whiteColor().CGColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 2;
        label.textAlignment = .Center
        label.font = AIMsgTagCell.defaultFont
        contentView.addSubview(label)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    static func sizeForContentString(s: String,
        forMaxWidth maxWidth: CGFloat) -> CGSize {
            let maxSize = CGSizeMake(maxWidth, 1000)
            let opts = NSStringDrawingOptions.UsesLineFragmentOrigin
            
            let style = NSMutableParagraphStyle()
            style.lineBreakMode = NSLineBreakMode.ByCharWrapping
            let attributes = [ NSFontAttributeName: AIMsgTagCell.defaultFont,
                NSParagraphStyleAttributeName: style]
            
            let string = s as NSString
            let rect = string.boundingRectWithSize(maxSize, options: opts,
                attributes: attributes, context: nil)
            
            return rect.size
    }
}
