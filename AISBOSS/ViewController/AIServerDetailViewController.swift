//
//  AIServerDetailViewController.swift
//  AITrans
//
//  Created by admin on 7/8/15.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//

import Foundation
import UIKit
import Spring
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

class TableViewSourceModel : NSObject {
    var title: String?
    var type: CellType?
    var services: [Service]?
}

// MARK: UITBALEVIEW
class AIServerDetailViewController: UIViewController {
    
    // MARK: VAR
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewTags: UIView!
    
    @IBOutlet weak var labelView: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var priceView: UIView!
    
    private let TITLE_ROW: Int = 0
    private let CONTENT_ROW: Int = 1
    
    //search view by liux
    private var serviceSearchView: AIServiceSearchView!
    
    var titleArray:[String]?
    
    var titleString:String?
    
    private var tags:AOTagList?
    
    private var labelPrice: JumpNumberLabel!
    
    private var coverflowCellCache = NSMutableDictionary()
    private var horizontalCardCellCache = NSMutableDictionary()
    
    private var paramsService = NSMutableDictionary()
    
    private var dataSource : NSMutableArray = NSMutableArray()
    
    private var schemeModel: AIServiceSchemeModel?
    
    private var priceAccount = SimpleAccumulativeAccount()

    private var airTicketsViewHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelView.text = "AIServerDetailViewController.service".localized
        
        addSearchViewToParent()

        addPriceLabel()
        
