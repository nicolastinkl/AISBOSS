//
//  DependOnNodePickerViewController.swift
//  DimPresentViewController
//
//  Created by admin on 3/17/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

import UIKit
import Cartography

class DependOnNodePickerViewController: UIViewController {
	var services: [DependOnService] = []
	var allTasks: [TaskNode] {
		// 取出所有选中的service 的tasks 组成一个数组
		let result = services.filter { $0.selected }.flatMap { $0.tasks }
		return result
	}
	
	var logoContainerView: UIView!
	var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupIconsContainerView()
		setupTableView()
	}
	
	func setupIconsContainerView() {
		logoContainerView = UIView()
		logoContainerView.backgroundColor = UIColor.clearColor()
		view.addSubview(logoContainerView)
		
		constrain(view, logoContainerView) { (view, logoContainerView) -> () in
			view.top == logoContainerView.top
			view.leading == logoContainerView.leading
			view.trailing == logoContainerView.trailing
			logoContainerView.height == 64
		}
	}
	
	func setupTableView() {
		tableView = UITableView(frame: .zero, style: .Plain)
		tableView.delegate = self
		tableView.dataSource = self
		view.addSubview(tableView)
		
		constrain(view, tableView, logoContainerView) { (view, tableView, logoContainerView) -> () in
            view.leading == tableView.leading
            view.trailing == tableView.trailing
            tableView.top == logoContainerView.bottom
            tableView.bottom == view.bottom
		}
	}
}

extension DependOnNodePickerViewController: UITableViewDataSource {
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let task = allTasks[indexPath.row]
		if let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? DependOnNodeCell {
			cell.desc = task.desc
			cell.date = task.date
			return cell
		} else {
			let cell = DependOnNodeCell(style: .Default, reuseIdentifier: "cell")
			cell.desc = task.desc
			cell.date = task.date
			return cell
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allTasks.count
	}
}

extension DependOnNodePickerViewController: UITableViewDelegate {
}

struct TaskNode {
	
	var serviceIcon: String
	
	var date: NSDate
	
	var desc: String
}

struct DependOnService {
	var serviceId: Int
    
    var desc: String
	
	var tasks: [TaskNode]
	
	var selected: Bool
}