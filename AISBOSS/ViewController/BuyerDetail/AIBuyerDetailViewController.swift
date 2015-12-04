//
// UIBuyerDetailViewController.swift
// AIVeris
//
// Created by tinkl on 3/11/2015.
// Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

import UIKit
import AISpring
import Cartography

protocol AIBuyerDetailDelegate: class {
	func closeAIBDetailViewController()
}

class AIBuyerDetailViewController : UIViewController, ServiceRestoreToolBarDelegate, ServiceRestoreToolBarDataSource {

	// MARK: Priate Variable

	private var cellHeights: [Int : CGFloat] = [Int : CGFloat]()
	private var dataSource : AIProposalInstModel!
	var bubleModel : AIBuyerBubbleModel?
	weak var delegate: AIBuyerDetailDelegate?

	// MARK: swift controls

	@IBOutlet weak var bgLabel: DesignableLabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var videoButton: UIButton!
	@IBOutlet weak var moneyLabel: UILabel!
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var OrderFromLabel: UILabel!
	@IBOutlet weak var totalMoneyLabel: UILabel!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var whereLabel: UILabel!
	@IBOutlet weak var infoButton: UIButton!

	private var contentView: UIView?
	@IBOutlet weak var bottomView: UIView!

	private var serviceRestoreToolbar : ServiceRestoreToolBar!

	// MARK: getters and setters

	private var horizontalCardCellCache = NSMutableDictionary()

