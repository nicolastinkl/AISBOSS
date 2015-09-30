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
    case CellTypeDate
    case CellTypeCoverflow
    case CellTypeFilght
    case CellTypeparames
    case CellTypeSignleChoose
    case CellTypeMutiChoose
    case CellDefault
}

class DataModel : NSObject {
    var title: String?
    var type: CellType?
    var content: String?
    var realModel: [AnyObject]?
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
    
    private var priceDataSource = NSMutableArray()
    
    private var coverflowDataSource = NSMutableDictionary()
    private var horiListDataSource = NSMutableDictionary()
    
    private var dataSource : NSMutableArray = NSMutableArray()
    
    private var schemeModel:AIServiceSchemeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelView.text = "Services to Your Linking"//titleString ?? ""
        
        addSearchViewToParent()
        addPriceLabel()
        
        retryNetworkingAction()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ChangeDateViewNotification", name: AIApplication.Notification.UIAIASINFOChangeDateViewNotification, object: nil)
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
        
        self.view.hideErrorView()
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
            
            for catalog in scheme.catalog_list {
                let data =  convertSchemeToCellModel(catalog as! Catalog)
                self.dataSource.addObject(data)
            }
        }
        
        self.tableView.reloadData()
    }
    
    private func insertDateModel() {
        let data =  DataModel()
        data.title = "DAY"
        data.type = CellType.CellTypeDate
        self.dataSource.addObject(data)
        
    }
    
    private func convertSchemeToCellModel(catalog: Catalog) -> DataModel {
        let data =  DataModel()
        data.title = catalog.catalog_name
        data.type = convertServiceLevelToCellType(catalog.service_level)
        data.realModel = catalog.service_list
        
        return data
    }
    
    private func convertServiceLevelToCellType(serviceLevel: Int) -> CellType {
        switch serviceLevel {
        case 1:
            return .CellTypeCoverflow
        case 2:
            return .CellTypeSignleChoose
        case 3:
            return .CellTypeparames
        case 4:
            return .CellTypeFilght
        case 5:
            return .CellTypeMutiChoose
        default:
            return .CellDefault
        }
        
    }
    
    func changePriceToNew(model:chooseItemModel){
        
        var indexPre = 0
        var replace = false
        priceDataSource.enumerateObjectsUsingBlock { (modelPre, index, error) -> Void in
            let preModel = modelPre as! chooseItemModel
            if model.scheme_id == preModel.scheme_id {
                //相同的类目下的单项选项,所以替换为主
                indexPre = index
                replace = true
            }
        }
        
        if replace {
            priceDataSource.removeObjectAtIndex(indexPre)
        }
        priceDataSource.addObject(model)
        
        var priceTotal:Float = 0
        priceDataSource.enumerateObjectsUsingBlock { (modelPre, index, error) -> Void in
            
            let preModel = modelPre as! chooseItemModel
            priceTotal += preModel.scheme_item_price
        }
        
        labelPrice.changeFloatNumberTo(priceTotal, format: "$%@", numberFormat: JumpNumberLabel.createDefaultFloatCurrencyFormatter())
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
//        self.scrollView.addSubview(tags!)
//        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, 180)
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
    
    func closeCurrentSectionAction(sender: AnyObject) {
        //处理删除当前section的问题
        
        let button = sender as! UIButton
        let cell = button.superview?.superview as! UITableViewCell
        let sectionss = self.tableView.indexPathForCell(cell)?.section
        if let s = sectionss {
            //删除对应的价格
            
            let model = self.dataSource.objectAtIndex(s) as! DataModel
            for custom in model.realModel as! [ServiceList]{
                
                var indexPre:Int = 0
                var replace = false

                priceDataSource.enumerateObjectsUsingBlock({ (modelPre, index, error) -> Void in
                    let preModel = modelPre as! chooseItemModel
                    if custom.service_id == preModel.scheme_id {
                        //相同的类目下的单项选项,所以替换为主
                        indexPre = index
                        replace = true
                    }
                    
                })
                
                if replace {
                    priceDataSource.removeObjectAtIndex(indexPre)
                    let modelP = chooseItemModel()
                    modelP.scheme_id = 0
                    modelP.scheme_item_price = 0
                    self.changePriceToNew(modelP)
                }
            }
            
            self.dataSource.removeObjectAtIndex(s)
            self.tableView.reloadData()
        }
        
        
        
        /*
        let titl = tag.tTitle
        
        dataSource.enumerateObjectsUsingBlock { (object, index, sd) -> Void in
        let fitlerModel = object as! DataModel
        
        if fitlerModel.title == titl {
        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.UIAIASINFOOpenRemoveViewNotification, object: titl)
        
        self.dataSource.removeObjectAtIndex(index)
        self.tableView.reloadData()
        return
        }
        }
        */
        
    }
}

