//
//  DependOnNodePickerViewController.swift
//  DimPresentViewController
//
//  Created by admin on 3/17/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

import UIKit
import Cartography

protocol DependOnNodePickerViewControllerDelegate {
	func dependOnNodePickerViewController(dependOnNodePickerViewController: DependOnNodePickerViewController, didDetermineWithTask task: TaskNode?)
}

class DependOnNodePickerViewController: UIViewController {
	var delegate: DependOnNodePickerViewControllerDelegate?
    var services: [DependOnService] = [DependOnService]() {
        didSet {
            updateServices()
        }
    }
	
	var allTasks: [TaskNode] {
		// 取出所有选中的service 的tasks 组成一个数组
		let result = services.filter { $0.selected }.flatMap { $0.tasks }.sort { $0.date < $1.date }
		return result
	}
	
	var selectedTask: TaskNode? {
		didSet {
			updateServices()
			tableView?.reloadData()
		}
	}
	
	var serviceLogos = [CycleImageView]()
	var logoContainerView: UIView!
	var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor(red: 0.0392, green: 0.1137, blue: 0.3765, alpha: 1.0)
		setupIconsContainerView()
		setupTableView()
		setupDetermineButton()
	}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupSelectedService()
    }
	
	func setupSelectedService() {
		if let selectedTask = selectedTask {
			for (i, service) in services.enumerate() {
				let t = service.tasks.filter({ (task) -> Bool in
					return task.id == selectedTask.id
				}).first
				if let _ = t {
					var s = services[i]
					s.selected = true
					services[i] = s
					updateServices()
					tableView.reloadData()
//                    let index = allTasks.indexOf(t)
//                    tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: index!, inSection: 0), atScrollPosition: .Middle, animated: false)
					break
				}
			}
		}
	}
	
	func setupIconsContainerView() {
		logoContainerView = UIView()
		logoContainerView.backgroundColor = UIColor.clearColor()
		view.addSubview(logoContainerView)
		
		constrain(view, logoContainerView) { (view, logoContainerView) -> () in
			view.top == logoContainerView.top
			view.leading == logoContainerView.leading
			view.trailing == logoContainerView.trailing
			logoContainerView.height == 218/3
		}
		
		for i in 0 ... 7 {
			let imageView = CycleImageView()
			imageView.tag = i
			imageView.userInteractionEnabled = true
			imageView.cycleColor = UIColor(red: 0.1216, green: 0.4157, blue: 0.7922, alpha: 1.0)
			logoContainerView.addSubview(imageView)
			
			serviceLogos.append(imageView)
		}
		
		let margin = 51 / 3
		var previousView: CycleImageView!
		
		for (i, imageView) in serviceLogos.enumerate() {
			if i == 0 {
				// first one
				imageView.snp_makeConstraints(closure: { (make) -> Void in
					make.leading.equalTo(margin)
					make.centerY.equalTo(logoContainerView)
				})
			} else if i == 7 {
				// last one
				imageView.snp_makeConstraints(closure: { (make) -> Void in
					make.leading.equalTo(previousView.snp_trailing).offset(margin)
					make.centerY.equalTo(logoContainerView)
					make.size.equalTo(previousView)
					make.width.equalTo(imageView.snp_height)
					make.trailing.equalTo(logoContainerView).offset(-margin)
				})
			} else {
				imageView.snp_makeConstraints(closure: { (make) -> Void in
					make.leading.equalTo(previousView.snp_trailing).offset(margin)
					make.centerY.equalTo(logoContainerView)
					make.width.equalTo(imageView.snp_height)
					make.size.equalTo(previousView)
				})
			}
			
			previousView = imageView
		}
	}
	
	func updateServices() {
		// clear all image and gesture
		serviceLogos.forEach { (imageView) -> () in
			imageView.image = nil
			for recognizer in imageView.gestureRecognizers ?? [] {
				imageView.removeGestureRecognizer(recognizer)
			}
		}
		
		// setup imageview with service
		for (i, service) in services.enumerate() {
			let imageView = serviceLogos[i]
			imageView.asyncLoadImage(service.icon)
			imageView.selected = service.selected
			let tap = UITapGestureRecognizer(target: self, action: "logoTapped:")
			imageView.addGestureRecognizer(tap)
		}
	}
	
	func setupTableView() {
		tableView = UITableView(frame: .zero, style: .Plain)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = UIColor.clearColor()
		let cellNib = UINib(nibName: "DependOnNodeCell", bundle: nil)
		tableView.registerNib(cellNib, forCellReuseIdentifier: "cell")
		view.addSubview(tableView)
		
		tableView.tableFooterView = UIView() // remove empty cells
		
		constrain(view, tableView, logoContainerView) { (view, tableView, logoContainerView) -> () in
			view.leading == tableView.leading
			view.trailing == tableView.trailing
			tableView.top == logoContainerView.bottom
		}
	}
	
	func setupDetermineButton() {
		let button = UIButton()
		button.setTitle("Determine", forState: .Normal)
		button.titleLabel?.font = UIFont.systemFontOfSize(15)
		button.backgroundColor = UIColor(red: 0.0745, green: 0.4431, blue: 0.8941, alpha: 1.0)
		button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		button.layer.cornerRadius = 15
		button.addTarget(self, action: "determineButtonPressed", forControlEvents: .TouchUpInside)
		view.addSubview(button)
		
		button.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(tableView.snp_bottom).offset(8)
			make.bottom.equalTo(view).offset(-8)
			make.size.equalTo(CGSize(width: 100, height: 30))
			make.centerX.equalTo(view)
		}
	}
	
	func determineButtonPressed() {
		dismissPopupViewController(true) { () -> Void in
			if let delegate = self.delegate {
				delegate.dependOnNodePickerViewController(self, didDetermineWithTask: self.selectedTask)
			}
		}
	}
	
	func logoTapped(g: UITapGestureRecognizer) {
		let logo = g.view as! CycleImageView
		logo.selected = !logo.selected
		var service = services[logo.tag]
		service.selected = logo.selected
		services[logo.tag] = service
		tableView.reloadData()
	}
}

// MARK: - UITableViewDataSource
extension DependOnNodePickerViewController: UITableViewDataSource {
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let task = allTasks[indexPath.row]
		if let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? DependOnNodeCell {
			cell.desc = task.desc
			cell.date = task.date
			cell.selected = task == selectedTask
			return cell
		} else {
			// never goes here
			let cell = DependOnNodeCell(style: .Default, reuseIdentifier: "cell")
			return cell
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allTasks.count
	}
}

// MARK: - UITableViewDelegate
extension DependOnNodePickerViewController: UITableViewDelegate {
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 80
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let task = allTasks[indexPath.row]
		selectedTask = task
	}
}



class CycleImageView: UIImageView {
	var selected: Bool = false {
		didSet {
			layer.borderWidth = selected ? 1 : 0
		}
	}
	
	var cycleColor: UIColor? {
		didSet {
			if let cycleColor = cycleColor {
				layer.borderColor = cycleColor.CGColor
			}
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = width / 2
	}
}

extension NSDate: Comparable { }
public func < (lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
}
public func <= (lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
}
public func >= (lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970
}
public func > (lhs: NSDate, rhs: NSDate) -> Bool {
	return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
}
