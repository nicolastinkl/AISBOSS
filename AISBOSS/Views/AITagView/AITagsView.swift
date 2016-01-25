//
//  AITagsView.swift
//  multiLabelDemo
//
//  Created by admin on 1/21/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

import UIKit

/* example
 func setupTagsView() {
 let dicURL = NSBundle.mainBundle().URLForResource("multiLabels", withExtension: "json")!
 let data = NSData(contentsOfURL: dicURL)!

 let dic = JSON(data: data)

 let tags = dic["labels"].object as! [Dictionary<String, AnyObject>]
 let selectedTagIds = dic["selected_label_id"].object as! [Int]

 var mTags = [Tagable]()
 for t in tags {
 mTags.append(AITag(dic: t))
 }

 let tagsView = AITagsView(tags: mTags, selectedTagIds: selectedTagIds, frame: view.bounds)
 tagsView.backgroundColor = UIColor.orangeColor()
 view.addSubview(tagsView)

 tagsView.addTarget(self, action: "tagsViewValueDidChanged:", forControlEvents: .ValueChanged)
 }
 func tagsViewValueDidChanged(sender: AITagsView) {
 label.text = "\(sender.selectedTagIds)"
 label.sizeToFit()
 }
 */

class AITagsView: UIControl {
	var tags: [Tagable]
	var selectedTagIds: [Int]
	var row = 0
	var singleLineTagViews = [AISingleLineTagView]()
	init(tags: [Tagable], selectedTagIds: [Int] = [Int](), frame: CGRect) {
		self.tags = tags
		self.selectedTagIds = selectedTagIds
		super.init(frame: frame)
		renderAllSingleLineTagViews()
	}
	
	struct Constants {
		struct Tag {
			static let normalBackgroudColor = UIColor.redColor()
			static let highlightedBackgroundColor = UIColor.blackColor()
		}
	}
	
	func renderAllSingleLineTagViews() {
		for v in subviews {
			v.removeFromSuperview()
		}
		singleLineTagViews.removeAll()
		row = 0
		addSingleLineTagView(tags: tags) // add first line
	}
	
	func singleLineTagViewValueChanged(sender: AISingleLineTagView) {
		var newSelectedTagIds = [Int]()
		let r = sender.row
		for i in 0..<r {
			newSelectedTagIds.append(singleLineTagViews[i].selectedTagId!)
		}
		newSelectedTagIds.append(sender.selectedTagId!)
		selectedTagIds = newSelectedTagIds
		print(selectedTagIds)
		renderAllSingleLineTagViews()
		
		sendActionsForControlEvents(.ValueChanged)
	}
	
	func addSingleLineTagView(tags tags: [Tagable], parent: Tagable? = nil) {
		let previousSingleLineTagView = singleLineTagViews.last
		if tags.last != nil {
			// init single line tag view
			let s = AISingleLineTagView(tags: tags, frame: frame)
			s.tagNormalColor = Constants.Tag.normalBackgroudColor
			s.tagSelectedColor = Constants.Tag.highlightedBackgroundColor
			
			s.addTarget(self, action: "singleLineTagViewValueChanged:", forControlEvents: .ValueChanged)
			addSubview(s)
			if let p = previousSingleLineTagView {
				var f = s.frame
				f.origin.y = CGRectGetMaxY(p.frame)
				s.frame = f
				
				var selfFrame = frame
				selfFrame.size.height = CGRectGetMaxY(f)
				frame = selfFrame
			}
			singleLineTagViews.append(s)
			s.row = row
			
			// set single line tag view 's selected tag id
			if selectedTagIds.count > row {
				s.selectedTagId = selectedTagIds[row]
				let tag = tags.filter({ (t) -> Bool in
					return t.id == s.selectedTagId
				}).first!
				row++
				if let subtags = tag.subtags {
					addSingleLineTagView(tags: subtags, parent: tag)
				}
			}
		} else {
			if let desc = parent?.desc {
				if (desc as NSString).length > 0 {
					let v = AITagDescView()
					v.frame = CGRectMake(0, 0, frame.width, 30)
					v.text = desc
					var f = v.frame
					if let p = previousSingleLineTagView {
						f.origin.y = CGRectGetMaxY(p.frame)
					}
					v.frame = f
					addSubview(v)
					
					var selfFrame = frame
					selfFrame.size.height = CGRectGetMaxY(f)
					frame = selfFrame
				}
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

@objc protocol Tagable: NSObjectProtocol {
	
	var id: Int {
		get
	}
	
	var title: String {
		get
	}
	
	var subtags: [Tagable]? {
		get
	}
	
	var desc: String? {
		get
	}
}
func == (lhs: Tagable, rhs: Tagable) -> Bool {
	return lhs.id == rhs.id
}
