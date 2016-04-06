//
//  AIRequirementMenuViewController.swift
//  AIVeris
//
//  Created by tinkl on 3/8/16.
//  Base on Tof Templates
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

// MARK: -
// MARK: AIRequirementMenuViewController
// MARK: -
internal class AIRequirementMenuViewController : UIViewController  {
    
    // MARK: -> Internal structs
    
    // MARK: -> Internal class
    
    // MARK: -> Internal type alias
    
    // MARK: -> Internal static properties
    
    var bussinessModel: AIBusinessInfoModel?
    
    @IBOutlet weak var labelRequire: UILabel!
    
    @IBOutlet weak var assignLabel: UILabel!
    
    @IBOutlet weak var collLabel: UILabel!
    
    // MARK: -> Internal properties
    
    @IBOutlet weak var requireButton: UIButton!
    @IBOutlet weak var collaborationButton: UIButton!
    @IBOutlet weak var assignButton: UIButton!
    
    var serviceInstsView : AIVerticalScrollView!

    var models : [IconServiceIntModel]?
    
    let badge = GIBadgeView()
    
    let scrollViewBottomPadding = AITools.displaySizeFrom1242DesignSize(165)
    
    // MARK: -> Internal init methods
    
    override func viewDidLoad() {

        super.viewDidLoad() // .if this will error.
        
        // TODO: Init Veris Lable's Font and Size.
        
        func initFont(label : UILabel){
            label.font = AITools.myriadLightSemiCondensedWithSize(9)
            label.textColor = UIColor(hexString: "ffffff", alpha: 0.7)
        }
        
        initFont(labelRequire)
        initFont(collLabel)
        initFont(assignLabel)
        
        // Set Un Read's view
        // Create your badge and add it as a subview to whatever view you want to badgify.
        
        //loadData()
        
        assignButton.addSubview(badge)
        //collaborationButton.addSubview(badge)
        badge.badgeValue = 0
        badge.topOffset = 5
        badge.rightOffset = 12
        badge.font = AITools.myriadLightSemiExtendedWithSize(12)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifyOperateCell:", name: AIApplication.Notification.AIAIRequirementNotifyOperateCellNotificationName, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifyClearNumber", name: AIApplication.Notification.AIAIRequirementNotifyClearNumberCellNotificationName, object: nil)
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notifyGenerateModel:", name: AIApplication.Notification.AIAIRequirementNotifynotifyGenerateModelNotificationName, object: nil)
        
        
    }
    
    func  notifyGenerateModel(notify: NSNotification){
        
        if let dic = notify.userInfo {
            if let cellModel = dic.values.first {
                let wrapper = cellModel as? AIWrapper<AIBusinessInfoModel>
                bussinessModel = wrapper?.wrappedValue
                loadData()
            }
        }
        
    }
    
    
    func  notifyOperateCell(notify: NSNotification){
        if let _ = notify.userInfo {
            var badgeNumber = badge.badgeValue
            
            badgeNumber = badgeNumber + 1

            badge.badgeValue = badgeNumber
            
            
        }
    }
    
    func notifyClearNumber(){
        
        badge.badgeValue = 0
    }
    
    
    @IBAction func targetForRequirementAction(anyobj: AnyObject){
        
        let button = anyobj as! UIButton
        
        func selectButton(tag : Int){
            
            switch tag {
            case 1:
                requireButton.setImage(UIImage(named: "imcollable_selected"), forState: UIControlState.Normal)
                assignButton.setImage(UIImage(named: "imLink"), forState: UIControlState.Normal)
                collaborationButton.setImage(UIImage(named: "imexe"), forState: UIControlState.Normal)
                if serviceInstsView != nil {
                    serviceInstsView.hidden = true
                }
            case 2:
                
                requireButton.setImage(UIImage(named: "imcollable"), forState: UIControlState.Normal)
                assignButton.setImage(UIImage(named: "imLink_selected"), forState: UIControlState.Normal)
                collaborationButton.setImage(UIImage(named: "imexe"), forState: UIControlState.Normal)
                if serviceInstsView != nil {
                    serviceInstsView.hidden = true
                }
            case 3:
                
                requireButton.setImage(UIImage(named: "imcollable"), forState: UIControlState.Normal)
                assignButton.setImage(UIImage(named: "imLink"), forState: UIControlState.Normal)
                collaborationButton.setImage(UIImage(named: "imexe_selected"), forState: UIControlState.Normal)
                
                if serviceInstsView != nil {
                    serviceInstsView.hidden = false
                }
                
            default :

                break
            }
            
        }
        
        selectButton(button.tag)
        
        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIAIRequirementViewControllerNotificationName, object: button.tag)
        
        //withSwitchProfessionVC(button.tag)
    }
    
    @IBAction func targetForTableViewSelectAction(anyobj: AnyObject){
        //withSwitchProfessionVC(4)
    }
    

}