extension AIServerDetailViewController:AISchemeProtocol{
    func chooseItem(model: chooseItemModel) {
        self.changePriceToNew(model)
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
            
            /*
            let data =  DataModel()
            data.title = value
            data.type = CellType.CellTypeCoverflow
            self.dataSource.insertObject(data, atIndex: 1)
            self.tableView.reloadData()*/
            
        }
    }
}

extension AIServerDetailViewController : AOTagDelegate{

    func tagDidRemoveTag(tag: AOTag!) {
        
        /*
        let titl = tag.tTitle
        dataSource.enumerateObjectsUsingBlock { (object, index, sd) -> Void in
            let fitlerModel = object as! DataModel
            
            if fitlerModel.title == titl {
                NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.UIAIASINFOOpenRemoveViewNotification, object: titl)
                
                self.dataSource.removeObjectAtIndex(index)
                self.tableView.reloadData()
                return
            }
        }        
        */
        
        
        
        /*
        let newArray = dataSource.filter { (fitlerModel) -> Bool in
            if fitlerModel.title == titl {
                return true
            }
            return false
        }
        
        if newArray.count > 0 {
            
            var newMuta = NSMutableArray(array: dataSource)
            
            self.dataSource.removeAtIndex(newMuta.indexOfObject(newArray.first!))
            
            self.tableView.reloadData()
        }
        */
    }
    
    func tagDidAddTag(tag: AOTag!) {
        
    }
    
}

extension AIServerDetailViewController: ServiceSwitchDelegate{
    func switchStateChanged(isOn: Bool, model: chooseItemModel) {
        if isOn {
            self.changePriceToNew(model)
            
        }else{
            model.scheme_item_price = 0
            self.changePriceToNew(model)
            
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
            case CellType.CellTypeDate:
                return 270
            case CellType.CellTypeCoverflow:
                return 190
            case CellType.CellTypeFilght:
                return 150
            case CellType.CellTypeparames:
                return 100
            case CellType.CellTypeMutiChoose:
                return 80
            case CellType.CellTypeSignleChoose:
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
        
        let model =  dataSource.objectAtIndex(section) as! DataModel
        if model.type! == CellType.CellTypeFilght{
            let modelArray = model.realModel
            return 1 + modelArray!.count
        }
        
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if dataSource.count > indexPath.section{
            let model =  dataSource.objectAtIndex(indexPath.section) as! DataModel
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITitleServiceDetailCell) as! AITitleServiceDetailCell
                cell.title.text = model.title ?? ""
                
                switch model.type! {
                case CellType.CellTypeDate:
                    cell.closeButton.hidden = true
                case CellType.CellTypeCoverflow:
                    cell.closeButton.hidden = false
                case CellType.CellTypeFilght:
                    cell.closeButton.hidden = false
                case CellType.CellTypeparames:
                    cell.closeButton.hidden = true
                case CellType.CellTypeMutiChoose:
                    cell.closeButton.hidden = false
                case CellType.CellTypeSignleChoose:
                    cell.closeButton.hidden = false
                default:
                    break
                }
                cell.closeButton.addTarget(self, action: "closeCurrentSectionAction:", forControlEvents: UIControlEvents.TouchUpInside)
               
                return cell
                
            }else{
                
                // TODO: 日期
                if model.type == CellType.CellTypeDate {
                    let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AISDDateCell) as! AISDDateCell
                    
                    let arrayPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                    let path = arrayPath.first ?? ""
                    let componentPath = path.stringByAppendingPathComponent("CalendarImage.png")
                    
                    let image = UIImage(contentsOfFile: componentPath)
                    if let im = image{
                        cell.dateImageView.image = im
                    }else{
                        cell.dateImageView.image = UIImage(named: "CalendarImage")
                    }
                    return cell
                }
                
                
//                let modelArray = model.realModel as! NSArray
                
                let ls = model.realModel as! Array<ServiceList>
                
                // TODO: 卡片信息
                if  model.type == CellType.CellTypeCoverflow {
                    
                    if let _  = model.title {
                        let key = "coverflow_\(indexPath.section)"
                        if let cacheCell = coverflowDataSource.valueForKey(key) as! AISDSubDetailCell? {
                            return cacheCell
                        }else{
                            let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AISDSubDetailCell) as! AISDSubDetailCell
                            cell.delegate = self
                            cell.carousel.type = .CoverFlow2
                            cell.dataSource = ls
                            cell.carousel.reloadData()
                            coverflowDataSource.setValue(cell, forKey: key)
                            return cell
                        }
                    }
                }
                
