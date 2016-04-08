//
//  AICollContentViewController.swift
//  AIVeris
//
//  Created by tinkl on 3/8/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//  需求分配
//

import Foundation
import UIKit
import Spring
import AIAlertView

class AICollContentViewController: UIViewController {
    
    //models
    var assginServiceInsts = [AssignServiceInstModel]()
    var allServiceInsts : Dictionary<Int,AssignServiceInstModel>?
    var timelineModels : [AITimelineModel]!
    var cachedCells = Dictionary<Int,AITimelineCellBaseView>()
    var filterModels : [AIPopupChooseModel]!
    var curAssignServiceInst : AssignServiceInstModel?
    
    //IB views
    var serviceInstView : AIAssignServiceView!
    var timeLineTable : UITableView!
    var launchButton : UIButton!
    var launchButtonBgView : UIView!
    var timeLineMaskView : UIView!
    
    //size constants
    let LaunchButtonWidth : CGFloat = AITools.displaySizeFrom1242DesignSize(738)
    let LaunchButtonHeight : CGFloat = AITools.displaySizeFrom1242DesignSize(103)
    let LaunchButtonBgWidth : CGFloat = AITools.displaySizeFrom1242DesignSize(761)
    let LaunchButtonBgHeight : CGFloat = AITools.displaySizeFrom1242DesignSize(127)
    let TitleLeftPadding : CGFloat = AITools.displaySizeFrom1242DesignSize(35)
    let buttonPadding : CGFloat = 10
    
    
    // MARK: - override方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        buildServiceInstView()
        initTable()
        buildTimelineMaskView()
        buildLaunchView()
        handleNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutViews()
    }
    
    // MARK: - 构造subView
    
    func buildServiceInstView(){
        serviceInstView = AIAssignServiceView.currentView()
        //layout
//        serviceInstView.snp_makeConstraints { (make) -> Void in
//            make.leading.equalTo(view).offset(-20)
//            make.trailing.equalTo(view).offset(20)
//            make.top.equalTo(0)
//            make.height.equalTo(80)
//        }
        
        serviceInstView.delegate = self
        view.addSubview(serviceInstView)
        serviceInstView.loadData(assginServiceInsts)
    }
    
    func initTable(){
        timeLineTable = UITableView(frame: CGRectZero)
        view.addSubview(timeLineTable)
        timeLineTable.delegate = self
        timeLineTable.dataSource = self
        timeLineTable.separatorStyle = UITableViewCellSeparatorStyle.None
        timeLineTable.backgroundColor = UIColor.clearColor()
    }
    
    func buildTimelineMaskView(){
        timeLineMaskView = UIView()
        timeLineMaskView.backgroundColor = UIColor(hex: "#1E2463")
        timeLineMaskView.alpha = 0.5
        view.addSubview(timeLineMaskView)
    }
    
    func buildLaunchView(){
        
        launchButtonBgView = UIView()
        launchButtonBgView.backgroundColor = UIColor(hexString: "#0f86e8")
        launchButtonBgView.alpha = 0.2
        launchButtonBgView.layer.cornerRadius = 5
        launchButtonBgView.layer.masksToBounds = true
        view.addSubview(launchButtonBgView)
         
        launchButton = UIButton()
        launchButton.setTitle("Launch", forState: UIControlState.Normal)
        launchButton.setBackgroundImage(UIColor(hex: "#0f86e8").imageWithColor(), forState: UIControlState.Normal)
        launchButton.layer.cornerRadius = 5
        launchButton.layer.masksToBounds = true
        //绑定点击事件
        launchButton.addTarget(self, action: "launchAction:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(launchButton)
    }
    
    func layoutViews(){
        var serviceInstViewFrame = view.bounds
        serviceInstViewFrame.size.height = 83
        serviceInstView.frame = serviceInstViewFrame
        serviceInstView.setLeft(-20)
        serviceInstView.setTop(-20)
        serviceInstView.setWidth(view.bounds.width + 40)
        
        
        let buttonBgViewFrame = CGRect(x: (view.bounds.width - LaunchButtonBgWidth) / 2, y: CGRectGetMaxY(serviceInstView.frame) + buttonPadding, width: LaunchButtonBgWidth, height: LaunchButtonBgHeight)
        launchButtonBgView.frame = buttonBgViewFrame
        let buttonFrame = CGRect(x: (view.bounds.width - LaunchButtonWidth) / 2, y: buttonBgViewFrame.origin.y + (LaunchButtonBgHeight - LaunchButtonHeight) / 2, width: LaunchButtonWidth, height: LaunchButtonHeight)
        launchButton.frame = buttonFrame
        
        var tableFrame = serviceInstView.frame
        tableFrame.origin.y = CGRectGetMaxY(buttonFrame) + buttonPadding
        tableFrame.size.height = view.bounds.height - CGRectGetMaxY(buttonFrame)
        timeLineTable.frame = tableFrame
        timeLineMaskView.frame = tableFrame
    }
    
    // MARK: - 事件处理
    private func handleNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifySwitchServiceInst:", name: AIApplication.Notification.AIRequirementSelectServiceInstNotificationName, object: nil)
        //弹出框的关闭通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closePopupWindow:", name: AIApplication.Notification.AIRequirementClosePopupNotificationName, object: nil)
    }
    
    func notifySwitchServiceInst(notify: NSNotification){
        let serviceInstIds = notify.object as! Array<Int>
        print(serviceInstIds)
        //先清空服务实例列表，再从通知过来的id中筛选
        assginServiceInsts.removeAll()
        for serviceInstId in serviceInstIds{
            if let serviceInst = allServiceInsts![serviceInstId]{
                assginServiceInsts.append(serviceInst)
            }
        }
        //如果没选择默认选中第一条
        if assginServiceInsts.count == 0{
            if let allServiceInsts = allServiceInsts{
                let keyArray = Array(allServiceInsts.keys)
                if keyArray.count > 0 {
                    assginServiceInsts.append(allServiceInsts[keyArray[0]]!)
                }
            }
            
        }
        serviceInstView.loadData(assginServiceInsts)
        let needLaunch = judgeNeedLaunch()
        changeLaunchButtonStatus(needLaunch)
        //确定是否需要遮罩
        timeLineMaskView.hidden = !needLaunch
    }
    //关闭弹出框时要继续动画
    func closePopupWindow(notify : NSNotification){
        serviceInstView.switchAnimationState(true)
    }
    
    private func changeLaunchButtonStatus(shouldDisplay : Bool){
        if shouldDisplay {
            if launchButton.alpha == 0{
                SpringAnimation.spring(0.25, animations: { () -> Void in
                    self.launchButtonBgView.frame.size.height = self.LaunchButtonBgHeight
                    self.launchButton.frame.size.height = self.LaunchButtonHeight
                    self.launchButtonBgView.alpha = 1
                    self.launchButton.alpha = 1
                    self.timeLineTable.frame.origin.y += self.LaunchButtonBgHeight
                })
            }
            
        }
        else{
            if launchButton.alpha == 1{
                SpringAnimation.spring(0.25, animations: { () -> Void in
                    self.launchButtonBgView.frame.size.height = 0
                    self.launchButton.frame.size.height = 0
                    self.launchButtonBgView.alpha = 0
                    self.launchButton.alpha = 0
                    self.timeLineTable.frame.origin.y -= self.LaunchButtonBgHeight
                })
            }
        }
    }
    
    private func judgeNeedLaunch() -> Bool{
        var needLaunch = false
        for assignServiceInst in assginServiceInsts {
            if assignServiceInst.serviceInstStatus == ServiceInstStatus.Init{
                needLaunch = true
                break
            }
        }
        return needLaunch
    }
    
    func launchAction(target : AnyObject){
        var submitServiceInstIds = [NSDictionary]()
        for assignServiceInst in assginServiceInsts{
            if assignServiceInst.serviceInstStatus == ServiceInstStatus.Init{
                let submitInfo = NSMutableDictionary()
                submitInfo.setObject(assignServiceInst.serviceInstId, forKey: "service_inst_id")
                submitInfo.setObject(assignServiceInst.providerUserId, forKey: "provider_user_id")
                submitServiceInstIds.append(submitInfo)
            }
        }
        AIRequirementHandler.defaultHandler().assginTask(submitServiceInstIds, success: { () -> Void in
            self.finishLaunchAction()
            }) { (errType, errDes) -> Void in
                print("assignTask faild, errorInfo: \(errDes)")
        }
    }
    
    //完成派单的操作1.取消时间线的遮罩，2.隐藏派单按钮，3.发更新网络请求数据的通知
    
    func finishLaunchAction(){
        AIAlertView().showInfo("AIBuyerDetailViewController.SubmitSuccess".localized, subTitle: "AIAudioMessageView.info".localized, closeButtonTitle:nil, duration: 2)
        timeLineMaskView.hidden = false
        changeLaunchButtonStatus(false)
        //发通知更新数据
        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIRequirementReloadDataNotificationName, object: nil, userInfo: nil)
    }
    
    // MARK: - 加载数据
    func loadData(){
        //权限列表
        if let bussinessModel = AIRequirementViewPublicValue.bussinessModel{
            if let assignServiceInstModels = bussinessModel.assignServiceInstModels{
                allServiceInsts = Dictionary<Int,AssignServiceInstModel>()
                for assignServiceInstModel in assignServiceInstModels{
                    allServiceInsts![assignServiceInstModel.serviceInstId] = assignServiceInstModel
                }
                assginServiceInsts = [assignServiceInstModels.first ?? AssignServiceInstModel()]
            }
            
        }
        
        
        //时间线model
        timelineModels = [AITimelineModel(timestamp: 1457403751, id: 1, title: "Launch language to Ms.Customer A", desc: "Ms.Customer A has an answer to the language requirements of the",status: 0),
            AITimelineModel(timestamp: 1457403751, id: 1, title: "Failed to launch the Ms.Customer A language", desc: "Ms.Customer A no response to the language requirements of the",status: 0),
            AITimelineModel(timestamp: 1457403751, id: 1, title: "A request from a nutrition to you.", desc: "Ms.Customer A out of contact,Please help me get in touch with him.",status: 1),
            AITimelineModel(timestamp: 1457403751, id: 1, title: "Paramedic Freelancer Requests Authorization", desc: "A customer's home",status: 0)]
        
        //过滤弹出框model
        filterModels = [AIPopupChooseModel(itemId: "1", itemTitle: "Delivery / arrival notification", itemIcon: "171.221.254.231:3000/upload/requirement/filter-notification-off.png", itemIconHighlight: "171.221.254.231:3000/upload/requirement/filter-notification-on.png", isSelect: false),
        AIPopupChooseModel(itemId: "1", itemTitle: "Map", itemIcon: "http://171.221.254.231:3000/upload/requirement/filter-map-off.png", itemIconHighlight: "http://171.221.254.231:3000/upload/requirement/filter-map-on.png",  isSelect: false),
        AIPopupChooseModel(itemId: "1", itemTitle: "Authorization information", itemIcon: "http://171.221.254.231:3000/upload/requirement/filter-auth-off.png", itemIconHighlight: "http://171.221.254.231:3000/upload/requirement/filter-auth-on.png",  isSelect: false),
        AIPopupChooseModel(itemId: "1", itemTitle: "Service orders", itemIcon: "http://171.221.254.231:3000/upload/requirement/filter-serviceoder-off.png",itemIconHighlight: "http://171.221.254.231:3000/upload/requirement/filter-serviceoder-on.png",  isSelect: false),
        AIPopupChooseModel(itemId: "1", itemTitle: "Order information", itemIcon: "http://171.221.254.231:3000/upload/requirement/filter-order-off.png", itemIconHighlight: "http://171.221.254.231:3000/upload/requirement/filter-order-on.png", isSelect: false),
        AIPopupChooseModel(itemId: "1", itemTitle: "Send message", itemIcon: "http://171.221.254.231:3000/upload/requirement/filter-sendmessage-off.png",itemIconHighlight: "http://171.221.254.231:3000/upload/requirement/filter-sendmessage-on.png",  isSelect: false),
        AIPopupChooseModel(itemId: "1", itemTitle: "Service remind", itemIcon: "http://171.221.254.231:3000/upload/requirement/filter-remaind-off.png",itemIconHighlight: "http://171.221.254.231:3000/upload/requirement/filter-remaind-on.png",  isSelect: false)]
    }

}

