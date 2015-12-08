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

class AIBuyerDetailViewController : UIViewController {
    
    private let SIMPLE_SERVICE_VIEW_CONTAINER_TAG: Int = 233
    private let CELL_VERTICAL_SPACE: CGFloat = 10
    
//    private var cellHeights: [Int : CGFloat] = [Int : CGFloat]()
    private var dataSource : AIProposalInstModel!
    var bubbleModel : AIBuyerBubbleModel?
    weak var delegate: AIBuyerDetailDelegate?
    
    // MARK: swift controls
    
    @IBOutlet weak var bgLabel: DesignableLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deletedTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var OrderFromLabel: UILabel!
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var stretchedBg: UIView!//可恢复service拉伸区域
    @IBOutlet weak var stretchedConstraint: NSLayoutConstraint!
    var isDeletedTableViewOpen: Bool = false
    var isDeletedTableViewAnimating: Bool = false
    
    private var contentView: UIView?
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var buyerBottom: UIImageView! // 带购物车的一块
   
    var overlayView: UIView!
    
    private var menuLightView:UIBezierPageView?
    
    private var serviceRestoreToolbar : ServiceRestoreToolBar!
    
    private var current_service_list: NSArray? {
        get {
            let result = dataSource?.service_list.filter (){
                return ($0 as! AIProposalServiceModel).is_deleted_flag == 0
            }
            return result
        }
    }
    
    private var deleted_service_list: NSMutableArray = NSMutableArray()
    
//    private var horizontalCardCellCache = NSMutableDictionary()
    
    // MARK: life cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(AIBueryDetailCell.self, forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50.0, 0)
        
        contentView = tableView.tableHeaderView?.viewWithTag(1)
        
        initServiceRestoreToolbar()
        initDeletedTableView()
        initDeletedOverlayView()
        // Init Label Font
        InitLabelFont()
        
        // Make
        // makeBuyButton()
        
        // Add Pull To Referesh..
        tableView.addHeaderWithCallback {[weak self]() -> Void in
            if let strongSelf = self {
                // Init Data
                strongSelf.initData()
                
            }
        }
        
