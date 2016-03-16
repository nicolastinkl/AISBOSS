//
//  AICollContentViewController.swift
//  AIVeris
//
//  Created by tinkl on 3/8/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

class AICollContentViewController: UIViewController {
    
    var assginServiceInsts : [AssignServiceInstModel]?
    var serviceInstView : AIAssignServiceView!
    var limitListView : AILimitListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        buildServiceInstView()
        buildLimitListView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var serviceInstViewFrame = view.bounds
        serviceInstViewFrame.size.height = 120
        serviceInstView.frame = serviceInstViewFrame
        serviceInstView.setLeft(-20)
        serviceInstView.setTop(-20)
        serviceInstView.setWidth(view.bounds.width + 40)
        
        var limitFrame = serviceInstView.frame
        limitFrame.origin.y = CGRectGetMaxY(serviceInstView.frame)
        limitFrame.size.height = 0
        limitListView.frame = limitFrame
        limitListView.loadData((assginServiceInsts?.first?.limits)!)
    }
    
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