                // TODO: 机票信息
                if  model.type == CellType.CellTypeFilght { 
                    
                    let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITableCellHolderParms)
                    for subview in cell?.contentView.subviews as [UIView]! {
                        subview.removeFromSuperview()
                    }
                    
                    let ticketGroupView = AirTicketGroupView()
                    
                    let tickets = ls // modelArray as! [ServiceList]

                    ticketGroupView.setTicketsData(tickets)
                    
                    cell?.contentView.addSubview(ticketGroupView)
                    layout(ticketGroupView) { viewTic in
                        viewTic.left == viewTic.superview!.left + 9
                        viewTic.top == viewTic.superview!.top
                        viewTic.right == viewTic.superview!.right - 9
                        viewTic.height == ticketGroupView.getViewHeight()
                    }
                    
                    return cell!
                    
                }
                
                // TODO: 开关信息
                if  model.type == CellType.CellTypeparames {
                    
                    let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITableCellHolderParmsModel)
                     
                    if cell?.contentView.subviews.count > 0{
                        
                        let switchView = cell?.contentView.subviews.last as! SwitchServiceView                        
                        switchView.reloadData()
                        if ls.count > 0 && ls.count > indexPath.row {
                            switchView.setService(ls[indexPath.row])
                        }
                        switchView.switchDelegate = self
                        
                    }else{
                        
                        let switchView = SwitchServiceView.createSwitchServiceView()
                        cell?.contentView.addSubview(switchView)
                        layout(switchView) { switchView in
                            switchView.left == switchView.superview!.left
                            switchView.top == switchView.superview!.top
                            switchView.right == switchView.superview!.right
                            switchView.height == SwitchServiceView.HEIGHT
                        }
                        if ls.count > 0 && ls.count > indexPath.row {
                            switchView.setService(ls[indexPath.row])
                        }
                        
                        switchView.reloadData()
                        switchView.switchDelegate = self
                    }
                    
                    return cell!
                }
                
                // TODO: 多选 or 单选
                if model.type == CellType.CellTypeMutiChoose ||  model.type == CellType.CellTypeSignleChoose {
                    
                    if let _  = model.title {
                        
                        let key = "cardView_\(indexPath.section)"
                                                                        
                        if let cacheCell = horiListDataSource.valueForKey(key) as! UITableViewCell? {
                            return cacheCell
                        }else{
                            
                            var hori : HorizontalCardView
                            let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITableCellHolder)
                            if cell?.contentView.subviews.count > 0{
                                hori = cell?.contentView.subviews.first as! HorizontalCardView
                            }else{
                                hori = HorizontalCardView(frame: CGRectMake(0, 0, self.view.width, 80))
                                cell?.contentView.addSubview(hori)
                            }
                            if ls.count > 0 {
                                hori.loadData(ls, multiSelect: model.type == CellType.CellTypeMutiChoose)
                            }
                            
                            hori.delegate = self
                            
                            horiListDataSource.setValue(cell, forKey: key)
                            
                            return cell!
                            
                        }
                    
                    }
                    
                    
                }
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

class AISDSubDetailCell: UITableViewCell ,iCarouselDataSource, iCarouselDelegate{
    
    @IBOutlet weak var carousel: iCarousel!
    
    @IBOutlet weak var title: UILabel!
    
    var delegate : AISchemeProtocol?
    
    var dataSource:[ServiceList]?
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int
    {
        if let daSource = dataSource {
            return daSource.count
        }
        return 0
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, var reusingView view: UIView!) -> UIView!
    {        
        //create new view if no view is available for recycling
        if (view == nil)
        {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later           
            let coverView = UICoverFlowView.currentView()
            
            
            if let data = dataSource {
                
                let comt:ServiceList = data[index] as ServiceList
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
    
    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
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
            let ser:ServiceList = dataSour[carousel.currentItemIndex]
            
            let model = chooseItemModel()
            model.scheme_id = ser.service_id
            model.scheme_item_price = ser.service_price.price.floatValue
      //      model.scheme_item_quantity = Int(ser.service_price.billing_mode)
            delegate?.chooseItem(model)
        }
        
    }
    
}

class AISDFightCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
}

class AISDParamsCell: UITableViewCell
{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var descri: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var line: UILabel!
    
    @IBAction func exchangeButton(sender: AnyObject) {
        let button = sender as! UIButton
        if let som = button.associatedName {
            //有值
            if som == "1"{
                button.associatedName = "0"
                button.setImage(UIImage(named: "sd_on"), forState: UIControlState.Normal)
            }else{
                button.associatedName = "1"
                button.setImage(UIImage(named: "sd_off"), forState: UIControlState.Normal)
            }
            
        }else{
            button.associatedName = "1"
            button.setImage(UIImage(named: "sd_off"), forState: UIControlState.Normal)
        }
        
        
    }
    
    
}