// MARK: - delegate
extension AICollContentViewController : AIAssignServiceViewDelegate , AIPopupChooseViewDelegate{
    
    func limitButtonAction(view : AIAssignServiceView , serviceInstModel : AssignServiceInstModel){
        //赋值一个当前操作的服务实例，用于后面的filter，设置权限等操作
        curAssignServiceInst = serviceInstModel
        let limitVC = AILimitListViewController()
        limitVC.loadData(serviceInstModel)
        //传递一个delegate过去
        limitVC.popupDelegate = self
        limitVC.view.frame = CGRect(x: 0, y: 0, width: view.width, height: 0)
        let height = limitVC.limitListView.getFrameHeight()
        limitVC.view.frame.size.height = height
        presentPopupViewController(limitVC, animated: true,onClickCancelArea : {
            () -> Void in
            //关闭弹窗时，继续轮播
            self.serviceInstView.switchAnimationState(true)
        })
    }
    
    func filterButtonAction(view : AIAssignServiceView , serviceInstModel : AssignServiceInstModel){
        //赋值一个当前操作的服务实例，用于后面的filter，设置权限等操作
        curAssignServiceInst = serviceInstModel
        let vc = AITimelineFilterViewController()
        vc.popupChooseDelegate = self
        vc.loadData(filterModels)
        vc.view.frame = CGRect(x: 0, y: 0, width: view.width, height: 0)
        let height = vc.popupChooseView.getFrameHeight()
        vc.view.frame.size.height = height
        presentPopupViewController(vc, animated: true,onClickCancelArea : {
            () -> Void in
            //关闭弹窗时，继续轮播
            self.serviceInstView.switchAnimationState(true)
        })
    }
    func contactButtonAction(view : AIAssignServiceView , serviceInstModel : AssignServiceInstModel){
        //赋值一个当前操作的服务实例，用于后面的filter，设置权限等操作
        curAssignServiceInst = serviceInstModel
    }
    
