//
// UIBuyerDetailViewController.swift
// AIVeris
//
// Created by tinkl on 3/11/2015.
// Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

import UIKit
import Spring
import Cartography
import AIAlertView
import SnapKit

protocol AIBuyerDetailDelegate: class {
    func closeAIBDetailViewController()
}

enum ServiceDeletedStatus: Int {
    case Deleted
    case NotDeleted
}

class AIBuyerDetailViewController : UIViewController {
    
    private let SIMPLE_SERVICE_VIEW_CONTAINER_TAG: Int = 233
    private let CELL_VERTICAL_SPACE: CGFloat = 12 // preous 10.

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
    
    private var selectCount: Int = 0
    private var openCell: Bool = false
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var buyerBottom: UIImageView! // 带购物车的一块
   
    var overlayView: UIView!
    
    private var menuLightView: UIBezierPageView?
    
    private var serviceRestoreToolbar: ServiceRestoreToolBar!
    
    var curretCell:AIBueryDetailCell?
    
    private var current_service_list: NSArray? {
        get {
            guard dataSource?.service_list == nil else {
                let result = dataSource?.service_list.filter (){
                    return ($0 as! AIProposalServiceModel).service_del_flag == ServiceDeletedStatus.NotDeleted.rawValue
                }
                return result
            }
            return nil
        }
    }

    
    private var deleted_service_list: NSMutableArray = NSMutableArray()
    
    private var deleted_service_list_copy: NSMutableArray {
        //不优
        return deleted_service_list.mutableCopy() as! NSMutableArray
    }
    
    // MARK: life cycle
    func initTableView(){
        
        self.tableView.registerClass(AIBueryDetailCell.self, forCellReuseIdentifier: "cell")
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50.0, 0)

        /* Here's a test for me to use autoLayout in tableView interface the autoheight.
        self.tableView.estimatedRowHeight = 150.0
        self.tableView.rowHeight = UITableViewAutomaticDimension*/
        
        contentView = tableView.tableHeaderView?.viewWithTag(1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting's default tableView settings.
        initTableView()
        
        // Setting's Restore tool bar.
        initServiceRestoreToolbar()
        
        // Set delete TabelView.
        initDeletedTableView()
        
        // Set's Deleted overly View.
        initDeletedOverlayView()
        
        // init Label Font
        initLabelFont()
        
        // Add Pull To Referesh..
        tableView.addHeaderWithCallback {[weak self]() -> Void in
            if let strongSelf = self {
                // init Data
                strongSelf.initData()
            }
        }
        
        // Default request frist networking from asiainfo server.
        self.tableView.headerBeginRefreshing()
       
        
    }
    
    func initProderView(){
        
        let providerView =  AIProviderView.currentView()
        let custView =  AICustomView.currentView()
        
        let views = UIView()
        
        views.addSubview(providerView)
        views.addSubview(custView)
        views.setHeight(custView.height)

        custView.setWidth(views.width)
        custView.setTop(providerView.height)
        
        providerView.setWidth(views.width)
        
        providerView.setHeight(providerView.height)
        custView.setHeight(custView.height)
        
        custView.backgroundColor = UIColor.clearColor()
        providerView.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = views
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
        
        let tap = UITapGestureRecognizer(target: self, action: "deletedOverlayTapped:")
        overlayView.addGestureRecognizer(tap)
    }
    
    //曲线和overlay 共用tapgesture
    @IBAction func deletedOverlayTapped(g: UITapGestureRecognizer) {
        if isDeletedTableViewOpen {
            closeDeletedTableView(true)
        }
    }
    
    func initServiceRestoreToolbar() {
        serviceRestoreToolbar = ServiceRestoreToolBar()
        serviceRestoreToolbar.delegate = self
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
    }
    
    func makeBuyButton() {
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 100, CGRectGetWidth(self.view.frame), 100)
        button.addTarget(self, action: "showNextViewController", forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
    }
    
    func initBottomView() {
        if menuLightView != nil {
            menuLightView?.removeFromSuperview()
        }
        let bzView = UIBezierPageView(frame: CGRectMake(0, -19, 200, 50))
        bzView.setX((self.view.width - bzView.width) / 2)
        if let list = dataSource.service_list as? [AIProposalServiceModel] {
            bzView.refershModelView(list)
        }
        buyerBottom.addSubview(bzView)
        menuLightView = bzView
        
        //
        addTapActionForView(buyerBottom)
    }
    
