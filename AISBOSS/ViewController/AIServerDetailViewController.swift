//
//  AIServerDetailViewController.swift
//  AITrans
//
//  Created by admin on 7/8/15.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//

import Foundation
import UIKit
import AISpring
import AIAlertView
import Cartography

enum CellType: Int {
    case Default
    case Coverflow
    case DatePicker
    case FilghtTicketsGroup
    case SwitchChoose
    case SignleChoose
    case MutiChoose
}

class DataModel : NSObject {
    var title: String?
    var type: CellType?
    var content: String?
    var realModel: [Service]?
    var sectionID:Int?
}

// MARK: UITBALEVIEW
class AIServerDetailViewController: UIViewController {
    
    // MARK: VAR
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewTags: UIView!
    
    @IBOutlet weak var labelView: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var priceView: UIView!
    
    //search view by liux
    private var serviceSearchView:AIServiceSearchView!
    
    var titleArray:[String]?
    
    var titleString:String?
    
    private var tags:AOTagList?
    
    private var labelPrice: JumpNumberLabel!
    /// cell 里面内容左右间距
    private var cellPadding:Float = 9.0
    
    private var coverflowDataSource = NSMutableDictionary()
    private var horiListDataSource = NSMutableDictionary()
    
    private var dataSource : NSMutableArray = NSMutableArray()
    
    private var schemeModel:AIServiceSchemeModel?
    
    private var priceAccount = SimpleAccumulativeAccount()

    private var airTicketsViewHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelView.text = "Services to Your Liking"//titleString ?? ""
        
        addSearchViewToParent()

        addPriceLabel()
        
        retryNetworkingAction()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ChangeDateViewNotification", name: AIApplication.Notification.UIAIASINFOChangeDateViewNotification, object: nil)
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    private func addSearchViewToParent() {
        serviceSearchView = AIServiceSearchView.currentView()
        serviceSearchView.setWidth(self.view.width)
        serviceSearchView.setHeight(self.view.height)
        serviceSearchView.setTop(self.view.height)
        serviceSearchView.alpha = 0
        serviceSearchView.searchDelegate = self
        self.view.addSubview(serviceSearchView)
    }
    
    private func addPriceLabel() {
        labelPrice = JumpNumberLabel(frame: CGRectMake(0, 0, 200, 40))
        
        self.priceView.addSubview(labelPrice)
        labelPrice.textColor = UIColor.whiteColor()
        labelPrice.setLeft(self.view.width/2 - labelPrice.width/2)
        labelPrice.textAlignment = NSTextAlignment.Center
        labelPrice.font = UIFont.systemFontOfSize(23)
        labelPrice.setTop(5)
    }
    
    func retryNetworkingAction(){
        
//        self.view.hideErrorView()
        self.view.showProgressViewLoading()
        Async.userInitiated {
            let dataObtainer: SchemeDataObtainer = BDKSchemeDataObtainer()
            dataObtainer.getServiceSchemes(223, success: { (responseData) -> Void in
                
                self.view.hideProgressViewLoading()
                self.schemeModel = responseData
                self.reloadInputData()
                
                }) { (errType, errDes) -> Void in
                    print(errDes)
                    self.view.hideProgressViewLoading()
                    self.view.showErrorView()
            }
        }
    }
    
    func reloadInputData() {
        
        insertDateModel()
        
        if let scheme = self.schemeModel {
            var section:Int = 1
            for catalog in scheme.catalog_list ?? []{
                let data =  convertSchemeToCellModel(catalog)
                self.dataSource.addObject(data)
                caculateDefaultServicesTotalPrice(catalog)
                
                // TODO: Init the Coverflow Views.
                // TODO: 卡片信息
                if  data.type == CellType.Coverflow {
                    let cell = createCoverFlowViewCell(data, indexPath: NSIndexPath(forRow: 0, inSection: section))
                    let key = "coverflow_\(section)"
                    coverflowDataSource.setValue(cell, forKey: key)
                    print(key)
                }
                
                section = section + 1
            }
        }
        
        self.tableView.reloadData()
        labelPrice.changeFloatNumberTo(priceAccount.getTotalAmount(), format: "$%@", numberFormat: JumpNumberLabel.createDefaultFloatCurrencyFormatter())
    }
    
    private func insertDateModel() {
        let data =  DataModel()
        data.title = "DAY"
        data.type = CellType.DatePicker
        self.dataSource.addObject(data)
        
    }
    
    private func caculateDefaultServicesTotalPrice(catalog: Catalog) {
        
        if catalog.service_level == 3 {
            // switch choose type service, default is unselected
            return
        }
        
        if let ser = catalog.service_list?.first {
            priceAccount.inToAccount(convertChooseItemToPriceItem(ser))
        }

    }
    
