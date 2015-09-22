//
//  AirTicketGroupView.swift
//  AIVeris
//
//  Created by Rocky on 15/9/21.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//
// use:
/*tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")

override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

let ticketGroupView = AirTicketGroupView()
cell.contentView.addSubview(ticketGroupView)

layout(ticketGroupView) { viewTic in
    viewTic.left == viewTic.superview!.left
    viewTic.top == viewTic.superview!.top
    viewTic.right == viewTic.superview!.right
    viewTic.height == 200
}

ticketGroupView.setTicketsData()

return cell
}*/

//

import UIKit
import Cartography

class AirTicketGroupView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func setTicketsData() {
        let nib1 = NSBundle.mainBundle().loadNibNamed("AirTicketView", owner: self, options: nil)
        let ticket1: AirTicketView = nib1.first as! AirTicketView
        self.addSubview(ticket1)
        
        layout(ticket1) { ticketView in
            ticketView.left == ticketView.superview!.left
            ticketView.top == ticketView.superview!.top
            ticketView.right == ticketView.superview!.right
        }
         
        let nib2 = NSBundle.mainBundle().loadNibNamed("AirTicketView", owner: self, options: nil)
        let ticket2: AirTicketView = nib2.first as! AirTicketView
        ticket2.setTop(ticket1.top + AirTicketView.TICKET_HEAD_HEIGHT)
        addSubview(ticket2)
        
        layout(ticket1, ticket2) { ticket1, ticket2 in
            ticket2.top == ticket1.top + AirTicketView.TICKET_HEAD_HEIGHT
            ticket2.left == ticket1.superview!.left
            ticket2.right == ticket1.superview!.right
        }
    }
    
    func getViewHeight() -> CGFloat {
        return AirTicketView.TICKET_HEAD_HEIGHT + AirTicketView.TICKET_HEIGHT
    }

}