    /**
     Video Button Click         
     */
    @IBAction func startVideoAction(sender: AnyObject) {
        
        // Create our Installation query
        let pushQuery = AVInstallation.query()
        pushQuery.whereKey("channels", equalTo: AIApplication.DirectionalPush.ProviderChannel)
        
        // Send push notification to query
        let push = AVPush()
        //push.setChannel(AIApplication.DirectionalPush.ProviderChannel)
        push.setQuery(pushQuery) // Set our Installation query
        push.setMessage("There is a new oder !")
        push.sendPushInBackground()
  
    }
    // MARK: 提交订单
    func addTapActionForView(view:UIView) {
        let width :CGFloat = 100
        let frame : CGRect = CGRectMake((CGRectGetWidth(view.frame)-width) / 2, 0, width, CGRectGetHeight(view.frame))
        
        let tapView = UIView(frame: frame)
        tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "bottomTapAction"))
        view.addSubview(tapView)
        
        view.userInteractionEnabled = true
    }
    
    func bottomTapAction () {
        if let anyServiceNotSelected = current_service_list?.contains({ (obj) -> Bool in
            return obj.param_setting_flag == 0 ? true : false
        }) {
            //有任何一个或几个服务 未选中
            if anyServiceNotSelected {
                AIAlertView().showInfo("AIBuyerDetailViewController.selectService".localized, subTitle: "AIAudioMessageView.info".localized, closeButtonTitle:nil, duration: 2)
                return
            }
        }
        
        view.showLoading()
        AIOrderRequester().submitProposalOrder(dataSource.proposal_id,serviceList:current_service_list as! [AnyObject] , success: { () -> Void in
            AIAlertView().showInfo("AIBuyerDetailViewController.SubmitSuccess".localized, subTitle: "AIAudioMessageView.info".localized, closeButtonTitle:nil, duration: 2)
            self.view.hideLoading()
            self.dismissViewControllerAnimated(true, completion: nil)
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.UIAIASINFORecoverOrdersNotification, object: nil)
            }) { (errType, errDes) -> Void in
                self.view.hideLoading()
        }
    }
    
    func showNextViewController() {
        let vc = AIServiceContentViewController()
        vc.serviceContentType = AIServiceContentType.MusicTherapy
        self.showViewController(vc, sender: self)
        
    }
    
    func initController() {
        
        let name = bubbleModel?.proposal_name ?? ""
        self.backButton.setTitle(name, forState: UIControlState.Normal)
        self.moneyLabel.text = dataSource?.order_total_price
        
        self.numberLabel.text = "\(dataSource?.order_times ?? 0)"
        self.whereLabel.text = dataSource?.proposal_origin
        self.contentLabel.text = dataSource?.proposal_desc
        self.OrderFromLabel.text = "AIBuyerDetailViewController.from".localized
        
//        "AIBuyerDetailViewController.pregnancy" = "怀孕"; 可能引起bug
        if NSString(string: name).containsString("AIBuyerDetailViewController.pregnancy".localized) {
            // 处理字体
            let price = dataSource?.proposal_price ?? ""
            let richText = NSMutableAttributedString(string:(price))
            richText.addAttribute(NSFontAttributeName, value: AITools.myriadLightSemiCondensedWithSize(45 / PurchasedViewDimention.CONVERT_FACTOR) , range: NSMakeRange(price.length - 6, 6)) // 设置字体大小
            self.totalMoneyLabel.attributedText = richText
            
        } else {
            self.totalMoneyLabel.text = dataSource?.proposal_price
        }
        
        self.totalMoneyLabel.textColor = AITools.colorWithR(253, g: 225, b: 50)
    }
    
    func initLabelFont() {
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
        let toolbarFrameOnWindow = serviceRestoreToolbar.convertRect(serviceRestoreToolbar.bounds, toView: window)
        //FIXME: Variable 'toFrameX' was written to, but never read
        var toFrameX: CGFloat = 0
        
        if index < 3 {
            toFrameX = serviceRestoreToolbar.LOGO_SPACE + (serviceRestoreToolbar.LOGO_WIDTH + serviceRestoreToolbar.LOGO_SPACE) * CGFloat(index)
        } else {
            toFrameX = CGRectGetWidth(toolbarFrameOnWindow) - (serviceRestoreToolbar.LOGO_SPACE + (serviceRestoreToolbar.LOGO_WIDTH + serviceRestoreToolbar.LOGO_SPACE) * CGFloat(5 - index)) - serviceRestoreToolbar.LOGO_WIDTH
        }
        
        let toFrameOnWindow = CGRectMake(CGRectGetMinX(toolbarFrameOnWindow) + toFrameX, CGRectGetMinY(toolbarFrameOnWindow) +  (CGRectGetHeight(toolbarFrameOnWindow) - serviceRestoreToolbar.LOGO_WIDTH) / 2, serviceRestoreToolbar.LOGO_WIDTH, serviceRestoreToolbar.LOGO_WIDTH)
        
        let fakeLogo = UIImageView(image: logo.image)
        fakeLogo.frame = fromFrameOnWindow
        
        window?.addSubview(fakeLogo)
        let duration = 0.75
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        UIView.animateWithDuration(duration, animations: {() -> Void in
            fakeLogo.frame = toFrameOnWindow
            }) {(success) -> Void in
                if let c = completion {
                    c();
                    // 0.01 to fix logo blink issue
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((0.01) * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                        fakeLogo.removeFromSuperview()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    })
                    
                }
        }
    }
    
    @IBAction func closeThisViewController() {
        delegate?.closeAIBDetailViewController()
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func remoteAssistantButtonPressed(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Share Screen", message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Do Publish", style: .Default, handler: { (action) in
            AudioAssistantManager.sharedInstance.doPublish()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Connection To AudioAssiastant Room", style: .Default, handler: { (action) in
            AudioAssistantManager.sharedInstance.connectionToAudioAssiastantRoom()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
        }))
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func refershData() {
        
    }
    
    func openDeletedTableView(animated:Bool) {
        deletedTableViewOpen(true, animated: true)
    }
    
    func closeDeletedTableView(animated:Bool) {
        deletedTableViewOpen(false, animated: true)
    }
    
    func deletedTableViewOpen(isOpen:Bool, animated:Bool) {
       
        let window = UIApplication.sharedApplication().keyWindow
        let contentLabelHeight = contentLabel.height
        let navigationBarMaxY = CGRectGetMaxY(navigationView.frame)
        let maxHeight = (window?.height)! - navigationBarMaxY - contentLabelHeight - buyerBottom.height - 10 // 10 is magic number hehe
        let constant = isOpen ? min(maxHeight, deletedTableView.contentSize.height) : 0
        let duration = animated ? 0.25 : 0
        let restoreToolBarAlpha: CGFloat = isOpen ? 0 : 1;
        isDeletedTableViewAnimating = true
        stretchedConstraint.constant = constant
        if !isOpen {
            serviceRestoreToolbar.hidden = false
        }
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.serviceRestoreToolbar.alpha = restoreToolBarAlpha
            }) { (completion) -> Void in
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                self.serviceRestoreToolbar.hidden = isOpen
                self.overlayView.hidden = !isOpen
                self.isDeletedTableViewAnimating = false
                self.isDeletedTableViewOpen = isOpen
        }
    }

    func restoreService(model:AIProposalServiceModel) {
        let indexInDeletedTableView = deleted_service_list.indexOfObject(model)
        model.service_del_flag = ServiceDeletedStatus.NotDeleted.rawValue
        deleted_service_list.removeObject(model)
        let afterArray = current_service_list
        let index = (afterArray as! [AIProposalServiceModel]).indexOf(model)
        
        serviceRestoreToolbar.removeLogoAt(indexInDeletedTableView)
        
        //处理小设置按钮添加移除状态
        if let list = current_service_list as? [AIProposalServiceModel] {
            self.menuLightView?.refershDeleteMedelView(list)
        }
        
        if isDeletedTableViewOpen {
            deletedTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexInDeletedTableView, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            //0.3s 以下的时间都会引起 下面删除了cell 上面不显示cell的问题，，因为使用了cell的缓存机制
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                if self.deleted_service_list.count == 0 {
                    self.closeDeletedTableView(true)
                }else {
                    self.deletedTableViewOpen(self.isDeletedTableViewOpen, animated: true)
                }
            })
        } else {
            deletedTableView.reloadData()
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: index!, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
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
                        // 清空已删除
                        viewController.deleted_service_list.removeAllObjects()
                        viewController.serviceRestoreToolbar.serviceModels = viewController.deleted_service_list
                        viewController.serviceRestoreToolbar.removeAllLogos()
                        viewController.dataSource = responseData
                        
                        // initControl Data
                        //viewController.initProderView()
                        viewController.initController()
                        viewController.tableView.reloadData()
                        
                        // init Bottom Page white area
                        viewController.initBottomView()
                        
                        viewController.tableView.headerEndRefreshing()
                        
                        /**
                        *  @author tinkl, 16-01-22 10:01:25
                        *
                        *  Display View some Icons.
                        *
                        *  @return none
                        */
                        _ = viewController.navigationView.subviews.filter({(view:AnyObject)->Bool in
                            let someView = view as! UIView
                            if someView.tag == 10 {
                                someView.hidden = false
                            }
                            return true
                        })
                        
                        
                        if let cView = viewController.contentView {
                            _ = cView.subviews.filter({ (svsiew:AnyObject) -> Bool in
                                let someView = svsiew as! UIView
                                if someView.tag == 10 {
                                    someView.hidden = false
                                }
                                return true
                            })
                        }
                        
                    }
                    
                }, fail : {[weak self]
                    (errType, errDes) -> Void in
                    if let viewController = self {
                        
                        viewController.tableView.headerEndRefreshing()
                        // 处理错误警告
                    }
                })
        }
        
    }
    
}