extension AIRequirementMenuViewController : VerticalScrollViewDelegate{
    func buildServiceInstsView(){
        
        if let models = models {
            let scorllViewheight = self.view.height - collaborationButton.top  - collaborationButton.height - scrollViewBottomPadding
            let frame = CGRect(x: 3, y: CGRectGetMaxY(collLabel.frame)-10, width: 65, height: scorllViewheight)
            
            serviceInstsView = AIVerticalScrollView(frame: frame)
            serviceInstsView.userInteractionEnabled = true
            serviceInstsView.myDelegate = self
            serviceInstsView.showsVerticalScrollIndicator = false
            //选择服务执行的时候才展现
            serviceInstsView.hidden = true
            view.addSubview(serviceInstsView)
            
            serviceInstsView.loadData(models)
        }
        
        
    }
    
    func loadData(){
        /*
        models = [IconServiceIntModel(serviceInstId: 0, serviceIcon: "http://171.221.254.231:3000/upload/proposal/YPIHMPynGR2xY.png", serviceInstStatus: ServiceInstStatus.Init, executeProgress: 0),
            IconServiceIntModel(serviceInstId: 1, serviceIcon: "http://171.221.254.231:3000/upload/proposal/EZwliZwHINGpm.png", serviceInstStatus: ServiceInstStatus.Init, executeProgress: 3),
            IconServiceIntModel(serviceInstId: 2, serviceIcon: "http://171.221.254.231:3000/upload/proposal/zqfE5Ih4FILC3.png", serviceInstStatus: ServiceInstStatus.Assigned, executeProgress: 4),
            IconServiceIntModel(serviceInstId: 3, serviceIcon: "http://171.221.254.231:3000/upload/proposal/ZwTgxOj4Z8B8J.png", serviceInstStatus: ServiceInstStatus.Assigned, executeProgress: 5),
            IconServiceIntModel(serviceInstId: 4, serviceIcon: "http://171.221.254.231:3000/upload/proposal/bEDQ3qHoDSb6L.png", serviceInstStatus: ServiceInstStatus.Init, executeProgress: 6),
            IconServiceIntModel(serviceInstId: 5, serviceIcon: "http://171.221.254.231:3000/upload/proposal/4tkjgr4v2fknW.png", serviceInstStatus: ServiceInstStatus.Assigned, executeProgress: 10),
            IconServiceIntModel(serviceInstId: 6, serviceIcon: "http://171.221.254.231:3000/upload/proposal/Insf2PI1QT8ta.png", serviceInstStatus: ServiceInstStatus.Assigned, executeProgress: 10),
            IconServiceIntModel(serviceInstId: 7, serviceIcon: "http://171.221.254.231:3000/upload/proposal/NKfG9YRqfEZq3.png", serviceInstStatus: ServiceInstStatus.Init, executeProgress: 2),
            IconServiceIntModel(serviceInstId: 8, serviceIcon: "http://171.221.254.231:3000/upload/shoppingcart/3CHKvIhwNsH0T.png", serviceInstStatus: ServiceInstStatus.Init, executeProgress: 2)]

        
        self.buildServiceInstsView()
        */
        
        
        self.models = bussinessModel?.serviceModels //AIRequirementViewPublicValue.bussinessModel
        self.buildServiceInstsView()

    }
    
    func viewCellDidSelect(verticalScrollView : AIVerticalScrollView , index : Int , cellView : UIView){
        var serviceInstIds = Array<Int>()
        
        for selectModel in verticalScrollView.getSelectedModels(){
            serviceInstIds.append(selectModel.serviceInstId)
        }
        
        //点击后发通知
        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.AIRequirementSelectServiceInstNotificationName, object: serviceInstIds)
        
    }

}
