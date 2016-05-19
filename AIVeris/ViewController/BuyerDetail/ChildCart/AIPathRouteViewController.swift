//
//  AIPathRouteViewController.swift
//  AIVeris
//
// Copyright (c) 2016 ___ASIAINFO___
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/// CanMoveRow Path Route
class AIPathRouteViewController: UIViewController {
    
    private let tableview = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.addSubview(tableview)
        tableview.frame = view.frame
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = 50
        tableview.reloadData()
        tableview.editing = true
        
        tableview.backgroundColor = UIColor.clearColor()
        tableview.separatorStyle = .None
        
        let footView = UIButton(type: .Custom)
        tableview.tableFooterView = footView
        footView.frame = CGRectMake(0, 0, self.view.width, 50)
        footView.setTitle("+", forState: UIControlState.Normal)
        footView.addBottomWholeSSBorderLine("#6441D9")
               
    }
    
}

extension AIPathRouteViewController: UITableViewDataSource,UITableViewDelegate {
 
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let deCell = tableview.dequeueReusableCellWithIdentifier("row") {
            
            return deCell
        }else{
            
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "row")
            if let sview = AIEventCapacityView.initFromNib() as? AIEventCapacityView {
                cell.addSubview(sview)
                sview.frame = cell.frame
                sview.backgroundColor = UIColor.clearColor()
                cell.addBottomWholeSSBorderLine("#6441D9")                
            }
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = .None
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = tableview.cellForRowAtIndexPath(indexPath)
        cell?.subviews.forEach { (sview) in
            let name = NSStringFromClass(sview.classForCoder)
            if name == "UITableViewCellEditControl" {
                sview.hidden = true
            }
            
        }
        return 50
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
    }
    
    
}


