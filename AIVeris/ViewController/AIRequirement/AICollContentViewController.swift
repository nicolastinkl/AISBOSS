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

class AICollContentViewController: UIViewController {
    
    //models
    var assginServiceInsts = [AssignServiceInstModel]()
    var allServiceInsts : Dictionary<Int,AssignServiceInstModel>?
    var timelineModels : [AITimelineModel]!
    var cachedCells = Dictionary<Int,AITimelineCellBaseView>()
    var filterModels : [AIPopupChooseModel]!
    
    //IB views
    var serviceInstView : AIAssignServiceView!
    var timeLineTable : UITableView!
    var launchButton : UIButton!
    var launchButtonBgView : UIView!
    
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
    }
    
    //处理点击事件
    private func handleNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifySwitchServiceInst:", name: AIApplication.Notification.AIRequirementSelectServiceInstNotificationName, object: nil)
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
        if assginServiceInsts.count == 0{
            assginServiceInsts.append(allServiceInsts![0]!)
        }
        serviceInstView.loadData(assginServiceInsts)
        changeLaunchButtonStatus()
    }
    
    private func changeLaunchButtonStatus(){
        var needLaunch = false
        for assignServiceInst in assginServiceInsts {
            if assignServiceInst.serviceInstStatus == ServiceInstStatus.Init{
                needLaunch = true
                break
            }
        }
        //TODO 逻辑还有问题
        if launchButton.alpha == 1 && needLaunch{
            
        }
        if needLaunch {
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
    
    // MARK: - 加载数据
    func loadData(){
        //权限列表
        let limits1 = [AILimitModel(limitId: 1, limitName: "Direct contact with consumbers", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: false),AILimitModel(limitId: 1, limitName: "Direct access with consumber address", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: false),AILimitModel(limitId: 1, limitName: "Initiate an authorization request directly to the customer", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: false),AILimitModel(limitId: 1, limitName: "Direct modification of service execution strategies", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: false)]
        let limits2 = [AILimitModel(limitId: 1, limitName: "Direct contact with consumbers", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: true),AILimitModel(limitId: 1, limitName: "Direct access with consumber address", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: false),AILimitModel(limitId: 1, limitName: "Initiate an authorization request directly to the customer", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: true),AILimitModel(limitId: 1, limitName: "Direct modification of service execution strategies", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: true)]
        let limits3 = [AILimitModel(limitId: 1, limitName: "Direct contact with consumbers", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: true),AILimitModel(limitId: 1, limitName: "Direct access with consumber address", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: false),AILimitModel(limitId: 1, limitName: "Initiate an authorization request directly to the customer", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: true),AILimitModel(limitId: 1, limitName: "Direct modification of service execution strategies", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: false)]
        let limits4 = [AILimitModel(limitId: 1, limitName: "Direct contact with consumbers", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: true),AILimitModel(limitId: 1, limitName: "Direct access with consumber address", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: true),AILimitModel(limitId: 1, limitName: "Initiate an authorization request directly to the customer", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: true),AILimitModel(limitId: 1, limitName: "Direct modification of service execution strategies", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: true)]
        //服务实例
        let model1 = AssignServiceInstModel(serviceInstId: 1, serviceName: "Pregnancy Grocery", ratingLevel: 4, serviceInstStatus: .Init, limits: limits1)
        let model2 = AssignServiceInstModel(serviceInstId: 2, serviceName: "Household Cleaner", ratingLevel: 5, serviceInstStatus: .Assigned,limits: limits2)
        let model3 = AssignServiceInstModel(serviceInstId: 3, serviceName: "Paramedic Freelancer", ratingLevel: 6, serviceInstStatus: .Assigned,limits: limits3)
        let model4 = AssignServiceInstModel(serviceInstId: 4, serviceName: "Hospital Appointment Booking", ratingLevel: 8, serviceInstStatus: .Init,limits: limits4)
        assginServiceInsts = [model1]
        
        allServiceInsts = [0:model1,1:model1,2:model2,3:model3,4:model4,5:model1,6:model2,7:model3]
        
        //时间线model
        timelineModels = [AITimelineModel(timestamp: 1457403751, id: 1, title: "Launch language to Ms.Customer A", desc: "Ms.Customer A has an answer to the language requirements of the",status: 0),
            AITimelineModel(timestamp: 1457403751, id: 1, title: "Failed to launch the Ms.Customer A language", desc: "Ms.Customer A no response to the language requirements of the",status: 0),
            AITimelineModel(timestamp: 1457403751, id: 1, title: "A request from a nutrition to you.", desc: "Ms.Customer A out of contact,Please help me get in touch with him.",status: 1),
            AITimelineModel(timestamp: 1457403751, id: 1, title: "Paramedic Freelancer Requests Authorization", desc: "A customer's home",status: 0)]
        
        //过滤弹出框model
        filterModels = [AIPopupChooseModel(itemId: 1, itemTitle: "Delivery / arrival notification", itemIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", isSelect: false),
        AIPopupChooseModel(itemId: 1, itemTitle: "Map", itemIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", isSelect: false),
        AIPopupChooseModel(itemId: 1, itemTitle: "Authorization information", itemIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", isSelect: false),
        AIPopupChooseModel(itemId: 1, itemTitle: "Service orders", itemIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", isSelect: false),
        AIPopupChooseModel(itemId: 1, itemTitle: "Order information", itemIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", isSelect: false),
        AIPopupChooseModel(itemId: 1, itemTitle: "Send message", itemIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", isSelect: false),
        AIPopupChooseModel(itemId: 1, itemTitle: "Service remind", itemIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", isSelect: false)]
    }

}

// MARK: - delegate
extension AICollContentViewController : AIAssignServiceViewDelegate{
    
    func limitButtonAction(view : AIAssignServiceView , limitsModel : [AILimitModel]){
        let limitVC = AILimitListViewController()
        limitVC.loadData(limitsModel)
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
        
        let vc = AITimelineFilterViewController()
        vc.loadData(filterModels)
        vc.view.frame = CGRect(x: 0, y: 0, width: view.width, height: 0)
        let height = vc.popupChooseView.getFrameHeight()
        vc.view.frame.size.height = height
        presentPopupViewController(vc, animated: true)
    }
    func contactButtonAction(view : AIAssignServiceView , serviceInstModel : AssignServiceInstModel){
        
    }
    
    func serviceDidRotate(view : AIAssignServiceView , curServiceInst : AssignServiceInstModel){
        //print(curServiceInst)
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
