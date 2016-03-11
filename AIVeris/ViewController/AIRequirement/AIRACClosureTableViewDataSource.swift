//
//  AIRACClosureTableViewDataSource.swift
//  AIVeris
//
//  Created by tinkl on 3/11/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIRACClosureTableViewDataSource: NSObject {
    
    var dataSections: [AIIconTagModel]?
    var blockArrays: [(NSIndexPath) -> Void]?
    override init() {
        super.init()
    }
     
    //pragma mark Private Methods
    
    
    func addCell(cell: UITableViewCell, didSelectBlock:((NSIndexPath -> Void))){
//        
//        let castedBlock: AnyObject = unsafeBitCast(didSelectBlock as @convention(block) (NSIndexPath) -> Void, AnyObject.self)
//        let cellInfo = NSMutableDictionary()
//        cellInfo["block"] = castedBlock
//        cellInfo["cell"] = cell
//        dataSections.addObject(cellInfo)
//        return cell
        
    }
    
 
}

extension AIRACClosureTableViewDataSource: UITableViewDataSource, UITableViewDelegate{
    
    //pragma mark UITableViewDataSource/Delegate Methods
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 33
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //didSelectRowAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let model =  dataSections?[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? AIRACClosureTableViewCell
        if cell == nil {
            cell = AIRACClosureTableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        cell?.refereshData(model!)
        return cell!
        
    }
}