    func serviceDidRotate(view : AIAssignServiceView , curServiceInst : AssignServiceInstModel){
        //print(curServiceInst)
    }
    
    func didConfirm(view : AIPopupChooseBaseView , itemModels : [AIPopupChooseModel]){
        self.dismissPopupViewController(true, completion: nil)
        
        //权限设置的保存在这里处理
        if view.businessType == PopupBusinessType.LimitConfig{
            submitPermissionConfig(itemModels)
        }
        print(AIBaseViewModel.printArrayModelContent(itemModels))
    }
    
    func didCancel(view : AIPopupChooseBaseView){
        self.dismissPopupViewController(true, completion: nil)
    }
    
    // MARK: - business logic
    // TODO 这里有逻辑问题，关闭弹出window后就开始继续滚动，那这里取当前number就有问题的，应该弹出时就把需要的参数赋值在vc中
    func submitPermissionConfig(itemModels : [AIPopupChooseModel]){
        if let bussinessModel = AIRequirementViewPublicValue.bussinessModel{
            let customerId = bussinessModel.baseJsonValue?.customer.customer_id
            let providerId = curAssignServiceInst!.providerUserId
            let serviceInstId = curAssignServiceInst!.serviceInstId
            var permissions = [NSNumber]()
            for itemModel in itemModels {
                if itemModel.isSelect{
                    if let permissionId = NSNumberFormatter().numberFromString(itemModel.itemId){
                        permissions.append(permissionId)
                    }
                    
                }
            }
            AIRequirementHandler.defaultHandler().setServiceProviderRights(NSNumber(integer: providerId), customID: customerId!,serviceInstId: NSNumber(integer: serviceInstId), rightsList: permissions, success: { () -> Void in
                    print(" save permissions success! ")
                //发通知更新数据
                NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIRequirementReloadDataNotificationName, object: nil, userInfo: nil)
                }, fail: { (errType, errDes) -> Void in
                    print("\(errDes)")
            })
        }
    }
}

extension AICollContentViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellView = getCellWithIndexPath(indexPath)
        return cellView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellView = getCellWithIndexPath(indexPath)
        return cellView.getContentHeight()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timelineModels.count
    }
    
    func getCellWithIndexPath(indexPath : NSIndexPath) -> AITimelineCellBaseView{
        if (cachedCells[indexPath.row] != nil) {
            return cachedCells[indexPath.row]!
        }
        else{
            let model = timelineModels[indexPath.row]
            let cellFrame = CGRect(x: 0, y: 0, width: timeLineTable.frame.width, height: 0)
            let cellView = AITimelineCellBaseView(frame: cellFrame)
            //如果是最后一个model，传入一个标志，view就不加下面的竖线
            var isLastModel = false
            if(indexPath.row == timelineModels.count - 1){
                isLastModel = true
            }
            cellView.setContent(model,isLast: isLastModel)
            cachedCells[indexPath.row] = cellView
            return cellView
        }
    }
}
