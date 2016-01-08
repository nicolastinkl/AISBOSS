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
    @IBOutlet weak var messageViewHeight: NSLayoutConstraint!
    
    private static let HORIZAN_SPACE: CGFloat = 8
    private static let MESSAGE_HEIGHT_ONE_LINE: CGFloat = 24
    private static let TAG_HEIGHT: CGFloat = 28
    private static let BOTTOM_PADDING: CGFloat = 12
    private static let COLLECTION_WIDTH: CGFloat = 303
    
    var model: AIProposalHopeModel!
    
    override func awakeFromNib() {
        
        message.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(31))
        
        setCollectionView()
        
    }
    
    static func createInstance() -> ServiceSettingView {
        return NSBundle.mainBundle().loadNibNamed("ServiceSettingView", owner: self, options: nil).first  as! ServiceSettingView
    }
    
    func adjustSizeAfterSetData() {
        adjustTwoLineMessageSize()
    }
    
    func loadData(model data: AIProposalHopeModel) {
        self.model = data
        
        if data.hope_list != nil && data.hope_list.count > 0 {
            let hopeModel = data.hope_list.first as! AIProposalHopeAudioTextModel
            message.text = hopeModel.text ?? ""
            
            adjustTwoLineMessageSize()
        }
        
        frame.size.height = messageViewHeight.constant + ServiceSettingView.TAG_HEIGHT * CGFloat(estimateRowCount()) + ServiceSettingView.BOTTOM_PADDING
        
        collectionView.reloadData()
    }
    
    private func adjustTwoLineMessageSize() {
        let MESSAGE_WIDTH_IOS6_PLUS: CGFloat = 317
        let textSize = message.text!.sizeWithFont(message.font, forWidth: MESSAGE_WIDTH_IOS6_PLUS)
        let row = textSize.height / message.font.lineHeight
        if row > 1 {
            messageViewHeight.constant += 10
            message.setNeedsUpdateConstraints()
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
        var rowCount = 0
        var length: CGFloat = 0
        
        let rowWidth = ServiceSettingView.COLLECTION_WIDTH
        
        if model.label_list.count > 0 {
            rowCount = 1
        }
        
        for item in model.label_list {
            let tag = item as! AIProposalNotesModel
            let size = AIMsgTagCell.sizeForContentString(tag.name, forMaxWidth: 1000)
            length += (size.width + ServiceSettingView.HORIZAN_SPACE)
            
            if (length > rowWidth) {
                rowCount++
                
                // last word should be arranged in next row, so new row length equal last word's width
                length = size.width
            }
        }
        
//        if model.label_list.count != 0 {
//            rowCount = Int(length / ServiceSettingView.COLLECTION_WIDTH) + 1
//        }
        
        //print("estimateRowCount:\(rowCount)")
        return rowCount
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
            
            let tag = model.label_list[indexPath.item] as! AIProposalNotesModel
            
            let size = AIMsgTagCell.sizeForContentString(tag.name,
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
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElementsInRect(rect)
        
        if let atts = attributes {
            for(var i = 1; i < atts.count; ++i) {
                if i >= 1 {
                    
                    let currentLayoutAttributes = atts[i]
                    let prevLayoutAttributes = atts[i - 1]
                    
                    let preRightX = CGRectGetMaxX(prevLayoutAttributes.frame)
                    
                    let currentPossibleRightXPosition = preRightX + horizanSpace + currentLayoutAttributes.frame.size.width
                    
                    if(currentPossibleRightXPosition < self.collectionViewContentSize().width && currentLayoutAttributes.frame.origin.y == prevLayoutAttributes.frame.origin.y) {
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
        label.layer.borderColor = UIColor(hexString: "#ffffff", alpha: 0.4).CGColor
        label.layer.borderWidth = 0.5
        label.layer.cornerRadius = 10;
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
            
            let realRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width + 15, height: rect.height + 9)
            
            return realRect.size
    }
}


