//
//  PurchasedTestTableViewController.swift
//  AIVeris
//
//  Created by admin on 15/10/21.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class PurchasedTestTableViewController: UITableViewController, DimentionChangable {
    
    private var cellHeightCache: [NSIndexPath : CGFloat] = [NSIndexPath : CGFloat]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if cell.contentView.subviews.count == 0 {
            
            let servicesViewContainer = ProposalExpandedView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: 50))
            servicesViewContainer.dimentionListener = self
            
            let serviceView1 = PurchasedServiceView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: PurchasedViewDimention.SERVICE_COLLAPSED_HEIGHT))
            
            let expandContent1 = ImageContent(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: 140))
            expandContent1.imgUrl = "http://www.ckocean.cn/images/image/20130603170978997899.jpg"
            
            serviceView1.addExpandView(expandContent1)
            servicesViewContainer.addServiceView(serviceView1)
            cell.contentView.addSubview(servicesViewContainer)
            
            let serviceView2 = PurchasedServiceView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: PurchasedViewDimention.SERVICE_COLLAPSED_HEIGHT))
            
            let expandContent2 = ImageContent(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: 140))
            expandContent2.imgUrl = "http://www.ckocean.cn/images/image/20130603170978997899.jpg"
            
            serviceView2.addExpandView(expandContent2)
            servicesViewContainer.addServiceView(serviceView2)
            cell.contentView.addSubview(servicesViewContainer)
            
            cellHeightCache[indexPath] = servicesViewContainer.getHeight()
        }
        

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let height = cellHeightCache[indexPath] {
            return height
        } else {
            return 1
        }
    }
  

    func heightChanged(beforeHeight: CGFloat, afterHeight: CGFloat) {
        refreshCellHeight()
        tableView.reloadData()
    }
    
    private func refreshCellHeight() {
        for indexPath in cellHeightCache.keys {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                if let proposalView = cell.contentView.subviews.first as? ProposalExpandedView {
                    cellHeightCache[indexPath] = proposalView.getHeight()
                }
            }
        }
    }
}
