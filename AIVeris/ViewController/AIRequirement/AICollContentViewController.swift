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

class AICollContentViewController: UIViewController {
    
    //models
    var assginServiceInsts : [AssignServiceInstModel]?
    var timelineModels : [AITimelineModel]!
    var cachedCells = Dictionary<Int,AITimelineCellBaseView>()
    
    //IB views
    var serviceInstView : AIAssignServiceView!
    var limitListView : AILimitListView!
    var timeLineTable : UITableView!
    var launchButton : UIButton!
    
    //size constants
    let LaunchButtonWidth : CGFloat = 180
    let LaunchButtonHeight : CGFloat = 32
    let buttonPadding : CGFloat = 10
    
    
    // MARK: - override方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        buildServiceInstView()
        buildLimitListView()
        initTable()
        buildLaunchView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var serviceInstViewFrame = view.bounds
        serviceInstViewFrame.size.height = 100
        serviceInstView.frame = serviceInstViewFrame
        serviceInstView.setLeft(-20)
        serviceInstView.setTop(-20)
        serviceInstView.setWidth(view.bounds.width + 40)
        
        var limitFrame = serviceInstView.frame
        limitFrame.origin.y = CGRectGetMaxY(serviceInstView.frame)
        limitFrame.size.height = 0
        limitListView.frame = limitFrame
        limitListView.loadData((assginServiceInsts?.first?.limits)!)
        
        
        let buttonFrame = CGRect(x: (view.bounds.width - LaunchButtonWidth) / 2, y: CGRectGetMaxY(limitListView.frame) + buttonPadding, width: LaunchButtonWidth, height: LaunchButtonHeight)
        launchButton.frame = buttonFrame
        
        var tableFrame = serviceInstView.frame
        tableFrame.origin.y = CGRectGetMaxY(buttonFrame) + buttonPadding
        tableFrame.size.height = view.bounds.height - CGRectGetMaxY(buttonFrame)
        timeLineTable.frame = tableFrame
    }
    
    // MARK: - 构造subView
    func buildLimitListView(){
        
        limitListView = AILimitListView(frame: CGRectZero)
        
        view.addSubview(limitListView)
    }
    
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
        if let assginServiceInsts = assginServiceInsts{
            serviceInstView.loadData(assginServiceInsts)
        }
    }
    
    func initTable(){
        timeLineTable = UITableView(frame: CGRectZero)
        view.addSubview(timeLineTable)
        timeLineTable.delegate = self
        timeLineTable.dataSource = self
        timeLineTable.separatorStyle = UITableViewCellSeparatorStyle.None
        let backgroundImageView = UIImageView(frame: timeLineTable.bounds)
        let backgroundImage = UIImage(named: "cell_background")
        backgroundImageView.image = backgroundImage
        timeLineTable.backgroundView = backgroundImageView
    }
    
    func buildLaunchView(){
        
        launchButton = UIButton()
        launchButton.setTitle("Launch", forState: UIControlState.Normal)
        launchButton.backgroundColor = UIColor(hex: "#146EE2")
        launchButton.layer.cornerRadius = 8
        launchButton.layer.masksToBounds = true
        view.addSubview(launchButton)
    }
    
    // MARK: - 加载数据
    func loadData(){
        let limits = [AILimitModel(limitId: 1, limitName: "Direct contact with consumbers", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: true),AILimitModel(limitId: 1, limitName: "Direct access with consumber address", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: false),AILimitModel(limitId: 1, limitName: "Initiate an authorization request directly to the customer", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: true),AILimitModel(limitId: 1, limitName: "Direct modification of service execution strategies", limitIcon: "http://171.221.254.231:3000/upload/shoppingcart/EFETwRsHI90Vi.png", hasLimit: true)]
        
        let model1 = AssignServiceInstModel(serviceInstId: 1, serviceName: "Pregnancy Grocery", ratingLevel: 4, limits: limits)
        let model2 = AssignServiceInstModel(serviceInstId: 2, serviceName: "Household Cleaner", ratingLevel: 5, limits: limits)
        let model3 = AssignServiceInstModel(serviceInstId: 3, serviceName: "Paramedic Freelancer", ratingLevel: 6, limits: limits)
        let model4 = AssignServiceInstModel(serviceInstId: 4, serviceName: "Hospital Appointment Booking", ratingLevel: 8, limits: limits)
        assginServiceInsts = [model1,model2,model3,model4]
        
        timelineModels = [AITimelineModel(timestamp: 1457403751, id: 1, title: "title1 wantsor", desc: "content1 needreply",status: 0),
            AITimelineModel(timestamp: 1457403751, id: 1, title: "title2 wantsor", desc: "content2 needreply",status: 0),
            AITimelineModel(timestamp: 1457403751, id: 1, title: "title3 wantsor", desc: "content3 needreply",status: 1),
            AITimelineModel(timestamp: 1457403751, id: 1, title: "title4 wantsor", desc: "content4 needreply",status: 0)]
    }

}

// MARK: - delegate
extension AICollContentViewController : AIAssignServiceViewDelegate{
    
    func limitButtonAction(view : AIAssignServiceView , limitsModel : [AILimitModel]){
        limitListView.refreshLimits(limitsModel)
        let frameHeight = limitListView.getFrameHeight()
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            var frame = self.limitListView.frame
            if(self.limitListView.frame.height == 0){
                frame.size.height = frameHeight
                
                self.limitListView.alpha = 1
                var tableFrame = self.timeLineTable.frame
                tableFrame.size.height -= frameHeight
                tableFrame.origin.y += frameHeight
                self.timeLineTable.frame = tableFrame
                self.launchButton.frame.origin.y += frameHeight
            }
            else{
                frame.size.height = 0
                self.limitListView.alpha = 0
                
                var tableFrame = self.timeLineTable.frame
                tableFrame.size.height += frameHeight
                tableFrame.origin.y -= frameHeight
                self.timeLineTable.frame = tableFrame
                
                self.launchButton.frame.origin.y -= frameHeight
            }
            self.limitListView.frame = frame
            }) { (finished) -> Void in
                //
        }
    }
    
    func serviceDidRotate(view : AIAssignServiceView , curServiceInst : AssignServiceInstModel){
        print(curServiceInst)
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