extension AIBuyerDetailViewController: ServiceRestoreToolBarDelegate {
    
    // MARK: - ServiceRestoreToolBarDelegate
    func serviceRestoreToolBar(serviceRestoreToolBar: ServiceRestoreToolBar, didClickLogoAtIndex index: Int) {
        
        if index < 5 {
            let model = self.deleted_service_list[index] as! AIProposalServiceModel
            
            let cell = model.cell
            
            let view: SimpleServiceViewContainer = cell?.contentView.viewWithTag(SIMPLE_SERVICE_VIEW_CONTAINER_TAG) as! SimpleServiceViewContainer
            
            let logo = view.logo
            
            let name = model.service_desc

            let logoWidth = AITools.displaySizeFrom1080DesignSize(94)
            let text = String(format: "AIBuyerDetailViewController.alert".localized, name)
            JSSAlertView().comfirm(self, title: name, text: text, customIcon: logo.image, customIconSize: CGSizeMake(logoWidth, logoWidth), onComfirm: { () -> Void in
            self.restoreService(model)
            })
            
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
        
        if serviceList == nil {
            return 0
        } else {
            return serviceList!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var serviceList: NSArray?
        
        if (tableView == deletedTableView) {
            serviceList = deleted_service_list_copy
        } else {
            serviceList = current_service_list
        }
        
        let serviceDataModel = serviceList![indexPath.row] as! AIProposalServiceModel

        if let c = serviceDataModel.cell {
            //恢复区域不可删除
            let view: SimpleServiceViewContainer = c.contentView.viewWithTag(SIMPLE_SERVICE_VIEW_CONTAINER_TAG) as! SimpleServiceViewContainer
            view.displayDeleteMode = (tableView == deletedTableView)
            c.canDelete = !(tableView == deletedTableView)
            return c
        }
        
        // Init AIBueryDetailCell and SimpleServiceViewContainer.currentView..
        
        let cell = AIBueryDetailCell.currentView()

        let serviceView = SimpleServiceViewContainer.currentView()
        serviceView.tag = SIMPLE_SERVICE_VIEW_CONTAINER_TAG
        serviceView.settingState.tag = indexPath.row
        serviceView.settingButtonDelegate = self
        
        cell.contentHoldView.addSubview(serviceView)
        serviceView.loadData(serviceDataModel)
        cell.currentModel = serviceDataModel
        
        cell.removeDelegate = self
        cell.delegate = self

        serviceView.displayDeleteMode = (tableView == deletedTableView)

        cell.canDelete = !(tableView == deletedTableView)

        // Add constrain
        constrain(serviceView, cell.contentHoldView) {(view, container) ->() in
            view.left == container.left + 6
            view.top == container.top
            view.bottom == container.bottom
            view.right == container.right  - 6
        }

        cell.cellHeight = serviceView.selfHeight() + CELL_VERTICAL_SPACE
        
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
             
            if  (serviceDataModel.wish_list == nil) {
                if (serviceDataModel.service_param == nil){
                    return height + 50
                }
            }
            return height + CELL_VERTICAL_SPACE
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        if (self.openCell == false) || (self.openCell == true  && selectCount == 1){
            selectCount = 0
            var serviceList: NSArray?
            
            if (tableView == deletedTableView) {
                //需求说已删除的服务 不支持点击事件
                return
                //            serviceList = deleted_service_list
            } else {
                serviceList = current_service_list
            }
             
            
            let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIPageBueryViewController) as! AIPageBueryViewController
            viewController.delegate = self
            viewController.proposalId = dataSource.proposal_id
            viewController.bubbleModelArray = serviceList as? [AIProposalServiceModel]
            viewController.selectCurrentIndex = indexPath.row
            self.showViewController(viewController, sender: self)
            
            
  
        }
        
        selectCount  = selectCount + 1
    }
}

// MARK: Extension.
extension AIBuyerDetailViewController: AIBueryDetailCellDetegate {
    func removeCellFromSuperView(cell: AIBueryDetailCell, model: AIProposalServiceModel?) {
        
        let view: SimpleServiceViewContainer = cell.contentView.viewWithTag(SIMPLE_SERVICE_VIEW_CONTAINER_TAG) as! SimpleServiceViewContainer

        let logo = view.logo
        // TODO: delete from server
//        BDKProposalService().delServiceCategory((model?.service_id)!, proposalId: (self.bubbleModel?.proposal_id)!, success: { () -> Void in
//            print("success")
//            }) { (errType, errDes) -> Void in
//                print("failed")
//        }
        
        let index = current_service_list!.indexOfObject(model!)
        model?.service_del_flag = ServiceDeletedStatus.Deleted.rawValue
        
        deleted_service_list.addObject(model!)
        
        logoMoveToServiceRestoreToolBar(logo, completion: {() -> Void in
            self.serviceRestoreToolbar.serviceModels = self.deleted_service_list
            self.serviceRestoreToolbar.appendLogoAtLast();
            cell.closeCell()
            self.deletedTableView.reloadData()
            cell.currentModel = model
        })
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        
        //处理小设置按钮添加移除状态
        if let list = current_service_list as? [AIProposalServiceModel] {
           self.menuLightView?.refershDeleteMedelView(list)
        }
    }    
}

// MARK: Extension.
extension AIBuyerDetailViewController: AISuperSwipeableCellDelegate {
    