    private func convertChooseItemToPriceItem(item: Service) -> PriceItem {
        let priceItem = PriceItem()
        priceItem.id = item.service_id ?? 0
        priceItem.priceValue = Float(item.service_price?.price ?? 0)
        
        return priceItem
    }
    
    private func convertSchemeToCellModel(catalog: Catalog) -> DataModel {
        let data =  DataModel()
        data.title = catalog.catalog_name ?? ""
        data.type = convertServiceLevelToCellType(catalog.service_level ?? 0,selectFlag : catalog.select_flag ?? 0)
        data.realModel = catalog.service_list
        
        return data
    }
    
    private func convertServiceLevelToCellType(serviceLevel: Int,selectFlag : Int) -> CellType {
        switch serviceLevel {
        case 1:
            return .Coverflow
        case 2:
            if selectFlag == 1{
                return .SignleChoose
            }
            else {
                return .MutiChoose
            }
        case 3:
            return .SwitchChoose
        case 4:
            return .FilghtTicketsGroup
        default:
            return .Default
        }
    }
    
    private func changePrice(choosedService:Service?, cancelService: Service?){
        
        if choosedService != nil {
            priceAccount.inToAccount(convertChooseItemToPriceItem(choosedService!))
        }
        
        if cancelService != nil {
            priceAccount.outOfAccount(convertChooseItemToPriceItem(cancelService!))
        }
        
        
        labelPrice.changeFloatNumberTo(priceAccount.getTotalAmount(), format: "$%@", numberFormat: JumpNumberLabel.createDefaultFloatCurrencyFormatter())
    }
    
    func ChangeDateViewNotification(){
        self.tableView.reloadData()
    }
    
    deinit{
        coverflowDataSource.removeAllObjects()
        horiListDataSource.removeAllObjects()
        dataSource.removeAllObjects()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AIApplication.Notification.UIAIASINFOChangeDateViewNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // TAGS
        tags = AOTagList(frame: CGRectMake(0, 0, self.scrollView.width, 180))
        tags?.delegateTag = self
        
        if let array = titleArray {
            for titleItem in array{
                tags?.addTag(titleItem ?? "")
            }
        }
    }
    
    /*!
    提交订单
    */
    @IBAction func submitOrderAction(sender: AnyObject) {
        
    }
    
    @IBAction func addAction(sender: AnyObject) {
        
        if tags?.tags.count >= 10 {
            AIAlertView().showError("提示", subTitle: "不能超过10个颜色气泡", closeButtonTitle: "关闭", duration: 3)
            return
        }
        
        spring(0.7, animations: {
            self.serviceSearchView.setTop(0)
            self.serviceSearchView.alpha = 1
        })
        
        serviceSearchView.searchTextField.becomeFirstResponder()
        serviceSearchView.clearSearchResult()
        serviceSearchView.setInitViewAttr()
        
        //NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.UIAIASINFOOpenAddViewNotification, object: nil)
        //self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func cancelServiceSectionAction(sender: AnyObject) {
        //处理删除当前section的问题
        let button = sender as! UIButton
        let cell = button.superview?.superview as! UITableViewCell
        if let sectionss = self.tableView.indexPathForCell(cell)?.section {
            //删除对应的价格
            let model = self.dataSource.objectAtIndex(sectionss) as! DataModel
            for service in model.realModel! {
      
                changePrice(nil, cancelService: service)
            }
            
            self.dataSource.removeObjectAtIndex(sectionss)
            self.tableView.reloadData()

        }
        
    }
}

// MARK: AISchemeProtocol
extension AIServerDetailViewController: AISchemeProtocol {
    func chooseItem(model: Service?, cancelItem: Service?) {
        changePrice(model, cancelService: cancelItem)
    }
}

extension AIServerDetailViewController : serviceSearchViewDelegate {
    func complateWithTextView(text: String?) {
        
        if let value = text {
            
            let newAry = titleArray?.filter({ (values) -> Bool in
                
                if (values as String) == value {
                    return true
                }
                return false
            })
            
            if newAry?.count > 0 {
                AIAlertView().showError("提示", subTitle: "不能添加重复便签", closeButtonTitle: "关闭", duration: 3)
                return
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.UIAIASINFOOpenAddViewNotification, object: value)
            tags?.addTag(value)
            
            titleArray?.append(value)
            
        }
    }
}

extension AIServerDetailViewController : AOTagDelegate{
    
    func tagDidRemoveTag(tag: AOTag!) {
        
    }
    
    func tagDidAddTag(tag: AOTag!) {
        
    }
    
}

extension AIServerDetailViewController: ServiceSwitchDelegate{
    func switchStateChanged(isOn: Bool, operationService: Service) {
        if isOn {
            changePrice(operationService, cancelService: nil)
        } else {
            changePrice(nil, cancelService: operationService)
        }
    }
}

