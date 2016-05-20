//
//  AIShoppingListView.swift
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

/// 购物列表视图
class AIShoppingListView: UIView,UITableViewDataSource,UITableViewDelegate {
    
    var dataSource: [AIShoppingModel]? {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        lineView.addBottomWholeSSBorderLine("#6441D9")
        titleLabel.font = AITools.myriadSemiCondensedWithSize(22)
        titleLabel.text = "Shopping list"
        let cellNib = UINib(nibName: "AIShoppingListViewCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "cell")
        
    }
    
    /**
     *  TableView Delegate and DataSource
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! AIShoppingListViewCell
        let model = dataSource?[indexPath.row]
        if let model = model {
            cell.fillDataWithModel(model)
        }
        cell.backgroundColor = UIColor.clearColor()
        cell.addBottomWholeSSBorderLine("#6441D9")
        cell.selectionStyle = .None
        
        cell.subviews.forEach { (sview) in
            let name = NSStringFromClass(sview.classForCoder)
            if name == "UITableViewCellContentView" {
                sview.hidden = true            
            }
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}