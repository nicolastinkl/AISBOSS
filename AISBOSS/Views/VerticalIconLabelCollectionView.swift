//
//  VerticalIconLabelCollectionView.swift
//  AIVeris
//
//  Created by Rocky on 16/1/7.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

/// 这里是服务参数collection 的动态显示
class VerticalIconLabelCollectionView: UIView {
    
    private var horizanSpace: CGFloat = 0
    
    var itemCountOfOneLine: Int = 3 {
        
        didSet {
            
            if itemCountOfOneLine != oldValue && itemCountOfOneLine > 0 {
                
                if itemCountOfOneLine > 1 {
                    horizanSpace = calculateHorizanSpace()
                }
                
                collectionView.reloadData()
            }
        }
    }
    
    var itemWidth: CGFloat = 100.0 {
        
        didSet {
            if itemWidth != oldValue && itemWidth > 0 {
                collectionView.reloadData()
            }
        }
    }
    
    var itemHeight: CGFloat = 48.0 {
        
        didSet {
            if itemHeight != oldValue && itemHeight > 0 {
                collectionView.reloadData()
            }
        }
    }
    
    var dataSource: [(image:UIImage, title:String)]? {
        didSet {
            collectionView.reloadData()
        }
    }

    private var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelf()
    }
    
    private func initSelf() {
        horizanSpace = calculateHorizanSpace()
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: FixedSpaceFlowLayout(space: horizanSpace))
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollEnabled = false
        let flowLayout = collectionView.collectionViewLayout
        let flow = flowLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        collectionView.registerClass(VerticalIconLabelCell.self,
            forCellWithReuseIdentifier: "cell")
        
        addSubview(collectionView)
        
        layout(collectionView, self) {collectionView, parent in
            collectionView.edges == parent.edges
        }
    }
    
    private func calculateHorizanSpace() -> CGFloat {
        if itemCountOfOneLine > 1 {
            return (width - itemWidth * CGFloat(itemCountOfOneLine))  / CGFloat(itemCountOfOneLine - 1)
        } else {
            return 0
        }
    }

}

extension VerticalIconLabelCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.count ?? 0;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! VerticalIconLabelCell

        let (img, text) = dataSource![indexPath.item]
        
        cell.iconLabel.image = img
        cell.iconLabel.text = text
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            indexPath.row
            
            let maxWidth = width
            
            if itemWidth > 0 && itemCountOfOneLine > 0 {
                var itemWidthTemp = itemWidth
                
                if (itemWidthTemp * CGFloat(itemCountOfOneLine) > maxWidth) {
                    itemWidthTemp = maxWidth / CGFloat(itemCountOfOneLine)
                }
                
                return CGRectMake(0, 0, itemWidthTemp, itemHeight).size
            } else {
                return CGRect.zero.size
            }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
}

class VerticalIconLabelCell: UICollectionViewCell {
    
    var iconLabel: VerticalIconLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        iconLabel = VerticalIconLabel(frame: self.contentView.bounds)
        contentView.addSubview(iconLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}