extension AIServerDetailViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let model =  dataSource.objectAtIndex(indexPath.section) as! DataModel
        if indexPath.row == 0 {
            return 50
        }
        
        if indexPath.row == 1 {
            switch model.type! {
            case .DatePicker:
                return 270
            case .Coverflow:
                return 190
            case .FilghtTicketsGroup:
                return airTicketsViewHeight
            case .SwitchChoose:
                return 100
            case .MutiChoose:
                return 80
            case .SignleChoose:
                return 80
            default:
                return 0
            }
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let titleNumber = 1
        let cellNumber = 1
        return titleNumber + cellNumber
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let TITLE_ROW: Int = 0
        
        var cell: UITableViewCell!
        
        let model =  dataSource.objectAtIndex(indexPath.section) as! DataModel
        
        if indexPath.row == TITLE_ROW {
            cell = createTitleViewCell(model)
        } else {
            if let cellType = model.type {
                switch cellType {
                case .DatePicker:
                    cell = createDatePickerViewCell()
                case .Coverflow:
                    cell = createCoverFlowViewCell(model, indexPath: indexPath)
                case .FilghtTicketsGroup:
                    cell = createAirTicketsViewCell(model)
                case .SwitchChoose:
                    let realModel = model.realModel!
                    cell = createSwitchViewCell(realModel, indexPath: indexPath)
                case .MutiChoose,
                .SignleChoose:
                    cell = createHorizontalCardViewCell(model, indexPath: indexPath)
                default:
                    cell = UITableViewCell()
                    
                }
            } else {
                cell = UITableViewCell()
            }
        }
        
        return cell        
    }
    
    func createTitleViewCell(titleModel: DataModel) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITitleServiceDetailCell) as! AITitleServiceDetailCell
        cell.title.text = titleModel.title ?? ""
        
        switch titleModel.type! {
        case .DatePicker:
            cell.closeButton.hidden = true
        case .Coverflow:
            cell.closeButton.hidden = false
        case .FilghtTicketsGroup:
            cell.closeButton.hidden = false
        case .SwitchChoose:
            cell.closeButton.hidden = true
        case .MutiChoose:
            cell.closeButton.hidden = false
        case .SignleChoose:
            cell.closeButton.hidden = false
        default:
            break
        }
        cell.closeButton.addTarget(self, action: "cancelServiceSectionAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    private func createDatePickerViewCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AISDDateCell) as! AISDDateCell
        
        let arrayPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let path = arrayPath.first ?? ""
        let componentPath = path.stringByAppendingString("CalendarImage.png")
        
        let image = UIImage(contentsOfFile: componentPath)
        if let im = image{
            cell.dateImageView.image = im
        }else{
            cell.dateImageView.image = UIImage(named: "CalendarImage")
        }
        return cell
    }
    
    private func createCoverFlowViewCell(model: DataModel, indexPath: NSIndexPath) -> UITableViewCell {
        if let _  = model.title {
            let key = "coverflow_\(indexPath.section)"
            if let cacheCell = coverflowDataSource.valueForKey(key) as! CoverFlowCell? {
                return cacheCell
            } else {
                let cell = CoverFlowCell.currentView()
                cell.delegate = self
                cell.carousel.type = .CoverFlow2
                cell.dataSource = model.realModel!
                cell.carousel.reloadData()
                coverflowDataSource.setValue(cell, forKey: key)
                return cell
            }
        }

        return UITableViewCell()
    }
    
    private func createAirTicketsViewCell(model: DataModel) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITableCellHolderParms)
        for subview in cell?.contentView.subviews as [UIView]! {
            subview.removeFromSuperview()
        }
        
        let ticketGroupView = AirTicketGroupView()
        
        if let tickets = model.realModel {
            ticketGroupView.setTicketsData(tickets)
            airTicketsViewHeight = ticketGroupView.getViewHeight()
            
            cell?.contentView.addSubview(ticketGroupView)
            layout(ticketGroupView) { viewTic in
                viewTic.left == viewTic.superview!.left + 9
                viewTic.top == viewTic.superview!.top
                viewTic.right == viewTic.superview!.right - 9
                viewTic.height == ticketGroupView.getViewHeight()
            }
            
            return cell!
        }
        
        
        return UITableViewCell()
        
    }
    
    private func createSwitchViewCell(services: [Service], indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITableCellHolderParmsModel)
        
        var switchView: SwitchServiceView!
        
        if cell?.contentView.subviews.count > 0 {
            switchView = cell?.contentView.subviews.last as! SwitchServiceView
            
        }else{
            
            switchView = SwitchServiceView.createSwitchServiceView()
            cell?.contentView.addSubview(switchView)
            layout(switchView) { switchView in
                switchView.left == switchView.superview!.left
                switchView.top == switchView.superview!.top
                switchView.right == switchView.superview!.right
                switchView.height == SwitchServiceView.HEIGHT
            }
        }
        
        if let ser = services.last as Service?{
            switchView.setService(ser)
        }
        switchView.reloadData()
        switchView.switchDelegate = self
        return cell!
    }
    
    private func createHorizontalCardViewCell(model: DataModel, indexPath: NSIndexPath) -> UITableViewCell {
        if let _  = model.title {
            
            let key = "cardView_\(indexPath.section)"
            
            if let cacheCell = horiListDataSource.valueForKey(key) as! UITableViewCell? {
                return cacheCell
            }else{
                
                let hori = HorizontalCardView(frame: CGRectMake(0, 0, self.view.width, 80))
                let cell = AITableCellHolder.currentView() //tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITableCellHolder)
                cell.contentView.addSubview(hori)
                if let services = model.realModel{
                    if services.count > 0 {
                        hori.loadData(services, multiSelect: model.type == CellType.MutiChoose)
                    }
                }
                hori.delegate = self
                horiListDataSource.setValue(cell, forKey: key)
                
                return cell
                
            }
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        if  //Day
        if indexPath.section == 0 {
            let menuViewController = self.storyboard?.instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AICalendarViewController) as! AICalendarViewController
            menuViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            menuViewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
            self.showDetailViewController(menuViewController, sender: self)
        }
    }
}

