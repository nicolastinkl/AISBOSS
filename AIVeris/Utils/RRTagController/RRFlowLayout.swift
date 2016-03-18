//
//  RRFlowLayout.swift
//  RRTagController
//
//  Created by admin on 3/16/16.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit

class RRFlowLayout: UICollectionViewFlowLayout {
	
	override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		let attributes = super.layoutAttributesForElementsInRect(rect)
		
		var leftMargin = sectionInset.left
		
		attributes?.forEach { layoutAttribute in
			if layoutAttribute.frame.origin.x == sectionInset.left {
				leftMargin = sectionInset.left
			}
			else {
				layoutAttribute.frame.origin.x = leftMargin
			}
			
			leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
		}
		
		return attributes
	}
}
