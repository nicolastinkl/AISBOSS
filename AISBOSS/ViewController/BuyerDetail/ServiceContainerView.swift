//
//  ServiceViewContainer.swift
//  AIVeris
//
//  Created by Rocky on 15/11/3.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class ServiceContainerView: UIView {
    
    static let INDICATOR_WIDTH: CGFloat = 20
    
    @IBOutlet weak var topBall: UIImageView!
    @IBOutlet weak var bottomBall: UIImageView!
    @IBOutlet weak var linkLine: UIImageView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var grade: UIImageView!
    @IBOutlet weak var detail: UIView!
    
    @IBOutlet weak var topBallHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBallHeightConstraint: NSLayoutConstraint!
    
    private var dataModel: AIProposalServiceModel?
    private var isPrimeService = false
 
    func isPrimeService(isPrime: Bool) {
        isPrimeService = isPrime
        
        if isPrime {
            topBall.image = UIImage(named: "white_ball_half_bottom")
            background.image = UIImage(named: "white_top_unfilled_corner")
            topBallHeightConstraint.constant = 10
            
        } else {
            topBall.image = UIImage(named: "hollow_ball_half_bottom")
            background.image = UIImage(named: "white_corner_bk")
            topBallHeightConstraint.constant = 8
        }
        
        topBall.setNeedsUpdateConstraints()
    }
 
    func setNextIsPrimeService(nextIsPrime: Bool) {
        if nextIsPrime {
            bottomBall.image = UIImage(named: "white_ball_half_top")
            bottomBallHeightConstraint.constant = 10
            
            if isPrimeService {
                background.image = UIImage(named: "white_all_unfilled_corner")
            } else {
                background.image = UIImage(named: "white_bottom_unfilled_corner")
            }
        } else {
            bottomBall.image = UIImage(named: "hollow_ball_half_top")
            bottomBallHeightConstraint.constant = 8
            
            if isPrimeService {
                background.image = UIImage(named: "white_top_unfilled_corner")
            } else {
                background.image = UIImage(named: "white_corner_bk")
            }
        }
        
        bottomBall.setNeedsUpdateConstraints()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        name.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(56))
        name.textColor = UIColor(hex: "#FEE300")
        
        price.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(56))
        price.textColor = UIColor.whiteColor()

    }
    
    //加载数据
    func loadData(dataModel : AIProposalServiceModel){
        self.dataModel = dataModel
        
        logo.asyncLoadImage(dataModel.service_thumbnail_icon ?? "")
        grade.asyncLoadImage(dataModel.service_rating_icon ?? "")
        
        if dataModel.service_price != nil {
            price.text = dataModel.service_price.original ?? "$0"
        }else{
            price.text = "$0"
        }
        name.text = dataModel.service_desc ?? ""
       
        if dataModel.service_param != nil {
            
            if let key = dataModel.service_param.param_key {
                let viewTemplate = ProposalServiceViewTemplate(rawValue: Int(key)!)
                if let paramValueString = dataModel.service_param.param_value{
                    let jsonData = paramValueString.dataUsingEncoding(NSUTF8StringEncoding)
                    //获取到参数的dictionary
                    let paramDictionary = try? NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    if let serviceView = createServiceView(viewTemplate!,paramDictionary : paramDictionary!) {
                        frame.size.height = detail.frame.origin.y + serviceView.frame.height
                        detail.addSubview(serviceView)
                        
                        layout(detail, serviceView) {detail, serviceView in
                            serviceView.left == detail.left
                            serviceView.top == detail.top
                            serviceView.bottom == detail.bottom
                            serviceView.right == detail.right
                        }
                    }
                }          
            }
        }
    }

    
    private func createServiceView(viewTemplate : ProposalServiceViewTemplate,paramDictionary : NSDictionary) -> View? {
        
        switch viewTemplate {
        case ProposalServiceViewTemplate.PlaneTicket:
            let serviceDetailView = FlightServiceView.createInstance()
         //   let serviceDetailView = FlightService(frame: CGRect(x: 0, y: 0, width: detail.frame.width, height: 0))
            serviceDetailView.loadData(paramDictionary)
            return serviceDetailView
        case ProposalServiceViewTemplate.Taxi:
            return TransportService(frame: CGRect(x: 0, y: 0, width: detail.frame.width, height: 0))
        case ProposalServiceViewTemplate.Hotel:
            return AccommodationService(frame: CGRect(x: 0, y: 0, width: detail.frame.width, height: 0))
        default:
            return nil
        }
    }
}
