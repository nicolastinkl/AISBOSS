//
//  UIBuyerDetailViewController.swift
//  AIVeris
//
//  Created by tinkl on 3/11/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

import UIKit

class AIBuyerDetailViewController : UIViewController {
    
    // MARK: Priate Variable
    
    private var cellHeights: [Int : CGFloat] = [Int : CGFloat]()
    
    // MARK: swift controls
    
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

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Init Label Font
        InitLabelFont()
        
        // Init Data
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.NSNotiryAricToNomalStatus, object: nil)
    }
    
    func InitLabelFont(){
        self.backButton.titleLabel?.font =  AITools.myriadSemiCondensedWithSize(80 / PurchasedViewDimention.CONVERT_FACTOR)
        self.moneyLabel.font =  AITools.myriadLightSemiExtendedWithSize(45 / PurchasedViewDimention.CONVERT_FACTOR)
        self.numberLabel.font =  AITools.myriadLightSemiExtendedWithSize(45 / PurchasedViewDimention.CONVERT_FACTOR)
        self.OrderFromLabel.font = AITools.myriadLightSemiExtendedWithSize(48 / PurchasedViewDimention.CONVERT_FACTOR)
        self.totalMoneyLabel.font =  AITools.myriadSemiCondensedWithSize(70 / PurchasedViewDimention.CONVERT_FACTOR)
        self.whereLabel.font = AITools.myriadLightSemiExtendedWithSize(48 / PurchasedViewDimention.CONVERT_FACTOR)
        self.contentLabel.font = AITools.myriadLightSemiExtendedWithSize(48 / PurchasedViewDimention.CONVERT_FACTOR)
    }
       
    // MARK: event response
    
    @IBAction func closeThisViewController(){
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    // MARK: private methods
    
}


// MARK: delegate

// MARK: datesource

// MARK: function extension
extension AIBuyerDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.clearColor()
        let serviceView = ServiceViewContainer(frame: CGRect(x: 20, y: 0, width: cell.frame.width - 40, height: 50))
        
        switch indexPath.row {
        case 0:
            serviceView.data = 0
        case 1:
            serviceView.data = 1
        case 2:
            serviceView.data = 2
        default:
            break
        }
        if cell.contentView.subviews.count == 0 {
            cell.contentView.addSubview(serviceView)
        }
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