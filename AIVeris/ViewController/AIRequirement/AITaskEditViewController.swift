//
//  AITaskEditViewController.swift
//  DimPresentViewController
//
//  Created by admin on 3/10/16.
//  Copyright © 2016 __ASIAINFO__. All rights reserved.
//

import UIKit
import Cartography

class AITaskEditViewController: UIViewController {
	
	var timeLineView: AITaskTimeLineView!
	var dependOnTask: TaskNode? {
		didSet {
			var string: String?
			if let dependOnTask = dependOnTask {
				string = dependOnTask.desc
			} else {
				string = nil
			}
			
			timeLineView?.label1.text = string
			timeLineView.setNeedsUpdateConstraints()
			timeLineView.updateConstraintsIfNeeded()
			UIView.animateWithDuration(0.25) { () -> Void in
				self.timeLineView?.logo2.highlighted = self.timeLineView!.isTopLogoAtLeft
				self.timeLineView?.layoutIfNeeded()
				self.timeLineView?.animationLines()
			}
		}
	}
	var dateNode: (date: NSDate, dateDescription: String)? {
		didSet {
			timeLineView?.label2?.text = dateNode?.dateDescription
			timeLineView?.setNeedsUpdateConstraints()
			timeLineView?.updateConstraintsIfNeeded()
			UIView.animateWithDuration(0.25) { () -> Void in
				self.timeLineView?.logo3.highlighted = self.timeLineView!.isMiddleLogoAtLeft
				self.timeLineView?.layoutIfNeeded()
				self.timeLineView?.animationLines()
			}
		}
	}
	var remark: String? {
		didSet {
			timeLineView?.label3?.text = remark
			timeLineView?.setNeedsUpdateConstraints()
			timeLineView?.updateConstraintsIfNeeded()
			UIView.animateWithDuration(0.25) { () -> Void in
				self.timeLineView?.layoutIfNeeded()
				self.timeLineView?.animationLines()
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationAndBackgroundImage()
        navigationBar.titleLabel.text = "Task"
		saveButtonEnabled = false
		
		setupTimeLineView()
	}
	
	func setupTimeLineView() {
		timeLineView = UINib(nibName: "AITaskTimeLineView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! AITaskTimeLineView
		view.addSubview(timeLineView)
		timeLineView.snp_makeConstraints { (make) in
			make.leading.trailing.bottom.equalTo(view)
			make.top.equalTo(navigationBar.snp_bottom)
		}
		
		timeLineView.delegate = self
	}
}

extension AITaskEditViewController: AITaskNavigationBarDelegate {
	func navigationBar(navigationBar: AITaskNavigationBar, cancelButtonPressed: UIButton) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func navigationBar(navigationBar: AITaskNavigationBar, saveButtonPressed: UIButton) {
		dismissViewControllerAnimated(true, completion: nil)
		print("save button pressed")
	}
}

extension AITaskEditViewController: DependOnNodePickerViewControllerDelegate {
	func dependOnNodePickerViewController(dependOnNodePickerViewController: DependOnNodePickerViewController, didDetermineWithTask task: TaskNode?) {
		dependOnTask = task
	}
}

// MARK: - AITaskTimeLineViewDelegate
extension AITaskEditViewController: AITaskTimeLineViewDelegate {
	func taskTimeLineViewDidClickDependOnNodeLogo(taskTimeLineView: AITaskTimeLineView) {
		let vc = DependOnNodePickerViewController()
		if let dependOnTask = dependOnTask {
			vc.selectedTask = dependOnTask
		}
		
		var frame = vc.view.frame
		frame.size.height = 500
		vc.view.frame = frame
		vc.delegate = self
		vc.services = self.dynamicType.fakeServices()
		presentPopupViewController(vc, animated: true)
	}
	func taskTimeLineViewDidClickDatePickerLogo(taskTimeLineView: AITaskTimeLineView) {
		let vc = AITimePickerViewController.initFromNib()
		vc.taskDate = dependOnTask!.date
		if let dateNode = dateNode {
			vc.date = dateNode.date
		}
		
		vc.onDetermineButtonClick = { date, dateDescription in
			print(self)
			self.dateNode = (date: date, dateDescription: dateDescription)
		}
		presentPopupViewController(vc, duration: 0.25, animated: true, completion: { () -> () in
			}, onClickCancelArea: {
			print("cancel")
		})
	}
    
	func taskTimeLineViewDidClickRemarkLogo(taskTimeLineView: AITaskTimeLineView) {
		let vc = AITaskInputViewController.initFromNib()
		vc.delegate = self
		presentPopupViewController(vc, duration: 0.1, animated: true)
		vc.text = remark
	}
}

extension AITaskEditViewController: AITaskInputViewControllerDelegate {
	func remarkInputViewControllerDidEndEditing(sender: AITaskInputViewController, text: String?) {
		remark = text
		// update save button enable
		saveButtonEnabled = text?.length > 0
	}
}

// MARK: - fake data
extension AITaskEditViewController {
	
	static var fakeServiceResult: [DependOnService]?
	
	class func fakeServices() -> [DependOnService] {
		
		if let result = fakeServiceResult {
			return result
		}
		
		var result = [DependOnService]()
		for _ in 0 ... 7 {
			var tasks = [TaskNode]()
			for _ in 0 ... 4 {
				tasks.append(randomTask())
			}
			
			let service = DependOnService(id: random() % 100, icon: "http://171.221.254.231:3000/upload/shoppingcart/3CHKvIhwNsH0T.png", desc: "Service description", tasks: tasks, selected: false)
			result.append(service)
		}
		fakeServiceResult = result
		
		return result
	}
	
	class func randomTask() -> TaskNode {
		let task = TaskNode(date: NSDate(timeIntervalSinceNow: Double(random() % 24 * 3600)), desc: "Task descriptionTask descriptionTask description", id: random() % 100000)
		return task
	}
}
