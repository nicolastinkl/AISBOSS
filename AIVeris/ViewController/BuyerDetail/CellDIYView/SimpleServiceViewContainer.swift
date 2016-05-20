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
    
    /// Variables.
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
    
    // Privater
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
    
    /**
     AwakeFromeNib
     */
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
        
        settingState.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SimpleServiceViewContainer.settingClickHandle(_:))))
    }
    
    //加载数据
    func loadData(dataModel : AIProposalServiceModel){
        
        self.dataModel = dataModel
        
        logo.asyncLoadImage(dataModel.service_thumbnail_icon ?? "")
        name.text = dataModel.service_desc ?? ""
        
        setPrice()

        setParamView()
        
        if hasHopeList() {
            createHopeList()
        }
        
//        if isParamSetted() {
            isSetted = isParamSetted()
//        }
        
        createReviewView(dataModel.service_rating_level)
        
        //fixCurrentViewMODE(self.paramsView)
        
    }
    
    func fixCurrentViewMODE(v:UIView){
        /*
        self.paramsView.updateConstraints()
        _ = self.paramsView.subviews.filter { (visubs) -> Bool in
//            visubs.subviews.last?.backgroundColor = UIColor.blackColor()
            if let selfViews = visubs.subviews.last {
                
                let bottomViewHeight = selfViews.top + selfViews.height
                let slogne = AITools.displaySizeFrom1080DesignSize(50)
                let selfSlogne = self.paramsView.height - bottomViewHeight
                print(selfSlogne)
                if selfSlogne > 0 {
                    //paramViewHeight -= (selfSlogne - slogne)
                   // paramViewHeight  = paramViewHeight -  10
                }
                
            }
            
            return false
        }
        */
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
    
    
    private func hasHopeList() -> Bool {
        return dataModel!.wish_list != nil && (dataModel!.wish_list.hope_list != nil || dataModel!.wish_list.label_list != nil)
    }
    
    private func createHopeList() {
        let hopeModel = dataModel!.wish_list
        let msgContent = ServiceSettingView.createInstance()
        msgContent.loadData(model: hopeModel)
        
        dividerTopMargin.constant = SimpleServiceViewContainer.DIVIDER_TOP_MARGIN
        dividerBottomMargin.constant = SimpleServiceViewContainer.DIVIDER_BOTTOM_MARGIN
        messageHeight.constant = msgContent.height
        
        //messageView.setNeedsUpdateConstraints()
        
        messageView.addSubview(msgContent)
        
        constrain(messageView, msgContent) {container, view in
            view.edges == container.edges
        }
        
        if dataModel!.wish_list != nil {
            var labelCount = 0
            
            if dataModel!.wish_list.label_list != nil {
                labelCount = dataModel!.wish_list.label_list.count
            }
            
            var hopeCount = 0
            if dataModel!.wish_list.hope_list != nil {
                hopeCount = dataModel!.wish_list.hope_list.count
            }
            
            if (labelCount + hopeCount) == 0 {
                divider.hidden = true
            }else{
                divider.hidden = false
            }
        }else{
            divider.hidden = true
        }
        
        dividerHeight.constant = 0.5
        divider.setNeedsUpdateConstraints()
        frame.size.height = totalHeight()
        setNeedsUpdateConstraints()
    }
    
    private func isParamSetted() -> Bool {
        return dataModel!.param_setting_flag == ParamSettingFlag.Set.rawValue
    }

    private func createServiceView(models: [ServiceCellProductParamModel]?) -> View?{

        let paramViewWidth = AITools.displaySizeFrom1080DesignSize(1010)
        let paramContainerView = UIView(frame: CGRect(x: 0, y: 0, width: paramViewWidth, height: 0))
        var paramHeight:CGFloat = 0
        var pareusView:View?
        
        for  serCellModel in models! {
            if serCellModel.param_key == nil {
                return nil
            }
            let viewTemplate = ProposalServiceViewTemplate(rawValue: Int(serCellModel.param_key)!)
            if let param = getViewTemplateView(viewTemplate!) {
                param.isFirstView(serCellModel == models?.first)
                param.loadDataWithModelArray(serCellModel)
                if let par = pareusView {
                    //上一个view
                    param.setTop(par.top + par.height)
                }
                paramContainerView.addSubview(param)
                
                constrain(param, paramContainerView) {(view, container) ->() in
                    view.left == container.left
                    view.top == container.top + paramHeight
                    view.right == container.right
                    view.height == param.height
                }
                
                paramHeight += param.height
                pareusView = param
            }
        }
        
        if let modArray = models {
            if (modArray.count == 1) {
                let viewTemplate = ProposalServiceViewTemplate(rawValue: Int(modArray.first!.param_key)!)
                if (viewTemplate == .MutilTextAndImage) {
                     paramHeight += ( AITools.displaySizeFrom1080DesignSize(40))
                }
            }
        }
        paramContainerView.setHeight(paramHeight)

        return paramContainerView
       
    }
    
    /**
     根据模板获取view
     
     - parameter viewTemplate: viewTemplate description
     
     - returns: return value description
     */
    private func getViewTemplateView(viewTemplate : ProposalServiceViewTemplate) -> ServiceParamlView? {
        
        
        let paramViewWidth = AITools.displaySizeFrom1080DesignSize(1010)
        
        var paramView: ServiceParamlView?
        
        switch viewTemplate {
        case .PlaneTicket: // 机票
            paramView = FlightServiceView.createInstance()
        case .Taxi:        // 出租车
            paramView = TransportService(frame: CGRect(x: 0, y: 0, width: paramViewWidth, height: 0))
        case .Hotel:       // 酒店
            paramView = AccommodationService(frame: CGRect(x: 0, y: 0, width: paramViewWidth, height: 0))
        case .SingleParam: // 单参数
            paramView = AITitleAndIconTextView.createInstance()
        case .MutilParams: // 多参数
            paramView = ServiceCardDetailFlag(frame: CGRect(x: 0, y: 0, width: paramViewWidth, height: 0))
        case .MutilTextAndImage: // 多文本图片
            paramView = ServiceCardDetailIcon(frame: CGRect(x: 0, y: 0, width: paramViewWidth, height: 0))
        case .Shopping:     // 购物
            paramView = ServiceCardDetailShopping(frame: CGRect(x: 0, y: 0, width: paramViewWidth, height: 0))
        case .LabelTag: //文本 
            paramView = ServiceCardTextView(frame: CGRect(x: 0, y: 0, width: paramViewWidth, height: 0))
        }
        return paramView
    }
    
    func selfHeight() -> CGFloat {
        return totalHeight()
    }
    
    private func setParamView() {
        
        if let s = dataModel!.service_param as? [ServiceCellProductParamModel] {
            addParamsView(createServiceView(s))
        }
    }
    
    private func addParamsView(serviceParams: UIView?) {
        if let parmsSer = serviceParams {
            let height = getTopHeight() + paramsViewTopMargin.constant + parmsSer.frame.height + dividerTopMargin.constant + dividerBottomMargin.constant + divider.height
            
            self.frame.size.height = height
            
            paramViewHeight = parmsSer.frame.height - 5
            
            paramsView.addSubview(parmsSer)
            
            constrain(parmsSer,paramsView) {container, item in
                container.edges == item.edges
            }
        }
    }
    
    private func createReviewView(rating: Int) {
        if rating < 0  {
            review.hidden = true
            topHeight.constant = 32.5
            topView.setNeedsUpdateConstraints()
            return
        }else{
            topHeight.constant = 41
            topView.setNeedsUpdateConstraints()
        }
        
        let starRateView = CWStarRateView(frameAndImage: CGRectMake(0, 0, 60, 10), numberOfStars: 5, foreground: "review_star_yellow", background: "review_star_gray")
        topView.addSubview(starRateView)
        let score: CGFloat = CGFloat(rating) / 10
        starRateView.scorePercent = score
        
        constrain(starRateView, review) {star, review in
            star.left == review.right - 2
            star.height == starRateView.height + 1
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
