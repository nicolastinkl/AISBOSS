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
    
    private var cellHeights: [Int : CGFloat] = [Int : CGFloat]()
    
    @IBOutlet weak var tableView: UITableView!
    // MARK: life cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
   
    
    // MARK: event response
    
    // MARK: private methods
    
    // MARK: getters and setters
    
    // MARK: swift controls
    
    // MARK: function extension
    
    // MARK: Priate Variable
    
}


// MARK: delegate

// MARK: datesource

extension AIBuyerDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.clearColor()
        let serviceView = ServiceViewContainer(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: 50))
        
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
        
        cell.contentView.addSubview(serviceView)
        cellHeights[indexPath.row] = serviceView.frame.height
        
        
        // Configure the cell...
        
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