// MARK: CELL

class AITitleServiceDetailCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
}

class AISDDateCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dateImageView: UIImageView!
}

class CoverFlowCell: UITableViewCell ,iCarouselDataSource, iCarouselDelegate {
    
    class func currentView()-> CoverFlowCell {
        let selfView = NSBundle.mainBundle().loadNibNamed("AICoverFlowCell", owner: self, options: nil).first  as! CoverFlowCell
        return selfView
    }
    
    @IBOutlet weak var carousel: iCarousel!
    
    @IBOutlet weak var title: UILabel!
    
    var delegate : AISchemeProtocol?
    
    var dataSource:[Service]?
    
    private var oldChoosedItem: Service?
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        if let daSource = dataSource {
            return daSource.count
        }
        return 0
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, var reusingView view: UIView!) -> UIView! {
        //create new view if no view is available for recycling
        if (view == nil) {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            let coverView = UICoverFlowView.currentView()
            
            
            if let data = dataSource {
                
                let comt:Service = data[index] as Service
                coverView.fillDataWithModel(comt)
                view = coverView
            }
            
        }
        /*
        //ONE:
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOffset = CGSizeMake(0, 0)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 4
        // Settings shadow.
        
        //TWO:
        let path = UIBezierPath()
        
        let width:CGFloat = view.bounds.size.width
        let height:CGFloat = view.bounds.size.height
        let x:CGFloat = view.bounds.origin.x
        let y:CGFloat = view.bounds.origin.y
        let addWH:CGFloat = 10
        
        
        let topLeft      = view.bounds.origin
        let topMiddle = CGPointMake(x+(width/2),y-addWH)
        let topRight     = CGPointMake(x+width,y)
        let rightMiddle = CGPointMake(x + width + addWH,y + (height/2))
        
        let bottomRight  = CGPointMake(x+width,y+height)
        let bottomMiddle = CGPointMake(x+(width/2),y+height+addWH)
        let bottomLeft   = CGPointMake(x,y+height)
        let leftMiddle = CGPointMake(x - addWH,y + (height/2))
        
        path.moveToPoint(topLeft)
        
        //添加2个二元曲线
        path.addQuadCurveToPoint(topRight, controlPoint: topMiddle)
        path.addQuadCurveToPoint(bottomRight, controlPoint: rightMiddle)
        path.addQuadCurveToPoint(bottomLeft, controlPoint: bottomMiddle)
        path.addQuadCurveToPoint(topLeft, controlPoint: leftMiddle)
        
        //设置阴影路径
        view.layer.shadowPath = path.CGPath
        */
        return view
    }
    
    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat{
        if (option == .Spacing){
            return value * 0.65
        }
        
        if (option == .Wrap){
            return CGFloat(true)
        }
        return value
    }
    
    /*!
    选中当前Coverflow时的价格处理
    */
    func carouselCurrentItemIndexDidChange(carousel: iCarousel!) {
        if let dataSour = dataSource {
            let ser:Service = dataSour[carousel.currentItemIndex]
            delegate?.chooseItem(ser, cancelItem: oldChoosedItem)
            
            oldChoosedItem = ser
        }
    }
}


class AITableCellHolder: UITableViewCell {
    // MARK: currentView
    class func currentView()->AITableCellHolder{
        let selfView = NSBundle.mainBundle().loadNibNamed("AITableCellHolder", owner: self, options: nil).first  as! AITableCellHolder
        return selfView
    }
    
}