	// MARK: life cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		self.tableView.registerClass(AIBueryDetailCell.self, forCellReuseIdentifier: "cell")
		self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50.0, 0)

		contentView = self.tableView.tableHeaderView?.viewWithTag(1)

		initServiceRestoreToolbar()

		// Init Label Font
		InitLabelFont()

		// Make
		// makeBuyButton()

		// Add Pull To Referesh..
		self.tableView.addHeaderWithCallback {[weak self]() -> Void in
			if let strongSelf = self {
				// Init Data
				strongSelf.initData()

			}
		}

		self.tableView.headerBeginRefreshing()

	}

	func initServiceRestoreToolbar() {
		serviceRestoreToolbar = ServiceRestoreToolBar.currentView()
		serviceRestoreToolbar.delegate = self
		serviceRestoreToolbar.dataSource = self
		serviceRestoreToolbar.frame = CGRectMake(0, 30, CGRectGetWidth(view.frame), 50)
		bottomView.addSubview(serviceRestoreToolbar)
	}

	func targetDetail2() {
		let vc = AIServiceContentViewController()
		vc.serviceContentType = AIServiceContentType.Escort
		self.showViewController(vc, sender: self)
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		self.bgLabel.animation = "zoomOut"
		self.bgLabel.duration = 0.5
		self.bgLabel.animate()

	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

		// self.tableView.layoutSubviews()
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.NSNotiryAricToNomalStatus, object: nil)
	}

	func makeBuyButton() {
		let button = UIButton(type: .Custom)
		button.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 100, CGRectGetWidth(self.view.frame), 100)
		button.addTarget(self, action: "showNextViewController", forControlEvents: .TouchUpInside)
		self.view.addSubview(button)
	}

	func InitBottomView() {
		let bzView = UIBezierPageView(frame: CGRectMake(0, 38, 200, 50))
		bzView.setX((self.view.width - bzView.width) / 2)
		if let list = self.dataSource.service_list as? [AIProposalServiceModel] {
			bzView.refershModelView(list)
		}
		self.bottomView.addSubview(bzView)
		// layout subviews

	}


	func showNextViewController() {

		let vc = AIServiceContentViewController()
		vc.serviceContentType = AIServiceContentType.MusicTherapy
		self.showViewController(vc, sender: self)

	}

	func InitController() {

		let name = bubleModel?.proposal_name ?? ""
		self.backButton.setTitle(name, forState: UIControlState.Normal)
		self.moneyLabel.text = dataSource?.order_total_price

		self.numberLabel.text = "\(dataSource?.order_times ?? 0)"
		self.whereLabel.text = dataSource?.proposal_origin
		self.contentLabel.text = dataSource?.proposal_desc
		self.OrderFromLabel.text = "From"

		if NSString(string: name).containsString("Pregnancy") {
			// 处理字体
			let price = dataSource?.proposal_price
			let richText = NSMutableAttributedString(string:(price)!)
			richText.addAttribute(NSFontAttributeName, value: AITools.myriadLightSemiCondensedWithSize(45 / PurchasedViewDimention.CONVERT_FACTOR) , range: NSMakeRange(price!.length - 6, 6)) // 设置字体大小
			self.totalMoneyLabel.attributedText = richText

		}else {
			self.totalMoneyLabel.text = dataSource?.proposal_price
		}

		self.totalMoneyLabel.textColor = AITools.colorWithR(253, g: 225, b: 50)
	}

	func InitLabelFont() {
		self.backButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(60 / PurchasedViewDimention.CONVERT_FACTOR)
		self.moneyLabel.font = AITools.myriadLightSemiCondensedWithSize(39 / PurchasedViewDimention.CONVERT_FACTOR)
		self.numberLabel.font = AITools.myriadLightSemiCondensedWithSize(39 / PurchasedViewDimention.CONVERT_FACTOR)
		self.OrderFromLabel.font = AITools.myriadLightSemiCondensedWithSize(42 / PurchasedViewDimention.CONVERT_FACTOR)
		self.totalMoneyLabel.font = AITools.myriadSemiCondensedWithSize(61 / PurchasedViewDimention.CONVERT_FACTOR)
		self.whereLabel.font = AITools.myriadLightSemiCondensedWithSize(42 / PurchasedViewDimention.CONVERT_FACTOR)
		self.contentLabel.font = AITools.myriadLightSemiCondensedWithSize(42 / PurchasedViewDimention.CONVERT_FACTOR)
	}

	// MARK: - ServiceRestoreToolBarDataSource
	func serviceRestoreToolBar(serviceRestoreToolBar: ServiceRestoreToolBar, imageAtIndex index: Int) -> UIImage? {
		return nil;

	}

	// MARK: - ServiceRestoreToolBarDelegate
	func serviceRestoreToolBar(serviceRestoreToolBar: ServiceRestoreToolBar, didClickLogoAtIndex index: Int) {

	}

	func serviceRestoreToolBarDidClickBlankArea(serviceRestoreToolBar: ServiceRestoreToolBar) {

	}

	// MARK: - 删除service

	func logoMoveToServiceRestoreToolBar(logo: UIImageView, completion:(() -> Void)?) {
		let window = UIApplication.sharedApplication().keyWindow;
		let fromFrameOnWindow = logo.convertRect(logo.bounds, toView: window)

		let firstLogo = serviceRestoreToolbar.logos[2]
		let toFrameOnWindow = firstLogo.convertRect(firstLogo.bounds, toView: window)

		let fakeLogo = UIImageView(image: logo.image)
		fakeLogo.frame = fromFrameOnWindow

		window?.addSubview(fakeLogo)

		UIView.animateWithDuration(1.25, animations: {() -> Void in
				fakeLogo.frame = toFrameOnWindow
			}) {(success) -> Void in
			if let c = completion {
				c();
			}
		}
	}

	// MARK: event response

	@IBAction func closeThisViewController() {
		delegate?.closeAIBDetailViewController()
		self.dismissViewControllerAnimated(false) {() -> Void in

		}
	}

	// MARK: private methods

	func refershData() {

	}

	func initData() {
		self.tableView.hideErrorView()
		if let m = bubleModel {
			if let cView = contentView {

				let newlayout = NSLayoutConstraint(item: cView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 77)

				cView.addConstraints([newlayout])

				cView.updateConstraints()
			}

			BDKProposalService().queryCustomerProposalDetail(m.proposal_id, success:
					{[weak self] (responseData) -> Void in

					if let strongSelf = self {
						strongSelf.dataSource = responseData

						// InitControl Data
						strongSelf.InitController()
						strongSelf.tableView.reloadData()

						// Init Bottom Page white area
						strongSelf.InitBottomView()

						strongSelf.tableView.headerEndRefreshing()
					}

				}, fail : {[weak self]
					(errType, errDes) -> Void in
					if let strongSelf = self {

						strongSelf.tableView.headerEndRefreshing()
						// 处理错误警告

						strongSelf.tableView.showErrorContentView()

					}

				})

		}

	}

}

