//
//  AICalendarViewController.swift
//  AITrans
//
//  Created by admin on 7/16/15.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//

import Foundation
import UIKit

class AICalendarViewController: UIViewController,DSLCalendarViewDelegate {
    
    @IBOutlet weak var calendarView: DSLCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.delegate = self
    }
    
    // MARK: Delegate
    
    @IBAction func closeAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func compateAction(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.UIAIASINFOChangeDateViewNotification, object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func calendarView(calendarView: DSLCalendarView!, didSelectRange range: DSLCalendarRange!) {
        let image = calendarView.screenShotView()
        
        let arrayPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let path = arrayPath.first as String
        let componentPath = path.stringByAppendingPathComponent("CalendarImage.png")
        
        
        if  UIImagePNGRepresentation(image).writeToFile(componentPath, options: NSDataWritingOptions.AtomicWrite, error: nil) {
            //logInfo(componentPath)
        }
        
    }
    
    func calendarView(calendarView: DSLCalendarView!, didDragToDay day: NSDateComponents!, selectingRange range: DSLCalendarRange!) -> DSLCalendarRange! {
        
        return range
    }
    
    func isBeforeDay(day1: NSDateComponents, day2: NSDateComponents) -> Bool{
        return  day1.date?.compare(day2.date!) == NSComparisonResult.OrderedAscending
    }
    
    
    /*
    
    - (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2 {
    return ([day1.date compare:day2.date] == NSOrderedAscending);
    }
    
    */
}