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
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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

extension AIBuyerDetailViewController:UITableViewDataSource,UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        return UITableViewCell()
    }
}