    func cellDidAimationFrame(position: CGFloat, cell: UITableViewCell!) {
//        self.tableView.scrollEnabled = false
    }
    
    func cellWillOpen(cell: UITableViewCell!) {
        if let cell = curretCell {
            cell.closeCell()
            curretCell = nil
        }
    }
    func cellDidClose(cell: UITableViewCell!) {
        self.openCell = false
    }
    
    func cellDidOpen(cell: UITableViewCell!) {
        //设置背景颜色
        self.openCell = true
        curretCell = cell as? AIBueryDetailCell
//        self.tableView.userInteractionEnabled = false
    }
}

extension AIBuyerDetailViewController: SettingClickDelegate {
    func settingButtonClicked(settingButton: UIImageView, parentView: SimpleServiceViewContainer) {
        //let row = settingButton.tag
        parentView.isSetted = !parentView.isSetted
        
        if let model = parentView.dataModel {
            let userId = NSUserDefaults.standardUserDefaults().objectForKey("Default_UserID") as? String
            
            let userIdInt = Int(userId!)!
            BDKProposalService().updateParamSettingState(customerId: userIdInt, serviceId: model.service_id, proposalId: (self.bubbleModel?.proposal_id)!, roleId: model.role_id, flag: parentView.isSetted, success: { () -> Void in
                print("success")
                }) { (errType, errDes) -> Void in
                    print(errDes)
            }
            model.param_setting_flag = Int(parentView.isSetted)
            menuLightView?.showLightView(model)
        }
    }
    
    func simpleServiceViewContainerCancelButtonDidClick(simpleServiceViewContainer: SimpleServiceViewContainer) {
        restoreService(simpleServiceViewContainer.dataModel!)
    }
}

extension AIBuyerDetailViewController: UIScrollViewDelegate{
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let cell = curretCell {
            cell.closeCell()
            curretCell = nil
//            self.tableView.userInteractionEnabled = true
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if let cell = curretCell {
            cell.closeCell()
            curretCell = nil
        }
    }
    
}


extension AIBuyerDetailViewController : AIProposalDelegate {
    func proposalContenDidChanged () {
        self.tableView.headerBeginRefreshing()
    }
}

