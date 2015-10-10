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
    
    /*
    
    机票的航班名对应服务名service_name
    
    机票的价格对应服务价格对象
    
    机票起点
    
    param_key:
    1: 出发地点
    2: 到达地点
    3：出发时间
    4：到达时间
    5：往返标志
    
    "param_list":[
    {
    "param_type":5,
    "param_category":2,
    "param_key":"1",
    "param_name":"delivery_location",
    "param_value":"PEK"
    */
    
    func setTicketData(ticket: ServiceList) {
        flightNumber.text = ticket.service_name ?? ""
        priceAndPassengerType.text = ticket.service_price?.price_show ?? ""
        
        if let ticketInfo = ticket.service_param_list {
            for var index = 0; index < ticketInfo.count; index++ {
                let para = ticketInfo[index] as SchemeParamList
                let value = para.param_value ?? ""
                switch para.param_key! {
                case 1:
                    startAirport.text = value
                case 2:
                    finishAirport.text = value
                case 3:
                    startDate.text = value
                case 4:
                    arriveDate.text = value
                case 5:
                    ticketType.text = value
                default:
                    continue
                }
                
            }
        }
        
    }

}
