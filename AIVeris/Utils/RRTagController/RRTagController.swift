//
//  RRTagController.swift
//  RRTagController
//
//  Created by Remi Robert on 20/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit

let colorUnselectedTag = UIColor.clearColor()
let colorSelectedTag = UIColorFromHex(0x0f86e8)

let colorTextUnSelectedTag = UIColorFromHex(0x0f86e8)
let colorTextSelectedTag = UIColor.whiteColor()

class RRTagController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	var tags: Array<RequirementTag> = []
	
    var requirementID : Int?
    
	private var _totalTagsSelected = 0
	private var heightKeyboard: CGFloat = 0
	
	var onDidSelected: ((selectedTags: Array<RequirementTag>, unSelectedTags: Array<RequirementTag>) -> ())!
	var onDidCancel: (() -> ())!
	
	var totalTagsSelected: Int {
		get {
			return self._totalTagsSelected
		}
		set {
			if newValue == 0 {
				self._totalTagsSelected = 0
				return
			}
			self._totalTagsSelected += newValue
			self._totalTagsSelected = (self._totalTagsSelected < 0) ? 0 : self._totalTagsSelected
		}
	}
	
	lazy var collectionTag: UICollectionView = {
		let layoutCollectionView = RRFlowLayout()
		layoutCollectionView.sectionInset = UIEdgeInsets(top: 0, left: 54 / 3, bottom: 0, right: 54 / 3)
		layoutCollectionView.itemSize = CGSizeMake(90, 20)
		layoutCollectionView.minimumLineSpacing = 10
		layoutCollectionView.minimumInteritemSpacing = 26 / 3
		var frame = self.view.frame
		frame.size.height -= 44
		let collectionTag = UICollectionView(frame: frame, collectionViewLayout: layoutCollectionView)
		collectionTag.contentInset = UIEdgeInsets(top: 115 / 3, left: 0, bottom: 20, right: 0)
		collectionTag.delegate = self
		collectionTag.dataSource = self
		collectionTag.backgroundColor = UIColor.clearColor()
		collectionTag.registerClass(RRTagCollectionViewCell.self, forCellWithReuseIdentifier: RRTagCollectionViewCellIdentifier)
		return collectionTag
	}()
	
	lazy var addNewTagCell: RRTagCollectionViewCell = {
		let addNewTagCell = RRTagCollectionViewCell()
		addNewTagCell.contentView.addSubview(addNewTagCell.textContent)
		addNewTagCell.textContent.text = "+"
		addNewTagCell.frame.size = RRTagCollectionViewCellAddTagSize
		addNewTagCell.backgroundColor = UIColor.grayColor()
		return addNewTagCell
	}()
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tags.count + 1
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
			if indexPath.row < tags.count {
				let result = RRTagCollectionViewCell.contentHeight(tags[indexPath.row].textContent, maxWidth: collectionView.contentSize.width)
				
				return result
			}
			return RRTagCollectionViewCellAddTagSize
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let selectedCell: RRTagCollectionViewCell? = collectionView.cellForItemAtIndexPath(indexPath) as? RRTagCollectionViewCell
		
		if indexPath.row < tags.count {
			_ = tags[indexPath.row]
			
			if tags[indexPath.row].selected == false {
				tags[indexPath.row].selected = true
				selectedCell?.animateSelection(tags[indexPath.row].selected)
				totalTagsSelected = 1
			}
			else {
				tags[indexPath.row].selected = false
				selectedCell?.animateSelection(tags[indexPath.row].selected)
				totalTagsSelected = -1
			}
		}
		else {
			addTagDidClick()
		}
	}
	
	func addTagDidClick() {
		fatalError("need subclass override this function")
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell: RRTagCollectionViewCell? = collectionView.dequeueReusableCellWithReuseIdentifier(RRTagCollectionViewCellIdentifier, forIndexPath: indexPath) as? RRTagCollectionViewCell
		
		if indexPath.row < tags.count {
			let currentTag = tags[indexPath.row]
			cell?.initContent(currentTag)
		}
		else {
			cell?.initAddButtonContent()
		}
		return cell!
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		totalTagsSelected = 0
		self.view.addSubview(collectionTag)
	}
}