        self.tableView.headerBeginRefreshing()
        
    }
    
    func initDeletedTableView() {
        deletedTableView.registerClass(AIBueryDetailCell.self, forCellReuseIdentifier: "cell")
    }
    
    func initDeletedOverlayView() {
        overlayView = UIView()
        
        //需求: overlay在navigation之上
        view.insertSubview(overlayView, belowSubview: bottomView)
        overlayView.snp_makeConstraints { (make) -> Void in
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(stretchedBg.top)
            make.top.equalTo(navigationView.top)
        }
        overlayView.hidden = true;
        
        let tap = UITapGestureRecognizer(target: self, action: "deletedOverlayTapped")
        overlayView.addGestureRecognizer(tap)
    }
    
    //曲线和overlay 共用tapgesture
    @IBAction func deletedOverlayTapped() {
        if isDeletedTableViewOpen {
            closeDeletedTableView(true)
        }
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
        
        let bzView = UIBezierPageView(frame: CGRectMake(0, -19, 200, 50))
        bzView.setX((self.view.width - bzView.width) / 2)
        if let list = dataSource.service_list as? [AIProposalServiceModel] {
            bzView.refershModelView(list)
        }
        buyerBottom.addSubview(bzView)
//        bottomView.addSubview(bzView)
        // layout subviews
        menuLightView = bzView

    }
    
    
    func showNextViewController() {
        let vc = AIServiceContentViewController()
        vc.serviceContentType = AIServiceContentType.MusicTherapy
        self.showViewController(vc, sender: self)
        
    }
    
    func InitController() {
        
        let name = bubbleModel?.proposal_name ?? ""
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
            
        } else {
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
    
    
    
    // MARK: - 删除service
    
    func logoMoveToServiceRestoreToolBar(logo: UIImageView, completion:(() -> Void)?) {
        let window = UIApplication.sharedApplication().keyWindow;
        let fromFrameOnWindow = logo.convertRect(logo.bounds, toView: window)
        
        let index = min(deleted_service_list.count - 1, 5)
        let fromeLogo = serviceRestoreToolbar.logos[index]
        let toFrameOnWindow = fromeLogo.convertRect(fromeLogo.bounds, toView: window)
        
        let fakeLogo = UIImageView(image: logo.image)
        fakeLogo.frame = fromFrameOnWindow
        
        window?.addSubview(fakeLogo)
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        UIView.animateWithDuration(0.75, animations: {() -> Void in
            fakeLogo.frame = toFrameOnWindow
            }) {(success) -> Void in
                UIApplication.sharedApplication().endIgnoringInteractionEvents()

                if let completionFunc = completion {
                    fakeLogo.removeFromSuperview()
                    completionFunc();
                }
        }
    }

    
    @IBAction func closeThisViewController() {
        delegate?.closeAIBDetailViewController()
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    func refershData() {
        
    }
    
    func openDeletedTableView(animated:Bool) {
        deletedTableView(true, animated: true)
    }
    
    func closeDeletedTableView(animated:Bool) {
        deletedTableView(false, animated: true)
    }
    
    func deletedTableView(isOpen:Bool, animated:Bool) {
        let window = UIApplication.sharedApplication().keyWindow
        let contentLabelFrame = contentLabel.convertRect(contentLabel.bounds, toView: window)
        let contentLabelMaxY = CGRectGetMaxY(contentLabelFrame)
        
        let maxHeight = (window?.height)! - contentLabelMaxY - buyerBottom.height - 10 // 10 is magic number hehe
        
        let constant = isOpen ? min(maxHeight, deletedTableView.contentSize.height) : 0
        
        let duration = animated ? 0.25 : 0
        let restoreToolBarAlpha: CGFloat = isOpen ? 0 : 1;
        isDeletedTableViewAnimating = true
        stretchedConstraint.constant = constant
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.serviceRestoreToolbar.alpha = restoreToolBarAlpha
            }) { (completion) -> Void in
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                self.overlayView.hidden = !isOpen
                self.isDeletedTableViewAnimating = false
                self.isDeletedTableViewOpen = isOpen
        }
    }

    func restoreService(model:AIProposalServiceModel) {
        let indexInDeletedTableView = deleted_service_list.indexOfObject(model)
        model.is_deleted_flag = 0
        deleted_service_list.removeObject(model)
        let afterArray = current_service_list
        let index = (afterArray as! [AIProposalServiceModel]).indexOf(model)
        
        
        deletedTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexInDeletedTableView, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        serviceRestoreToolbar.reloadLogos()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        //0.3s 以下的时间都会引起 下面删除了cell 上面不显示cell的问题，，因为使用了cell的缓存机制
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            if self.deleted_service_list.count == 0 {
                self.closeDeletedTableView(true)
            }else {
                self.deletedTableView(self.isDeletedTableViewOpen, animated: true)
            }
        })
        
    }
    
    func initData() {
        self.tableView.hideErrorView()
        if let m = bubbleModel {
            if let cView = contentView {
                
                let newlayout = NSLayoutConstraint(item: cView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 77)
                
                cView.addConstraints([newlayout])
                
                cView.updateConstraints()
            }
            
            BDKProposalService().queryCustomerProposalDetail(m.proposal_id, success:
                {[weak self] (responseData) -> Void in
                    
                    if let viewController = self {
                        viewController.dataSource = responseData
                        
                        // InitControl Data
                        viewController.InitController()
                        viewController.tableView.reloadData()
                        
                        // Init Bottom Page white area
                        viewController.InitBottomView()
                        
                        viewController.tableView.headerEndRefreshing()
                    }
                    
                }, fail : {[weak self]
                    (errType, errDes) -> Void in
                    if let viewController = self {
                        
                        viewController.tableView.headerEndRefreshing()
                        // 处理错误警告
                        
                        viewController.tableView.showErrorContentView()
                    }
                })
        }
        
    }
    
}

extension AIBuyerDetailViewController: ServiceRestoreToolBarDataSource, ServiceRestoreToolBarDelegate {
    // MARK: - ServiceRestoreToolBarDataSource
    func serviceRestoreToolBar(serviceRestoreToolBar: ServiceRestoreToolBar, imageAtIndex index: Int) -> String? {
        if index < deleted_service_list.count {
            let model = deleted_service_list[index] as! AIProposalServiceModel
            return model.service_thumbnail_icon
        }else {
            return nil
        }
    }
    
    // MARK: - ServiceRestoreToolBarDelegate
    func serviceRestoreToolBar(serviceRestoreToolBar: ServiceRestoreToolBar, didClickLogoAtIndex index: Int) {
        
        if index < 5 {
            //TODO: show alert to comfirm
            let model = deleted_service_list[index] as! AIProposalServiceModel
            restoreService(model)
        } else {
            openDeletedTableView(true)
        }
    }
    
    func serviceRestoreToolBarDidClickBlankArea(serviceRestoreToolBar: ServiceRestoreToolBar) {
        if !isDeletedTableViewOpen && deleted_service_list.count > 0 {
            openDeletedTableView(true)
        }
    }
}


