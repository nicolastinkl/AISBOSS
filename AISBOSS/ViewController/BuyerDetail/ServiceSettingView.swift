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
    
    private static let HORIZAN_SPACE: CGFloat = 8
    private static let MESSAGE_HEIGHT: CGFloat = 20
    private static let TAG_HEIGHT: CGFloat = 28
    private static let BOTTOM_PADDING: CGFloat = 3
    private static let COLLECTION_WIDTH: CGFloat = 303
    
    var model: AIProposalHopeModel!

    var tags: [String] = []
    
    override func awakeFromNib() {
        
        message.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(31))
        
        setCollectionView()
    }
    
    static func createInstance() -> ServiceSettingView {
        return NSBundle.mainBundle().loadNibNamed("ServiceSettingView", owner: self, options: nil).first  as! ServiceSettingView
    }
    
    func loadData(tags: [String]) {
        self.tags = tags
        
        frame.size.height = ServiceSettingView.MESSAGE_HEIGHT + ServiceSettingView.TAG_HEIGHT * CGFloat(estimateRowCount()) + ServiceSettingView.BOTTOM_PADDING
        
        collectionView.reloadData()
    }
    
    func loadData(model data: AIProposalHopeModel) {
        if data.hope_list != nil && data.hope_list.count > 0 {
            let hopeModel = data.hope_list.first as! AIProposalHopeAudioTextModel
            message.text = hopeModel.text ?? ""
        }     
    }
    
    private func setCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = FixedSpaceFlowLayout(space: ServiceSettingView.HORIZAN_SPACE)
        let layout = collectionView.collectionViewLayout
        let flow = layout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        collectionView.registerClass(AIMsgTagCell.self,
            forCellWithReuseIdentifier: "CONTENT")
    }
    
    private func estimateRowCount() -> Int {
        var length: CGFloat = 0
        
        for tag in tags {
            let size = AIMsgTagCell.sizeForContentString(tag, forMaxWidth: 1000)
            length += (size.width + ServiceSettingView.HORIZAN_SPACE)
        }
        
        if tags.count == 0 {
            return 0
        } else {
            return Int(length / ServiceSettingView.COLLECTION_WIDTH) + 1
        }
    }
}

extension ServiceSettingView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if model != nil && model.label_list != nil {
            return  model.label_list.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CONTENT", forIndexPath: indexPath) as! AIMsgTagCell
        
        cell.maxWidth = collectionView.bounds.size.width
        
        let tag = model.label_list[indexPath.item] as! AIProposalNotesModel
        
        cell.text = tag.name
        
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }

}

class FixedSpaceFlowLayout: UICollectionViewFlowLayout {
    
    var horizanSpace: CGFloat = 10
    
    init(space: CGFloat) {
        super.init()
        horizanSpace = space
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private static let HORIZAN_SPACE: CGFloat = 9
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElementsInRect(rect)
        
        if let atts = attributes {
            for(var i = 1; i < atts.count; ++i) {
                if i >= 1 {
                    let currentLayoutAttributes = atts[i]
                    let prevLayoutAttributes = atts[i - 1]
                    
                    let preRightX = CGRectGetMaxX(prevLayoutAttributes.frame)
                    
                    if(preRightX + horizanSpace + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize().width) {
                        currentLayoutAttributes.frame.origin.x = preRightX + horizanSpace
                    }
                }
            }
        }
        
        return attributes
    }
}

class AIMsgTagCell: UICollectionViewCell {
    static var defaultFont = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(31))
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
            newContentFrame.size = newLabelFrame.size
            
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
        label.layer.cornerRadius = 8;
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
            
            let realRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width + 15, height: rect.height + 5)
            
            return realRect.size
    }
}


