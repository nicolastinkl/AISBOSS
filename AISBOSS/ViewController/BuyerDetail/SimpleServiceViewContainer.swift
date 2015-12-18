//
//  SimpleServiceViewContainer.swift
//  AIVeris
//
//  Created by Rocky on 15/11/18.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

class SimpleServiceViewContainer: UIView {
    
    private static let DIVIDER_TOP_MARGIN: CGFloat = 1
    private static let DIVIDER_BOTTOM_MARGIN: CGFloat = 1

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomContentView: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var paramsView: UIView!
    @IBOutlet weak var originalPrice: AIHorizontalLineLabel!
    @IBOutlet weak var savedMoney: UILabel!
    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var divider: UIImageView!
    @IBOutlet weak var settingState: UIImageView!
    
    @IBOutlet weak var savedMoneyWidth: NSLayoutConstraint!
    @IBOutlet weak var paramsViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var dividerTopMargin: NSLayoutConstraint!
    @IBOutlet weak var dividerBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var messageHeight: NSLayoutConstraint!
    @IBOutlet weak var dividerHeight: NSLayoutConstraint!
    @IBOutlet weak var topHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    var dataModel: AIProposalServiceModel?
    var settingButtonDelegate: SettingClickDelegate?
    
    internal var displayDeleteMode: Bool? {
        didSet{
            guard let dModel = self.displayDeleteMode else {
                return
            }

            if dModel {
                //Deleted MODE.
                self.topView.backgroundColor = UIColor(hex: "a09edd").colorWithAlphaComponent(0.35)
                self.bottomContentView.backgroundColor = UIColor(hex: "dad9fa").colorWithAlphaComponent(0.15)
                cancelButton.hidden = false
                
            }else{
                self.topView.backgroundColor = UIColor(hex: "A09EDD").colorWithAlphaComponent(0.35)
                self.bottomContentView.backgroundColor = UIColor(hex: "D6D5F6").colorWithAlphaComponent(0.15)
                cancelButton.hidden = true
 
            }
            
        }
    }

    
    private var paramViewHeight: CGFloat = 0
    private var settingFlag = false
    
    var isSetted: Bool {
        get {
            return settingFlag
        }
        
        set {
            settingFlag = newValue
            if newValue {
                settingState.image = UIImage(named: "gear_white")
            } else {
                settingState.image = UIImage(named: "gear_black")
            }
        }
    }
    