        loadSchemeData()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeDateViewNotification", name: AIApplication.Notification.UIAIASINFOChangeDateViewNotification, object: nil)
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "motifyParamsNotification:", name: AIApplication.Notification.UIAIASINFOmotifyParamsNotification, object: nil)
        
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
    
    private func motifyParamsNotification(notify: NSNotification){
        
        //paramsService
        if let userINFO = notify.userInfo {
            paramsService.setValue(userINFO["key"], forKey: "key")
        }
        
    }
    
    private func settingsParams(services:Service?){
        if let serv = services{
            self.paramsService.setValue(serv.service_price?.price_show ?? "", forKey: "\(serv.service_id ?? 0)")
        }
    }
    
    private func removeParams(services:Service?){
        if let serv = services{
            // search this key and remove it.
            self.paramsService.removeObjectForKey("\(serv.service_id ?? 0)")
        }
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
    
    func loadSchemeData(){
        
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
        
        buildServicesDataSource()
        
        tableView.reloadData()
        
        labelPrice.changeFloatNumberTo(priceAccount.getTotalAmount(), format: "AIServerDetailViewController.dollarFormat".localized, numberFormat: JumpNumberLabel.createDefaultFloatCurrencyFormatter())
    }
    
    private func insertDateModel() {
        let data = TableViewSourceModel()
        data.title = "AIServerDetailViewController.day".localized
        data.type = CellType.DatePicker
        dataSource.addObject(data)
    }
    
    private func buildServicesDataSource() {
        if let scheme = self.schemeModel {
            var section:Int = 1
            for catalog in scheme.catalog_list ?? [] {
                let data =  convertSchemeToCellModel(catalog)
                
                dataSource.addObject(data)
                addPriceToAccount(catalog)
                
                addCoverFlowCellToCache(data, section: section)
                
                section = section + 1
            }
        }
    }
    
    private func addPriceToAccount(catalog: Catalog) {
        
        if catalog.service_level == ServiceLevel.Switch {
            // switch choose type service, default is unselected
            return
        }
        
        if let ser = catalog.service_list?.first {
            priceAccount.inToAccount(convertChooseItemToPriceItem(ser))
        }
    }
    
    private func addCoverFlowCellToCache(data: TableViewSourceModel, section: Int) {
        if  data.type == CellType.Coverflow {
            createCoverFlowViewCellfNotExist(data, indexPath: NSIndexPath(forRow: 0, inSection: section))
        }
    }
    
    private func generateCoverFlowCellCacheKey(section: Int) -> String {
        return "coverflow_\(section)"
    }
    
    private func convertChooseItemToPriceItem(item: Service) -> PriceItem {
        let priceItem = PriceItem()
        priceItem.id = item.service_id ?? 0
        priceItem.priceValue = Float(item.service_price?.price ?? 0)
        
        return priceItem
    }
    
    private func convertSchemeToCellModel(catalog: Catalog) -> TableViewSourceModel {
        let data =  TableViewSourceModel()
        data.title = catalog.catalog_name ?? ""
        data.type = convertServiceLevelToCellType(catalog.service_level ?? .Undefine, selectFlag : catalog.select_flag ?? 0)
        data.services = catalog.service_list
        
        return data
    }
    
    private func convertServiceLevelToCellType(serviceLevel: ServiceLevel, selectFlag : Int) -> CellType {
        switch serviceLevel {
        case .Coverflow:
            return .Coverflow
        case .Card:
            if ServiceSelectType(rawValue: selectFlag) == .Single {
                return .SignleChoose
            } else {
                return .MutiChoose
            }
        case .Switch:
            return .SwitchChoose
        case .FlightTicket:
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
        
        
        labelPrice.changeFloatNumberTo(priceAccount.getTotalAmount(), format: "AIServerDetailViewController.dollarFormat".localized, numberFormat: JumpNumberLabel.createDefaultFloatCurrencyFormatter())
    }
    
    func changeDateViewNotification(){
        self.tableView.reloadData()
    }
    
    deinit{
        coverflowCellCache.removeAllObjects()
        horizontalCardCellCache.removeAllObjects()
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
        //
        let paramServieID = self.paramsService.allKeys as! [String]
        self.view.showLoadingWithMessage("")
        Async.userInitiated {
            let dataObtainer = BDKSchemeDataObtainer()
            
            dataObtainer.submitParamsOrderServiceSchemes(paramServieID, success: { (isComplate) -> Void in
                
                self.view.dismissLoading()
                
                if isComplate == true {
                    
                    let alert = AIAlertView()
                    alert.addButton("AIAudioMessageView.close".localized, action: { () -> Void in
                         self.navigationController?.popToRootViewControllerAnimated(true)
                    })
                    alert.showCloseButton = false
                    alert.showSuccess("AIAudioMessageView.info".localized, subTitle:"AIServerDetailViewController.success".localized)
                    
                }else{
                    AIAlertView().showInfo("AIServerDetailViewController.error".localized, subTitle:"AIAudioMessageView.info".localized, closeButtonTitle: "AIAudioMessageView.close".localized, duration: 3)
                }
                
                }, fail: { (errType, errDes) -> Void in
                    
                    self.view.dismissLoading()
                    AIAlertView().showInfo("AIServerDetailViewController.error".localized, subTitle:"AIAudioMessageView.info".localized, closeButtonTitle: "AIAudioMessageView.close".localized, duration: 3)
            })
            
        }
        
    }
    
    @IBAction func addAction(sender: AnyObject) {
        
        if tags?.tags.count >= 10 {
            AIAlertView().showError("AIScanViewController.couldnt".localized, subTitle: "", closeButtonTitle: "AIAudioMessageView.close".localized, duration: 3)
            return
        }
        
        SpringAnimation.spring(0.7, animations: {
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
            let model = self.dataSource.objectAtIndex(sectionss) as! TableViewSourceModel
            for service in model.services! {
      
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
        settingsParams(model)
    }
}

extension AIServerDetailViewController : ServiceSearchViewDelegate {
    func complateWithTextView(text: String?) {
        
        if let value = text {
            
            let newAry = titleArray?.filter({ (values) -> Bool in
                
                if (values as String) == value {
                    return true
                }
                return false
            })
            
            if newAry?.count > 0 {
                AIAlertView().showError("AIServerDetailViewController.duplicate".localized, subTitle: "", closeButtonTitle: "AIAudioMessageView.close".localized, duration: 3)
                return
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.UIAIASINFOOpenAddViewNotification, object: value)
            tags?.addTag(value)
            
            titleArray?.append(value)
            
        }
    }
}

extension AIServerDetailViewController : AOTagDelegate {
    
    func tagDidRemoveTag(tag: AOTag!) {
        
    }
    
    func tagDidAddTag(tag: AOTag!) {
        
    }
    
}

extension AIServerDetailViewController: ServiceSwitchDelegate {
    func switchStateChanged(isOn: Bool, operationService: Service) {
        if isOn {
            settingsParams(operationService)
            changePrice(operationService, cancelService: nil)
        } else {
            removeParams(operationService)
            changePrice(nil, cancelService: operationService)
        }
    }
}

extension AIServerDetailViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let model =  dataSource.objectAtIndex(indexPath.section) as! TableViewSourceModel
        if indexPath.row == TITLE_ROW {
            return 50
        }
        
        if indexPath.row == CONTENT_ROW {
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
        
        
        var cell: UITableViewCell!
        
        let model =  dataSource.objectAtIndex(indexPath.section) as! TableViewSourceModel
        
        if indexPath.row == TITLE_ROW {
            cell = createTitleViewCell(model)
        } else {
            if let cellType = model.type {
                switch cellType {
                case .DatePicker:
                    cell = createDatePickerViewCell()
                case .Coverflow:
                    cell = createCoverFlowViewCellfNotExist(model, indexPath: indexPath)
                case .FilghtTicketsGroup:
                    cell = createAirTicketsViewCell(model)
                case .SwitchChoose:
                    cell = createSwitchViewCell(model, indexPath: indexPath)
                case .MutiChoose,
                     .SignleChoose:
                    cell = createHorizontalCardViewCell(model, indexPath: indexPath)
                default:
                    cell = createDefaultTableViewCell()
                }
            } else {
                cell = createDefaultTableViewCell()
            }
        }
        
        return cell        
    }
    
    func createTitleViewCell(titleModel: TableViewSourceModel) -> UITableViewCell {
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
    
    private func createCoverFlowViewCellfNotExist(model: TableViewSourceModel, indexPath: NSIndexPath) -> UITableViewCell {
        if let _  = model.title {
            let key = generateCoverFlowCellCacheKey(indexPath.section)
            if let cacheCell = coverflowCellCache.valueForKey(key) as! CoverFlowCell? {
                return cacheCell
            } else {
                let cell = CoverFlowCell.currentView()
                cell.delegate = self
                cell.carousel.type = .CoverFlow2
                cell.dataSource = model.services!
                cell.carousel.reloadData()
                coverflowCellCache.setValue(cell, forKey: key)
                return cell
            }
        }

        return createDefaultTableViewCell()
    }
    
    private func createAirTicketsViewCell(model: TableViewSourceModel) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITableCellHolderParms)
        for subview in cell?.contentView.subviews as [UIView]! {
            subview.removeFromSuperview()
        }
        
        let ticketGroupView = AirTicketGroupView()
        
        if let tickets = model.services {
            ticketGroupView.setTicketsData(tickets)
            airTicketsViewHeight = ticketGroupView.getViewHeight()
            
            cell?.contentView.addSubview(ticketGroupView)
            // add layout constrain to cell
            constrain(ticketGroupView) { viewTicketGroup in
                viewTicketGroup.left == viewTicketGroup.superview!.left + 9
                viewTicketGroup.top == viewTicketGroup.superview!.top
                viewTicketGroup.right == viewTicketGroup.superview!.right - 9
                viewTicketGroup.height == ticketGroupView.getViewHeight()
            }
            
            for tic in tickets {
                settingsParams(tic)
            }

            return cell!
        }
        
        
        return createDefaultTableViewCell()
        
    }
    
    private func createSwitchViewCell(model: TableViewSourceModel, indexPath: NSIndexPath) -> UITableViewCell {
        let services = model.services!
        let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITableCellHolderParmsModel)
        
        var switchView: SwitchServiceView!
        
        if cell?.contentView.subviews.count > 0 {
            switchView = cell?.contentView.subviews.first as! SwitchServiceView
            
        } else {
            switchView = SwitchServiceView.createSwitchServiceView()
            cell?.contentView.addSubview(switchView)
            constrain(switchView) { switchView in
                switchView.left == switchView.superview!.left
                switchView.top == switchView.superview!.top
                switchView.right == switchView.superview!.right
                switchView.height == SwitchServiceView.HEIGHT
            }
        }
        
        if let ser = services.first as Service?{
            switchView.setService(ser)
        }

        switchView.switchDelegate = self
        return cell!
    }
    
    private func createHorizontalCardViewCell(model: TableViewSourceModel, indexPath: NSIndexPath) -> UITableViewCell {
        if let _  = model.title {
            
            let key = "cardView_\(indexPath.section)"
            
            if let cacheCell = horizontalCardCellCache.valueForKey(key) as! UITableViewCell? {
                return cacheCell
            }else{
                
                let hori = HorizontalCardView(frame: CGRectMake(0, 0, self.view.width, 80))
                let cell = AITableCellHolder.currentView()
                //tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITableCellHolder)
                cell.contentView.addSubview(hori)
                if let services = model.services{
                    settingsParams(services.first)
                    if services.count > 0 {
                        hori.loadData(services, multiSelect: model.type == CellType.MutiChoose)
                    }
                }
                hori.delegate = self
                horizontalCardCellCache.setValue(cell, forKey: key)
                
                return cell
                
            }
            
        }
        
        return createDefaultTableViewCell()
    }
    
    private func createDefaultTableViewCell() -> UITableViewCell {
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


class AITableCellHolder: UITableViewCell {
    // MARK: currentView
    class func currentView()->AITableCellHolder{
        let selfView = NSBundle.mainBundle().loadNibNamed("AITableCellHolder", owner: self, options: nil).first  as! AITableCellHolder
        return selfView
    }
    
}