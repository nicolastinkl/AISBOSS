//
//  AIRACClosureTableViewDataSource.swift
//  AIVeris
//
//  Created by tinkl on 3/11/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIRACClosureTableViewDataSource: NSObject, AIRACClosureTableViewCellProtocol {
    
    var dataSections: [AIServiceProvider]?
    
    var selectedDataSections = Array<AIServiceProvider>()
    
    var hasExecTagModel : [AIIconTagModel]?
    
    var blockArrays: [(NSIndexPath) -> Void]?

    override init() {
        super.init()
    }
    
    //pragma mark Private Methods
    
    func withSelectedCell(cellModel: AIServiceProvider, isSelect: Bool) {
        
        if isSelect == true {
            selectedDataSections.append(cellModel)
        }else{
            if selectedDataSections.count > 0 {
                selectedDataSections.removeLast()
            }
            
        }        
    }     
 
}

extension AIRACClosureTableViewDataSource: UITableViewDataSource, UITableViewDelegate{
    
    //pragma mark UITableViewDataSource/Delegate Methods
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52
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
        
        cell?.delegateCell = self
        cell?.hasExecTagModel = hasExecTagModel
        cell?.refereshData(model!)

        return cell!
        
    }
}