    class func currentView() -> SimpleServiceViewContainer{
        let serviceView = NSBundle.mainBundle().loadNibNamed("SimpleServiceViewContainer", owner: self, options: nil).first as! SimpleServiceViewContainer
        return serviceView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        name.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(42))
        price.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(48))
        review.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(31))
        savedMoney.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(31))
        originalPrice.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(26))
        
        layer.cornerRadius = 6
        layer.masksToBounds = true
        logo.layer.cornerRadius = logo.width / 2
        
        originalPrice.linePosition = .Middle
        
        settingState.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "settingClickHandle:"))
    }
    
    //加载数据
    func loadData(dataModel : AIProposalServiceModel){
        self.dataModel = dataModel
        
        logo.asyncLoadImage("\(dataModel.service_thumbnail_icon)")
        name.text = dataModel.service_desc ?? ""
        
        setPrice()

        setParamView()
        
        if hasHopeList() {
            createHopeList()
        }
        
        if isParamSetted() {
            isSetted = true
        }
        
        createReviewView(dataModel.service_rating_level)
    }
    
    func settingClickHandle(sender: UITapGestureRecognizer) {
        settingButtonDelegate?.settingButtonClicked(settingState, parentView: self)
    }
    
    private func setPrice() {
        if let priceModel = dataModel!.service_price {
            price.text = priceModel.original ?? "ServiceContainerView.dollarZero".localized
            
            if priceModel.saved != nil && priceModel.saved != "" {
                savedMoney.text = priceModel.saved
                savedMoneyWidth.constant = savedMoney.text!.sizeWithFont(savedMoney.font, forWidth: 75).width
                savedMoney.setNeedsUpdateConstraints()
                
                originalPrice.text = priceModel.original ?? ""
                
                price.text = priceModel.discount
            }
        } else {
            price.text = "ServiceContainerView.dollarZero".localized
        }
    }
    
    private func setParamView() {
        if dataModel!.service_param != nil {
            
            if let key = dataModel!.service_param.param_key {
                let viewTemplate = ProposalServiceViewTemplate(rawValue: Int(key)!)
                if let paramValueString = dataModel!.service_param.param_value{
                    //                    let jsonData = paramValueString.dataUsingEncoding(NSUTF8StringEncoding)
                    //获取到参数的dictionary
                    //                    let paramDictionary = try? NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    if let serviceView = createServiceView(viewTemplate!, jsonData : paramValueString) {
                        addParamsView(serviceView)
                    }
                }
            }
        }
    }
    
    private func hasHopeList() -> Bool {
        return dataModel!.wish_list != nil && dataModel!.wish_list.hope_list != nil
    }
    
    private func createHopeList() {
        let hopeModel = dataModel!.wish_list
        let msgContent = ServiceSettingView.createInstance()
        msgContent.loadData(model: hopeModel)
        
        dividerTopMargin.constant =  msgContent.height
        messageHeight.constant = msgContent.height
        
        messageView.setNeedsUpdateConstraints()
        
        messageView.addSubview(msgContent)
        
        layout(messageView, msgContent) {container, view in
            view.edges == container.edges
        }
        
        divider.hidden = false
        dividerHeight.constant = 0.5
        divider.setNeedsUpdateConstraints()
        frame.size.height = totalHeight()
    }
    
    private func isParamSetted() -> Bool {
        return dataModel!.param_setting_flag == ParamSettingFlag.Set.rawValue
    }
    
    private func createServiceView(viewTemplate : ProposalServiceViewTemplate, jsonData : String) -> View? {
        let paramViewWidth = AITools.displaySizeFrom1080DesignSize(1010)
        var paramView: ServiceParamlView?
        
        switch viewTemplate {
        case .PlaneTicket:
            paramView = FlightServiceView.createInstance()
        case .Taxi:
            paramView = TransportService(frame: CGRect(x: 0, y: 0, width: paramViewWidth, height: 0))
        case .Hotel:
            paramView = AccommodationService(frame: CGRect(x: 0, y: 0, width: paramViewWidth, height: 0))
        case .SingleParam:
            paramView = AITitleAndIconTextView.createInstance()
        case .MutilParams:
            paramView = ServiceCardDetailFlag(frame: CGRect(x: 0, y: 0, width: paramViewWidth, height: 0))
        case .MutilTextAndImage:
            paramView = ServiceCardDetailIcon(frame: CGRect(x: 0, y: 0, width: paramViewWidth, height: 0))
        case .Shopping:
            paramView = ServiceCardDetailShopping(frame: CGRect(x: 0, y: 0, width: paramViewWidth, height: 0))
        }
        
        paramView?.loadData(json: jsonData)
        
        return paramView
    }
    
    func selfHeight() -> CGFloat {
        return  getTopHeight() + paramsViewTopMargin.constant + paramViewHeight + dividerTopMargin.constant + dividerBottomMargin.constant + divider.height
    }
    
    
    private func addParamsView(serviceParams: UIView) {
        let height = getTopHeight() + paramsViewTopMargin.constant + serviceParams.frame.height + dividerTopMargin.constant + dividerBottomMargin.constant + divider.height
        self.frame.size.height = height
        
        paramViewHeight = serviceParams.frame.height
        paramsView.addSubview(serviceParams)
        
        layout(paramsView, serviceParams) {container, item in
            item.edges == container.edges
        }
    }
    
    private func createReviewView(rating: Int) {
        if rating < 0  {
            review.hidden = true
            topHeight.constant = 34
            topView.setNeedsUpdateConstraints()
            return
        }
        
        let starRateView = CWStarRateView(frameAndImage: CGRectMake(0, 0, 60, 10), numberOfStars: 5, foreground: "review_star_yellow", background: "review_star_gray")
        topView.addSubview(starRateView)
        let score: CGFloat = CGFloat(rating) / 10
        starRateView.scorePercent = score
        
        layout(starRateView, review) {star, review in
            star.left == review.right - 2
            star.height == starRateView.height
            star.width == starRateView.width
            star.top == review.top + 1
        }
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
       settingButtonDelegate?.simpleServiceViewContainerCancelButtonDidClick(self)
    }
    private func getTopHeight() -> CGFloat {
        return topView.height
    }
    
    private func totalHeight()-> CGFloat {
        return getTopHeight() + paramsViewTopMargin.constant + paramViewHeight + dividerTopMargin.constant + dividerBottomMargin.constant + divider.height + messageHeight.constant
    }
}

protocol SettingClickDelegate {
    func simpleServiceViewContainerCancelButtonDidClick(simpleServiceViewContainer: SimpleServiceViewContainer)
    func settingButtonClicked(settingButton: UIImageView, parentView: SimpleServiceViewContainer)
}
