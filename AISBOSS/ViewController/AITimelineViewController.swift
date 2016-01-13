
//
//  AITimelineViewController.swift
//  AI2020OS
//
//  Created by tinkl on 31/3/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

import UIKit

import Cartography

class AITimelineViewController: UIViewController {

    private var currentTimeView = AITIMELINESDTITLEView.currentView()
    private var dateString:String!
    @IBOutlet weak var tableView: UITableView!
    
    private var dataTimeLineArray:Array<AnyObject>{
        return [
            ["paramsTime":"3月14日","currentTime":"10:20","title":"瑞士凯斯瑜伽课","content":"Jeeny老师|印度特色课"],
            ["paramsTime":"4月4日","currentTime":"16:20","title":"厨师培训课","content":"Jeeny老师|印度特色课"],
            ["paramsTime":"4月14日","currentTime":"08:20","title":"雅典瑜伽课","content":"Jeeny老师|印度特色课"],
            ["paramsTime":"6月14日","currentTime":"09:20","title":"教画画","content":"Jeeny老师|印度特色课"]]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "时间线"
        
        self.tableView.reloadData()
        
        let label = UILabel()
        //label.backgroundColor = UIColor(rgba: "#a7a7a7")
        self.view.insertSubview(label, atIndex: 0)

        constrain(label) { view in
            view.width == 0.5
            view.height == view.superview!.height+1000
            view.centerY == view.superview!.centerY
            view.leading == view.superview!.leading + 42
        }
        label.addDashedBorder()

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        dateString = dateFormatter.stringFromDate(NSDate())
        
        self.currentTimeView.labelTime.text = dateString
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer!.delegate = nil
        super.viewWillAppear(animated)
    }
    
    @IBAction func showAnimationAction(sender: AnyObject) {
         AIOpeningView.instance().show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension AITimelineViewController: UITableViewDataSource,UITableViewDelegate{
    
    
     func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let currnetDicValue = dataTimeLineArray[section] as! Dictionary<String,String>
        
        let time = currnetDicValue["currentTime"] as NSString?
        
        let arrayPre = time?.componentsSeparatedByString(":")
        if dateString != nil {
            
            let arrayCurrent = dateString?.componentsSeparatedByString(":")
            
            let first = (arrayPre![0] as String).toInt()
            
            let firstS = (arrayCurrent![0] as String).toInt()
            
            if first < firstS  {
                return 60
            }
        }
        
        
        return 0
    }
    
     func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return  self.currentTimeView
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 44.0
        }
        return 82.0
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return dataTimeLineArray.count

    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let currnetDicValue = dataTimeLineArray[indexPath.section] as! Dictionary<String,String>

        switch indexPath.row{

        case 0:
            //placeholder cell
            let avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITIMELINESDTimesViewCell) as! AITIMELINESDTimesViewCell
            avCell.monthLabel.text = currnetDicValue["paramsTime"]
            return avCell
        case 1:
            //placeholder cell
            let avCell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITIMELINESDContentViewCell) as! AITIMELINESDContentViewCell
            avCell.timeLabel?.text = currnetDicValue["currentTime"]
            avCell.titleLabel?.text = currnetDicValue["title"]
            avCell.contentLabel?.text = currnetDicValue["content"]
            return avCell
            
        default:
            break
        }
        return UITableViewCell()
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

