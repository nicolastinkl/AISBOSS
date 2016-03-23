//
//  BuyerRequirmentMessageViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/3/23.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class BuyerRequirmentMessageViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orderAndBuyerInfoView = OrderAndBuyerInfoView.createInstance()
        topView.addSubview(orderAndBuyerInfoView)
        
        orderAndBuyerInfoView.snp_makeConstraints { (orderView) -> Void in
            orderView.edges.equalTo(topView)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.tableFooterView = UIView()
        let cellNib = UINib(nibName: "BuyerMessageCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "cell")

    }
    
    @IBAction func backAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension BuyerRequirmentMessageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {    
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? BuyerMessageCell {

            return cell
        } else {
            // never goes here
            let cell = DependOnNodeCell(style: .Default, reuseIdentifier: "cell")
            return cell
        }
        
    }
}
