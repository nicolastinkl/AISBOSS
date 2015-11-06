//
//  UIBuyerDetailViewController.swift
//  AIVeris
//
//  Created by tinkl on 3/11/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

import UIKit
import AISpring

protocol AIBuyerDetailDelegate:class{
    func closeAIBDetailViewController()
}

class AIBuyerDetailViewController : UIViewController {
    
    // MARK: Priate Variable
    
    private var cellHeights: [Int : CGFloat] = [Int : CGFloat]()
    private var dataSource : AIProposalInstModel!
    var bubleModel : AIBuyerBubbleModel?
    var delegate: AIBuyerDetailDelegate?
    
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
    
    // MARK: getters and setters
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Init Data
        initData()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50.0, 0)
        // Init Label Font
        InitLabelFont()
        
        
        
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
    
    func InitController(){
        let name = dataSource?.proposal_name ?? ""
        self.backButton.setTitle(name, forState: UIControlState.Normal)
        self.moneyLabel.text = dataSource?.order_total_price
        self.totalMoneyLabel.text = dataSource?.proposal_price
        self.numberLabel.text = "\(dataSource?.order_times ?? 0)"
        self.whereLabel.text = dataSource?.proposal_origin
        self.contentLabel.text =  dataSource?.proposal_desc
        
    }
    
    func InitLabelFont(){
        self.backButton.titleLabel?.font =  AITools.myriadSemiCondensedWithSize(80 / PurchasedViewDimention.CONVERT_FACTOR)
        self.moneyLabel.font =  AITools.myriadLightSemiCondensedWithSize(45 / PurchasedViewDimention.CONVERT_FACTOR)
        self.numberLabel.font =  AITools.myriadLightSemiCondensedWithSize(45 / PurchasedViewDimention.CONVERT_FACTOR)
        self.OrderFromLabel.font = AITools.myriadLightSemiCondensedWithSize(48 / PurchasedViewDimention.CONVERT_FACTOR)
        self.totalMoneyLabel.font =  AITools.myriadSemiCondensedWithSize(70 / PurchasedViewDimention.CONVERT_FACTOR)
        self.whereLabel.font = AITools.myriadLightSemiCondensedWithSize(48 / PurchasedViewDimention.CONVERT_FACTOR)
        self.contentLabel.font = AITools.myriadLightSemiCondensedWithSize(48 / PurchasedViewDimention.CONVERT_FACTOR)
    }
    
    // MARK: event response
    
    @IBAction func closeThisViewController(){
        delegate?.closeAIBDetailViewController()
        self.dismissViewControllerAnimated(false) { () -> Void in
            
        }
    }
    
    // MARK: private methods
    
    func refershData(){
        
    }
    
    func initData(){
        if let m = bubleModel {
            
            BDKProposalService().queryCustomerProposalDetail(m.proposal_id, success:
                {[weak self] (responseData) -> Void in
                    
                    if let strongSelf = self {
                        strongSelf.dataSource = responseData
                        
                        //InitControl Data
                        strongSelf.InitController()
                        strongSelf.tableView.reloadData()
                    }
                    
                },fail : {
                    (errType, errDes) -> Void in
                    
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
        }
        else {
            return dataSource.service_list.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.clearColor()
        
        let serviceDataModel = dataSource.service_list[indexPath.row] as! AIProposalServiceModel
        
        var serviceView: ServiceViewContainer!
        
        if indexPath.row == 0 {
            serviceView = TopServiceViewContainer(frame: CGRect(x: 20, y: 0, width: cell.frame.width - 40, height: 50))
        } else if indexPath.row == dataSource.service_list.count - 1 {
            serviceView = BottomServiceViewContainer(frame: CGRect(x: 20, y: 0, width: cell.frame.width - 40, height: 50))
        } else {
            serviceView = MiddleServiceViewContainer(frame: CGRect(x: 20, y: 0, width: cell.frame.width - 40, height: 50))
        }

        serviceView.loadData(serviceDataModel)

        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        cell.contentView.addSubview(serviceView)
        
        cellHeights[indexPath.row] = serviceView.frame.height
                
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let height = cellHeights[indexPath.row] {
            return height
        } else {
            return 1
        }
    }


}