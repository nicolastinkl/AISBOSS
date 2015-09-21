//
//  AirTicketView.swift
//  AIVeris
//
//  Created by Rocky on 15/9/21.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AirTicketView: UIView {
    
    static let TICKET_HEAD_HEIGHT: CGFloat = 85
    static let TICKET_HEIGHT: CGFloat = 140

    @IBOutlet weak var flightNumber: UILabel!
    @IBOutlet weak var startAirport: UILabel!
    @IBOutlet weak var finishAirport: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var arriveDate: UILabel!
    @IBOutlet weak var ticketType: UILabel!
    @IBOutlet weak var priceAndPassengerType: UILabel!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
