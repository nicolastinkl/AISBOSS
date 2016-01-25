//
//  AISingleLineTagView.swift
//  multiLabelDemo
//
//  Created by admin on 1/20/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

import UIKit

class AISingleLineTagView: AIBaseTagsView {
	var row: Int = 0
	var tags: [Tagable]
	override var selectedIndex: Int {
		didSet {
			selectedTagId = tags[selectedIndex].id
		}
	}
	var selectedTagId: Int? {
		didSet {
			updateTagStatus()
		}
	}
	var selectedTag: Tagable? {
		for t in tags {
			if t.id == selectedTagId {
				return t
			}
		}
		return nil
	}
	
	func updateTagStatus() {
		for label in tagViews {
			if let l = label as? AITagLabel {
				if let t = label.tagNode as? Tagable {
					l.highlighted = t.id != selectedTagId
				}
			}
		}
	}
	
	override func addTagInView(tag: String!, index: Int) -> AITagLabel! {
		let result = super.addTagInView(tag, index: index)
		result.tagNode = tags[index]
		return result
	}
	
	init(tags: [Tagable], selectedTagId: Int? = nil, frame: CGRect) {
		self.tags = tags
		self.selectedTagId = selectedTagId
		super.init(tags: tags.map({ (t) -> String in
			return t.title
		}), frame: frame)
	}
	
	override init(frame: CGRect) {
		self.tags = [Tagable]()
		super.init(frame: frame)
	}
	
	override func labelDidTapped(g: UITapGestureRecognizer) {
		super.labelDidTapped(g)
		let label = g.view as! AITagLabel
		let tag = tags[label.tag]
		selectedTagId = tag.id
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
