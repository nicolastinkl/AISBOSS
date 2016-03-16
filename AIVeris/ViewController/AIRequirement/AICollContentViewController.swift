//
//  AICollContentViewController.swift
//  AIVeris
//
//  Created by tinkl on 3/8/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AICollContentViewController: UIViewController {
    
    var assginServiceInsts : [AssignServiceInstModel]?
    var serviceInstView : AIAssignServiceView!
    var limitListView : AILimitListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //四边不要留距离
        self.edgesForExtendedLayout = UIRectEdge.None
        loadData()
        buildServiceInstView()
        buildLimitListView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var serviceInstViewFrame = view.bounds
        serviceInstViewFrame.size.height = 200
        serviceInstView.frame = serviceInstViewFrame
    }
    
    func buildLimitListView(){
        var frame = view.bounds
        frame.origin.y = CGRectGetMaxY(serviceInstView.frame)
        frame.size.height = 0
        limitListView = AILimitListView(frame: frame)
        limitListView.loadData((assginServiceInsts?.first?.limits)!)
        view.addSubview(limitListView)
    }
    
    func buildServiceInstView(){
        serviceInstView = AIAssignServiceView.currentView()
        serviceInstView.delegate = self
        view.addSubview(serviceInstView)
        if let assginServiceInsts = assginServiceInsts{
            serviceInstView.loadData(assginServiceInsts)
        }
    }
    
    func loadData(){
        let limits = [AILimitModel(limitId: 1, limitName: "Direct contact with consumbers", limitIcon: "Seller_Warning", hasLimit: true),AILimitModel(limitId: 1, limitName: "Direct access with consumber address", limitIcon: "Seller_Warning", hasLimit: false),AILimitModel(limitId: 1, limitName: "Initiate an authorization request directly to the customer", limitIcon: "Seller_Warning", hasLimit: true),AILimitModel(limitId: 1, limitName: "Direct modification of service execution strategies", limitIcon: "Seller_Warning", hasLimit: true)]
        
        let model1 = AssignServiceInstModel(serviceInstId: 1, serviceName: "Pregnancy Grocery", ratingLevel: 7, limits: limits)
        let model2 = AssignServiceInstModel(serviceInstId: 2, serviceName: "Household Cleaner", ratingLevel: 7, limits: limits)
        let model3 = AssignServiceInstModel(serviceInstId: 3, serviceName: "Paramedic Freelancer", ratingLevel: 7, limits: limits)
        let model4 = AssignServiceInstModel(serviceInstId: 4, serviceName: "Hospital Appointment Booking", ratingLevel: 7, limits: limits)
        assginServiceInsts = [model1,model2,model3,model4]
    }

}

extension AICollContentViewController : AIAssignServiceViewDelegate{
    
    func limitButtonAction(view : AIAssignServiceView , limitsModel : [AILimitModel]){
        limitListView.refreshLimits(limitsModel)
        let frameHeight = limitListView.getFrameHeight()
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            var frame = self.limitListView.frame
            if(self.limitListView.frame.height == 0){
                frame.size.height = frameHeight
                self.limitListView.alpha = 1
            }
            else{
                frame.size.height = 0
                self.limitListView.alpha = 0
            }
            self.limitListView.frame = frame
            }) { (finished) -> Void in
                //
        }
    }
}