// MARK: delegate

// MARK: datesource

// MARK: function extension
extension AIBuyerDetailViewController: UITableViewDataSource, UITableViewDelegate {
 
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource == nil{
            return 0
        }else {
            return dataSource.service_list.count
        }
    }
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        if let height = cellHeights[indexPath.row] {
//            cell.contentView.subviews.first?.frame.size.height = height
//        }
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Settings Cache IndexRow.
        let key = "servicelist_\(indexPath.row)"
        if let cacheCell = horizontalCardCellCache.valueForKey(key) as! UITableViewCell? {
            return cacheCell
        }
        
        // Create Cell
        let cell = AIBueryDetailCell.currentView()
        let serviceDataModel = dataSource.service_list[indexPath.row] as! AIProposalServiceModel
        let serviceView = SimpleServiceViewContainer.currentView()
        serviceView.loadData(serviceDataModel)
        cell.contentHoldView.addSubview(serviceView)
        
        cell.removeDelegate = self  // Action delegate.
        cell.delegate = self    // Swipe delegate.
        
        // Settings
        cell.currentModel = serviceDataModel
        
        // Add constrain
        constrain(serviceView, cell.contentHoldView) { (cview, container) -> () in
            cview.left == container.left + 10
            cview.top == container.top
            cview.bottom == container.bottom
            cview.right == container.right - 10
        }
        
        //Cache Cell.
        cellHeights[indexPath.row] = serviceView.selfHeight()
        horizontalCardCellCache.setValue(cell, forKey: key)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let height = cellHeights[indexPath.row] {
            return height + 10
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let serviceDataModel = dataSource.service_list[indexPath.row] as! AIProposalServiceModel
       
        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIPageBueryViewController) as! AIPageBueryViewController
        
        let model1 = AIProposalServiceModel()
        if serviceDataModel.service_id == 1 {
            model1.service_id = 2
        }else{
            model1.service_id = 1
        }
        model1.service_desc = "Service"
        
        let array = [serviceDataModel,model1]
        //viewController.bubleModelArray = dataSource.service_list as? [AIProposalServiceModel]
        viewController.bubleModelArray = array
        viewController.selectCurrentIndex = 0 // fix here
        self.showViewController(viewController, sender: self)
        
    }
}

// MARK: Extension.
extension AIBuyerDetailViewController: AIBueryDetailCellDetegate {

	func removeCellFromSuperView(cell: AIBueryDetailCell, model: AIProposalServiceModel?) {
		let view: SimpleServiceViewContainer = cell.contentView.viewWithTag(SimpleServiceViewContainer.simpleServiceViewContainerTag) as! SimpleServiceViewContainer
		let logo = view.logo
        //TODO: delete from server
        
    }
    
}


extension AIBuyerDetailViewController: AISuperSwipeableCellDelegate{
    
    func cellDidAimationFrame(position: CGFloat, cell: UITableViewCell!) {
//        self.tableView.scrollEnabled = false
    }
    
    func cellDidClose(cell: UITableViewCell!) {
//        self.tableView.scrollEnabled = true
    }
    
    func cellDidOpen(cell: UITableViewCell!) {
//        self.tableView.scrollEnabled = false
    }
}