extension AIBuyerDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var serviceList: NSArray?
        
        if (tableView == deletedTableView) {
            serviceList = deleted_service_list
        } else {
            serviceList = current_service_list
        }
        
        if dataSource == nil {
            return 0
        } else {
            return serviceList!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var serviceList: NSArray?
        
        if (tableView == deletedTableView) {
            serviceList = deleted_service_list
        } else {
            serviceList = current_service_list
        }
        
        let serviceDataModel = serviceList![indexPath.row] as! AIProposalServiceModel
        
        if let c = serviceDataModel.cell {
            #if !DEBUG
                //FIXME: 不好看
                //恢复区域不可删除
                c.canDelete = !(tableView == deletedTableView)
            #endif
            return c;
        }
        
        
        
        let cell = AIBueryDetailCell.currentView()
        
        let serviceView = SimpleServiceViewContainer.currentView()
        serviceView.tag = SIMPLE_SERVICE_VIEW_CONTAINER_TAG
        serviceView.settingState.tag = indexPath.row
        serviceView.settingButtonDelegate = self
        
        serviceView.loadData(serviceDataModel)
        cell.contentHoldView.addSubview(serviceView)
        cell.currentModel = serviceDataModel
        
        cell.removeDelegate = self
        #if !DEBUG
            //FIXME: 不好看
            //恢复区域不可删除
            cell.canDelete = !(tableView == deletedTableView)
        #endif
        
        // Add constrain
        constrain(serviceView, cell.contentHoldView) {(view, container) ->() in
            view.left == container.left + 6
            view.top == container.top
            view.bottom == container.bottom
            view.right == container.right  - 6
            container.height == serviceView.selfHeight()
        }
        
        cell.cellHeight = serviceView.selfHeight();
        // Cache Cell.
        serviceDataModel.cell = cell;
        return cell
        
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var serviceList: NSArray?
        
        if (tableView == deletedTableView) {
            serviceList = deleted_service_list
        } else {
            serviceList = current_service_list
        }
        
        let serviceDataModel = serviceList![indexPath.row] as! AIProposalServiceModel
        
        if let height = serviceDataModel.cell?.cellHeight {
            return height + CELL_VERTICAL_SPACE
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var serviceList: NSArray?
        
        if (tableView == deletedTableView) {
            serviceList = deleted_service_list

            #if !DEBUG
                let serviceDataModel = serviceList![indexPath.row] as! AIProposalServiceModel
                restoreService(serviceDataModel)
                return;
            #endif
            
        } else {
            serviceList = current_service_list
        }
        
        
        let serviceDataModel = serviceList![indexPath.row] as! AIProposalServiceModel

        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIPageBueryViewController) as! AIPageBueryViewController
        
        let model1 = AIProposalServiceModel()
        if serviceDataModel.service_id == 1 {
            model1.service_id = 2
        } else {
            model1.service_id = 1
        }
        
        model1.service_desc = "Service"
        

        let array = [serviceDataModel,model1]
        viewController.bubbleModelArray = array
        viewController.selectCurrentIndex = 0 // fix here
        self.showViewController(viewController, sender: self)
        
    }
}

// MARK: Extension.
extension AIBuyerDetailViewController: AIBueryDetailCellDetegate {
    func removeCellFromSuperView(cell: AIBueryDetailCell, model: AIProposalServiceModel?) {
        
        let view: SimpleServiceViewContainer = cell.contentView.viewWithTag(SIMPLE_SERVICE_VIEW_CONTAINER_TAG) as! SimpleServiceViewContainer

        let logo = view.logo
        // TODO: delete from server
        
        let index = current_service_list!.indexOfObject(model!)
        model?.is_deleted_flag = 1
        deleted_service_list.addObject(model!)
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        logoMoveToServiceRestoreToolBar(logo, completion: {() -> Void in
            self.serviceRestoreToolbar.reloadLogos();
            cell.closeCell()
            self.deletedTableView.reloadData()
        })
    }
    
}




// MARK: Extension.
extension AIBuyerDetailViewController: AISuperSwipeableCellDelegate {
    
    func cellDidAimationFrame(position: CGFloat, cell: UITableViewCell!) {
//        self.tableView.scrollEnabled = false
    }
    
    func cellDidClose(cell: UITableViewCell!) {
        
    }
    
    func cellDidOpen(cell: UITableViewCell!) {
//        self.tableView.scrollEnabled = false
    }
}

extension AIBuyerDetailViewController: SettingClickDelegate {
    func settingButtonClicked(settingButton: UIImageView, parentView: SimpleServiceViewContainer) {
        //let row = settingButton.tag
        parentView.isSetted = !parentView.isSetted
        
        if let s = parentView.dataModel {
            s.param_setting_flag = Int(parentView.isSetted)
            menuLightView?.showLightView(s)
        }
        
        
    }
}