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
	
	var services: [DependOnService]?
	
    var serviceRoles : [AIServiceProvider]?
    
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

        // save here
        view.showLoadingWithMessage("请稍候...")
        weak var wf = self
        
        AIRequirementHandler.defaultHandler().addNewTask(1, customID: 1, orderID: 1, requirementID: 1, requirementType: "", toType: "", requirementList: [], success: { (unassignedNum) -> Void in
            wf!.view.dismissLoading()
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIRequireContentViewControllerCellWrappNotificationName, object: nil)
            
            wf!.dismissViewControllerAnimated(true, completion: nil)
            
            
            }) { (errType, errDes) -> Void in
                wf!.view.dismissLoading()
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
	
	// 点击依赖节点logo
	func taskTimeLineViewDidClickDependOnNodeLogo(taskTimeLineView: AITaskTimeLineView) {
		let vc = DependOnNodePickerViewController()
		if let dependOnTask = dependOnTask {
			vc.selectedTask = dependOnTask
		}
		
		var frame = vc.view.frame
		frame.size.height = 500
		vc.view.frame = frame
		vc.delegate = self
		if let services = services {
			vc.services = services
		} else {
			vc.services = self.fakeServices()
		}
		presentPopupViewController(vc, animated: true)
	}
	
//    点击时间picker logo
	func taskTimeLineViewDidClickDatePickerLogo(taskTimeLineView: AITaskTimeLineView) {
		let vc = AITimePickerViewController.initFromNib()
		vc.taskDate = dependOnTask!.date
		if let dateNode = dateNode {
			vc.date = dateNode.date
		}
		
		vc.onDetermineButtonClick = { [weak self] date, dateDescription in
//			print(self)
			self?.dateNode = (date: date, dateDescription: dateDescription)
		}
		presentPopupViewController(vc, animated: true)
	}
	
//    点击remark logo
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
	
    func fakeServices() -> [DependOnService] {
		
        
        self.view.showLoadingWithMessage("请稍候...")
        
        var services = [DependOnService]()
        
        var postCount = 0
        
        if let roles = serviceRoles {
            for i in 0 ... roles.count - 1 {
                
                let role = roles[i] as AIServiceProvider
                
                AIRequirementHandler.defaultHandler().queryTaskList("\(role.relservice_instance_id)", serviceIcon: role.provider_portrait_url, success: { (task) -> Void in
                    services.append(task)
                    postCount++
                    }, fail: { (errType, errDes) -> Void in
                    postCount++
                })
            }
        }
        
        while (postCount != serviceRoles?.count) {
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
        }
        
        self.view.dismissLoading()

		return services
	}
	
	func randomTask() -> TaskNode {
		let task = TaskNode(date: NSDate(timeIntervalSinceNow: Double(random() % 24 * 3600)), desc: "Task descriptionTask descriptionTask description", id: random() % 100000)
		return task
	}
}
