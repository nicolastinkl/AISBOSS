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
		edgesForExtendedLayout = .None
		view.backgroundColor = UIColor(red: 0.0392, green: 0.1137, blue: 0.3765, alpha: 1.0)
		setupNavigationToAppTheme()
		
		timeLineView = UINib(nibName: "AITaskTimeLineView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! AITaskTimeLineView
		view.addSubview(timeLineView)
		constrain(view, timeLineView) { (view, timeLineView) -> () in
			timeLineView.edges == view.edges
		}
		
		timeLineView.delegate = self
	}
}

extension AITaskEditViewController: AITaskNavigationDelegate {
	func cancelButtonPressed(sender: UIButton) {
		print("cancel button pressed")
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func saveButtonPressed(sender: UIButton) {
		dismissViewControllerAnimated(true, completion: nil)
		print("save button pressed")
	}
}

protocol AITaskNavigationDelegate {
	func cancelButtonPressed(sender: UIButton)
	func saveButtonPressed(sender: UIButton)
}
// MARK: - AITaskNavigationDelegate where Self: UIViewController
extension AITaskNavigationDelegate where Self: UIViewController {
	func setupNavigationToAppTheme() {
		let bar = navigationController?.navigationBar
		if let bar = bar {
			bar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
			
			bar.setBackgroundImage(UIImage(named: "bg_top_0"), forBarPosition: .Any, barMetrics: .Default)
			
			let cancelButton = UIButton()
			cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
			cancelButton.setTitle("Cancel", forState: .Normal)
			cancelButton.addTarget(self, action: "cancelButtonPressed:", forControlEvents: .TouchUpInside)
			cancelButton.sizeToFit()
			let cancelBarButtonItem = UIBarButtonItem(customView: cancelButton)
			
			navigationItem.leftBarButtonItem = cancelBarButtonItem
			
			let saveButton = UIButton()
			saveButton.setTitle("Save", forState: .Normal)
			saveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
			saveButton.addTarget(self, action: "saveButtonPressed:", forControlEvents: .TouchUpInside)
			saveButton.backgroundColor = UIColor(red: 0.0784, green: 0.4353, blue: 0.8863, alpha: 1.0)
			saveButton.layer.cornerRadius = 4
			saveButton.sizeToFit()
			var frame = saveButton.frame
			frame.size.width += 20
			saveButton.frame = frame
			let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
			navigationItem.rightBarButtonItem = saveBarButtonItem
		}
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
		frame.size.height = 400
		vc.view.frame = frame
		vc.delegate = self
		vc.services = self.dynamicType.fakeServices()
//		navigationController?.useBlurForPopup = false
		presentPopupViewController(vc, animated: true)
	}
	func taskTimeLineViewDidClickDatePickerLogo(taskTimeLineView: AITaskTimeLineView) {
		let vc = AITimePickerViewController()
		if let dateNode = dateNode {
			vc.date = dateNode.date
		}
//		navigationController?.useBlurForPopup = true
		
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
		let vc = AITaskRemarkInputViewController()
		vc.delegate = self
//		navigationController?.useBlurForPopup = true
		presentPopupViewController(vc, duration: 0.1, animated: true)
		vc.text = remark
	}
}

extension AITaskEditViewController: AITaskRemarkInputViewControllerDelegate {
	func remarkInputViewControllerDidEndEditing(sender: AITaskRemarkInputViewController, text: String?) {
		self.remark = text
	}
}

// MARK: - fake data
extension AITaskEditViewController  {
    
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
