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


 var mTags = [Tagable]()
 for t in tags {
 mTags.append(AITag(dic: t))
 }

 let tagsView = AITagsView(tags: mTags, frame: view.bounds)
 tagsView.backgroundColor = UIColor.orangeColor()
 view.addSubview(tagsView)

 tagsView.addTarget(self, action: "tagsViewValueDidChanged:", forControlEvents: .ValueChanged)
 }
 func tagsViewValueDidChanged(sender: AITagsView) {
 label.text = "\(sender.selectedTagIds)"
 label.sizeToFit()
/size frame ....update frames()
 }
 */

class AITagsView: UIControl {
	var titleLabel: UILabel = UILabel(frame: .zero)
	var tags: [Tagable]
	var title: String
	var selectedTagIds: [Int] = [Int]()
	var row = 0
	var singleLineTagViews = [AISingleLineTagView]()
	init(title: String = "", tags: [Tagable], frame: CGRect) {
		self.title = title
		self.tags = tags
		super.init(frame: frame)
		self.calculateSelectedTagIdsWith(tags: tags)
		self.setupNofitication()
		self.renderAllViews()
	}
	
	struct Constants {
		static var margin: CGFloat = 10 {
			didSet {
				NSNotificationCenter.defaultCenter().postNotificationName(kNeedRerenderAllViews, object: nil)
			}
		}
		static let kNeedRerenderAllViews = "kNeedRerenderAllViews"
		struct Tag {
			static let normalBackgroudColor = UIColor.clearColor()
			static let highlightedBackgroundColor = UIColor.grayColor()
            static let textColor = UIColor.whiteColor()
			static var spaceBetweenTags: CGFloat = 5 {
				didSet {
					NSNotificationCenter.defaultCenter().postNotificationName(kNeedRerenderAllViews, object: nil)
				}
			}
		}
	}
	
	func calculateSelectedTagIdsWith(tags tags: [Tagable]) {
		
		
		let getSelectedInTags: ([Tagable]) -> (Tagable, Int)? = { tags in
			let selectedTag: Tagable? = tags.filter({ (t) -> Bool in
				return t.selected
			}).first
			
			if let t = selectedTag {
				return (t, t.id)
			} else {
				return nil
			}
		}
		
		if let tuple = getSelectedInTags(tags) {
			selectedTagIds.append(tuple.1)
			if let subtags = tuple.0.subtags {
				calculateSelectedTagIdsWith(tags: subtags)
			}
		}
	}
	
	func setupNofitication() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderAllViews()", name: Constants.kNeedRerenderAllViews, object: nil)
	}
	
	func renderAllViews() {
		for v in subviews {
			v.removeFromSuperview()
		}
		
		if title != "" {
			titleLabel.text = title
            titleLabel.textColor = UIColor.whiteColor()
			addSubview(titleLabel)
			titleLabel.frame = CGRectMake(Constants.margin, 0, bounds.size.width - Constants.margin, 20)
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
		renderAllViews()
		sendActionsForControlEvents(.ValueChanged)
	}
	
	func addSingleLineTagView(tags tags: [Tagable], parent: Tagable? = nil) {
		let previousSingleLineTagView = subviews.last
		if tags.last != nil {
			// init single line tag view
			let s = AISingleLineTagView(tags: tags, frame: frame)
			s.tagNormalColor = Constants.Tag.normalBackgroudColor
			s.tagSelectedColor = Constants.Tag.highlightedBackgroundColor
            s.setTagTextColor(Constants.Tag.textColor)
			
			s.addTarget(self, action: "singleLineTagViewValueChanged:", forControlEvents: .ValueChanged)
			addSubview(s)
			if let p = previousSingleLineTagView {
				var f = s.frame
				f.origin.y = CGRectGetMaxY(p.frame)
				s.frame = f
				
				var selfFrame = frame
				selfFrame.size.height = CGRectGetMaxY(f)
				frame = selfFrame
			} else if title != "" {
				
				var selfFrame = frame
				selfFrame.size.height = CGRectGetWidth(titleLabel.frame)
				frame = selfFrame
			}
			singleLineTagViews.append(s)
			s.row = row
			
			// TODO: 根据 selected 判断 selected id
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
	
	var selected: Bool {
		get
	}
}
func == (lhs: Tagable, rhs: Tagable) -> Bool {
	return lhs.id == rhs.id
}
