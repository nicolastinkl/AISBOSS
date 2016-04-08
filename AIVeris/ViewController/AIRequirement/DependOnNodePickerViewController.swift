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
	struct Constants {
		static let cellHeight: CGFloat = 160 / 3
        static let separatorColor = UIColorFromHex(0xacdaff, alpha: 0.28)
	}
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
	var gradientLayer: CAGradientLayer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupBackgroundImageView()
		setupIconsContainerView()
		setupTableView()
		setupGradientLayer()
		setupDetermineButton()
	}
	
	func setupBackgroundImageView() {
		let imageView = UIImageView(image: UIImage(named: "taskSelectBg"))
		view.addSubview(imageView)
		imageView.snp_makeConstraints { (make) in
			make.edges.equalTo(view)
		}
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
				if t != nil {
					var s = services[i]
					s.selected = true
					services[i] = s
					updateServices()
					tableView.reloadData()
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
			logoContainerView.height == 218 / 3
		}
		
		for i in 0 ... 7 {
			let imageView = CycleImageView()
			imageView.tag = i
			imageView.userInteractionEnabled = true
			imageView.cycleColor = UIColorFromHex(0x0f86e8)
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
        
        
        // add bottom line
        let line = UIView()
        line.backgroundColor = Constants.separatorColor
        logoContainerView.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(logoContainerView)
            make.height.equalTo(1 / UIScreen.mainScreen().scale)
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
		let tableViewContainer = UIView()
		tableView = UITableView(frame: .zero, style: .Plain)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Constants.cellHeight, right: 0)
		tableView.backgroundColor = UIColor.clearColor()
		tableView.separatorColor = Constants.separatorColor
		let cellNib = UINib(nibName: "DependOnNodeCell", bundle: nil)
		tableView.registerNib(cellNib, forCellReuseIdentifier: "cell")
		tableViewContainer.addSubview(tableView)
		view.addSubview(tableViewContainer)
		
		tableView.tableFooterView = UIView() // remove empty cells
		
		constrain(view, tableViewContainer, logoContainerView) { (view, tableViewContainer, logoContainerView) -> () in
			view.leading == tableViewContainer.leading
			view.trailing == tableViewContainer.trailing
			tableViewContainer.top == logoContainerView.bottom
		}
		
		tableView.snp_makeConstraints { (make) in
			make.edges.equalTo(tableViewContainer)
		}
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		gradientLayer.frame = tableView.superview!.bounds
		let height = gradientLayer.frame.size.height
		let halfCellHeight = Constants.cellHeight / 2
		
		let radio = 1 - halfCellHeight / height
		
		gradientLayer.locations = [
			0.25,
			0.75,
			radio,
			1.0
		]
	}
	
	func setupGradientLayer() {
		// http://stackoverflow.com/questions/25355058/apply-vertical-alpha-gradient-to-uitableview
		
		gradientLayer = CAGradientLayer()
		gradientLayer.frame = tableView.superview?.bounds ?? CGRectNull
		
		gradientLayer.colors = [
			UIColor.blackColor().CGColor,
			UIColor.blackColor().CGColor,
			UIColor.clearColor().CGColor,
			UIColor.clearColor().CGColor
		]
		
		tableView.superview?.layer.mask = gradientLayer
	}
	
	func setupDetermineButton() {
		let button = UIButton()
		button.setTitle("Determine", forState: .Normal)
		button.titleLabel?.font = AITools.myriadSemiCondensedWithSize(16)
		button.backgroundColor = UIColorFromHex(0x0f86e8)
		button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		button.layer.cornerRadius = 20
		button.addTarget(self, action: "determineButtonPressed", forControlEvents: .TouchUpInside)
		view.addSubview(button)
		
		button.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(tableView.snp_bottom).offset(8)
			make.bottom.equalTo(view).offset(-54)
			make.size.equalTo(CGSize(width: 107, height: 40))
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
            cell.selected = false
            if let _ = selectedTask {
                cell.selected = task.id == selectedTask?.id
            }
   
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
		return Constants.cellHeight
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let task = allTasks[indexPath.row]
		selectedTask = task
	}
}

class CycleImageView: UIImageView {
	lazy var imageView: UIImageView = { [unowned self] in
		let result = UIImageView()
		self.addSubview(result)
		result.snp_makeConstraints(closure: { (make) in
			make.center.equalTo(self)
			make.top.equalTo(4)
			make.leading.equalTo(4)
		})
		return result
	}()
	
	var selected: Bool = false {
		didSet {
			layer.borderWidth = selected ? 10 / 3: 0
		}
	}
	
	var cycleColor: UIColor? {
		didSet {
			if let cycleColor = cycleColor {
				layer.borderColor = cycleColor.CGColor
			}
		}
	}
	
	override func asyncLoadImage(imgUrl: String) {
		imageView.asyncLoadImage(imgUrl)
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
