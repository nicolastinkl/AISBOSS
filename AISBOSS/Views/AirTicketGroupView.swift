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
    
    private var ticketCount: Int = 0

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    

    
    func setTicketsData(tickets: [Service]) {
        ticketCount = tickets.count
        
        var preTicket: AirTicketView?
        var totalPrice: Float = 0
        
        for var index = 0; index < tickets.count; ++index {
            let nib = NSBundle.mainBundle().loadNibNamed("AirTicketView", owner: self, options: nil)
            let ticket: AirTicketView = nib.first as! AirTicketView
            
            ticket.setTicketData(tickets[index])
            self.addSubview(ticket)
            
            if index == 0 {
                layout(ticket) { ticketView in
                    ticketView.left == ticketView.superview!.left
                    ticketView.top == ticketView.superview!.top
                    ticketView.right == ticketView.superview!.right
                }
            } else if (preTicket != nil) {
                layout(preTicket!, ticket) { preTicket, ticket in
                    ticket.top == preTicket.top + AirTicketView.TICKET_HEAD_HEIGHT
                    ticket.left == preTicket.superview!.left
                    ticket.right == preTicket.superview!.right
                }
            }
            
            totalPrice += Float(tickets[index].service_price?.price ?? 0)
            
            if index == tickets.count - 1 {
                ticket.priceAndPassengerType.text = "$ \(totalPrice)"
            }
            
            preTicket = ticket
        }
        
    }
    
    func getViewHeight() -> CGFloat {
        switch ticketCount {
        case 0:
            return 0
        case 1:
            return AirTicketView.TICKET_HEIGHT
        default:
            return AirTicketView.TICKET_HEAD_HEIGHT + AirTicketView.TICKET_HEIGHT * CGFloat(ticketCount - 1)
        }
    }

}
