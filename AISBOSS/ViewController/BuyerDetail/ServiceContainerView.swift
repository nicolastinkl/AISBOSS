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
    var leftIndicator: BallIndicator!
    var rightServiceView: ServiceContentView!
    
    @IBOutlet weak var topBall: UIImageView!
    @IBOutlet weak var bottomBall: UIImageView!
    @IBOutlet weak var linkLine: UIImageView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var grade: UIImageView!
    @IBOutlet weak var detail: UIView!
    
    private var dataModel: AIProposalServiceModel?
    private var primeFlag = false
    
    var isPrimeService: Bool {
        get {
            return primeFlag
        }
        set {
            primeFlag = newValue
            
            if primeFlag == true {
                leftIndicator.setIndicatorIsPrime()
                frame.size.height += 10
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func buildSubviews() {
        leftIndicator = BallIndicator(frame: CGRect(x: 0, y: 0, width: ServiceViewContainer.INDICATOR_WIDTH, height: 0))
        rightServiceView = ServiceContentView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        addSubview(leftIndicator)
        addSubview(rightServiceView)
    }
    
    //加载数据
    func loadData(dataModel : AIProposalServiceModel){
        self.dataModel = dataModel
        
        logo.asyncLoadImage(dataModel.service_thumbnail_icon ?? "")
        grade.asyncLoadImage(dataModel.service_rating_icon ?? "")
        price.text = dataModel.service_price ?? "$0"
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
                    }
                }
                
            }
            
        }
    }
    
    
    private func createServiceView(viewTemplate : ProposalServiceViewTemplate,paramDictionary : NSDictionary) -> View? {
        
        switch viewTemplate {
        case ProposalServiceViewTemplate.PlaneTicket:
            //   isPrimeService = true
            let serviceDetailView = FlightService(frame: CGRect(x: 0, y: 0, width: detail.frame.width, height: 0))
            serviceDetailView.loadData(paramDictionary)
            return serviceDetailView
        case ProposalServiceViewTemplate.Taxi:
            return TransportService(frame: CGRect(x: 0, y: 0, width: detail.frame.width, height: 0))
        case ProposalServiceViewTemplate.Hotel:
            return AccommodationService(frame: CGRect(x: 0, y: 0, width: detail.frame.width, height: 0))
            //        default:
            //            return nil
        }
    }
}

class BallIndicator: UIView {
    @IBOutlet weak var topBall: UIImageView!
    @IBOutlet weak var bottomBall: UIImageView!
    @IBOutlet weak var linkLine: UIImageView!
    var group: ConstraintGroup!
    
    static let BIG_BALL_WIDTH = AITools.displaySizeFrom1080DesignSize(57)
    static let SMALL_BALL_WIDTH = AITools.displaySizeFrom1080DesignSize(45)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
   //     buildSbuViews()
   //     layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
    }
    
    func buildSbuViews() {
        topBall = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        topBall.contentMode = .Bottom
        bottomBall = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBall.contentMode = .Top
        linkLine = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        topBall.image = UIImage(named: "hollow_ball_half_bottom")
        bottomBall.image = UIImage(named: "hollow_ball_half_top")
        linkLine.image = UIImage(named: "link_line_vertical")
        
        
        addSubview(topBall)
        addSubview(bottomBall)
        addSubview(linkLine)
    }
    
    func layoutView() {
        
        
        group = constrain(topBall) {topBall in
            topBall.top == topBall.superview!.top
            topBall.centerX == topBall.superview!.centerX
            topBall.width == LeftIndicator.SMALL_BALL_WIDTH
            topBall.height == topBall.width / 2
        }
        
        constrain(topBall, bottomBall) {topBall, bottomBall in
            //            topBall.top == topBall.superview!.top
            //            topBall.left == topBall.superview!.left
            //            topBall.width == LeftIndicator.SMALL_BALL_WIDTH
            //            topBall.height == topBall.width / 2
            
            bottomBall.bottom == bottomBall.superview!.bottom
            bottomBall.centerX == topBall.centerX
            bottomBall.width == LeftIndicator.SMALL_BALL_WIDTH
            bottomBall.height == bottomBall.width / 2
        }
    }
    
    func setIndicatorIsPrime() {
        topBall.image = UIImage(named: "white_ball")
        topBall.contentMode = .Top
        constrain(topBall, replace: group) { topBall in
            topBall.top == topBall.superview!.top
            topBall.left == topBall.superview!.left
            topBall.width == LeftIndicator.BIG_BALL_WIDTH ~ UILayoutPriorityFittingSizeLevel
            topBall.height == topBall.width ~ UILayoutPriorityFittingSizeLevel
        }
    }
    
    func refreshVerticalLineLayout() {
        layout(topBall, bottomBall, linkLine) {topBall, bottomBall, linkLine in
            
            linkLine.top == topBall.bottom
            linkLine.centerX == topBall.centerX
            linkLine.width == 2
            linkLine.bottom == bottomBall.top
        }
        
    }
}


class ServiceContentView: UIView {
    static let LOGO_WIDTH: CGFloat = AITools.displaySizeFrom1080DesignSize(60)
    static let LOGO_HEIGHT: CGFloat = LOGO_WIDTH
    static let PADDING_TOP: CGFloat = AITools.displaySizeFrom1080DesignSize(34)
    static let PADDING_LEFT: CGFloat = AITools.displaySizeFrom1080DesignSize(34)
    static let PADDING_RIGHT: CGFloat = AITools.displaySizeFrom1080DesignSize(15)
    static let PADDING_BOTTOM: CGFloat = 20
    static let TITLE_MAGIN_BOTTOM: CGFloat = AITools.displaySizeFrom1080DesignSize(44)
    

    
    var content: UIView?
    private var dataModel : AIProposalServiceModel!
    
    
    var contentView: UIView? {
        get {
            return content
        }
        set {
            content = newValue
            if content != nil {
                addjustContentFrame()
                addjustSelfFrame()
                addSubview(content!)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadData(dataModel : AIProposalServiceModel){
        self.dataModel = dataModel

    }


    

    
   
    
    private func setFrameToHeadSize() {
        frame.size.height = RightServiceView.getHeadHeight()
    }
    
    static func getHeadHeight() -> CGFloat {
        return RightServiceView.PADDING_TOP + LOGO_HEIGHT + RightServiceView.TITLE_MAGIN_BOTTOM
    }
    
    private func addjustContentFrame() {
     //   let oldFrame = content!.frame
     //   content!.frame = CGRect(x: RightServiceView.PADDING_LEFT, y: logo.frame.origin.y + logo.frame.height + RightServiceView.TITLE_MAGIN_BOTTOM, width: frame.width - RightServiceView.PADDING_LEFT - RightServiceView.PADDING_RIGHT, height: oldFrame.height)
    }
    
    private func addjustSelfFrame() {
        frame.size.height = RightServiceView.getHeadHeight() + content!.frame.size.height
    }
}
