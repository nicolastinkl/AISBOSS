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

enum cellType:Int{
    case cellTypeDate = 0
    case cellTypeCoverflow = 1
    case cellTypeFilght = 2
    case cellTypeparames = 3
    case cellTypeMutiChoose = 4
}

class dataModel : NSObject{
    var title:String?
    var type:cellType?  //0 date / 1 conflow   2/filght  3/ parames
    var content:String?
    var placeHolderModel:AnyObject?
}

// MARK: UITBALEVIEW
class AIServerDetailViewController: UIViewController {
    
    // MARK: VAR
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var viewTags: UIView!
    
    @IBOutlet weak var labelView: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!

    //search view by liux
    private var serviceSearchView:AIServiceSearchView!
    
    var titleArray:[String]?
    
    var titleString:String?
    
    private var tags:AOTagList?
    
    /// cell 里面内容左右间距
    private var cellPadding:Float = 9.0
    
    private lazy var dataSource : NSMutableArray = {
        var data =  dataModel()
        data.title = "DAY"
        data.type = cellType.cellTypeDate
        return NSMutableArray(array: [data])
        }()
    
    private var schemeModel:AIServiceSchemeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelView.text = titleString ?? ""
        
        if let arrrays = titleArray {
            for item in arrrays {
                let data =  dataModel()
                data.title = item
                data.type = cellType.cellTypeCoverflow
                //self.dataSource.insertObject(data, atIndex: 1)
            }
        }
        
        //init searchView
        serviceSearchView = AIServiceSearchView.currentView()
        serviceSearchView.setWidth(self.view.width)
        serviceSearchView.setHeight(self.view.height)
        serviceSearchView.setTop(self.view.height)
        serviceSearchView.alpha = 0
        serviceSearchView.searchDelegate = self
        self.view.addSubview(serviceSearchView)
        
        Async.userInitiated {
            AIDetailNetService().requestListServices(1) { (asSchemeModel) -> Void in
                self.schemeModel = asSchemeModel
                self.reloadInputData()
            }
        }
 
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ChangeDateViewNotification", name: AIApplication.Notification.UIAIASINFOChangeDateViewNotification, object: nil)
        
    }
    
    func reloadInputData() {
        
        if let scheme = self.schemeModel {
            NSArray(array: scheme.catalog_list).enumerateObjectsUsingBlock({ (dataObject, index, bol) -> Void in
                /// 1-轮播 2-平铺 3-开关 4-单个（机票）
                
                do {
                    
                    let catalog:CatalogList = try CatalogList(dictionary: dataObject as! [NSObject : AnyObject])
                    let data =  dataModel()
                    data.title = catalog.catalog_name
                    switch catalog.service_level.integerValue {
                    case 1:
                        data.type = cellType.cellTypeCoverflow
                        break
                    case 2:
                        data.type = cellType.cellTypeMutiChoose
                        break
                    case 3:
                        data.type = cellType.cellTypeparames
                        break
                    case 4:
                        data.type = cellType.cellTypeFilght
                        break
                    default:
                        break
                    }
                    data.placeHolderModel = catalog.service_list
                    self.dataSource.addObject(data)
                }
                catch{
                }
                
            })
            
//            let arrayList = scheme.catalog_list as [CatalogList]
//            for catalog in arrayList {
//                
//            }
        }
        
        
        self.tableView.reloadData()
    }
    
    func ChangeDateViewNotification(){
        self.tableView.reloadData()
    }
    
    deinit{
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
            self.dataSource.removeObjectAtIndex(s)
            self.tableView.reloadData()
        }
     
        /*
        let titl = tag.tTitle
        
        dataSource.enumerateObjectsUsingBlock { (object, index, sd) -> Void in
        let fitlerModel = object as! dataModel
        
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
            let data =  dataModel()
            data.title = value
            data.type = cellType.cellTypeCoverflow
            self.dataSource.insertObject(data, atIndex: 1)
            self.tableView.reloadData()
        }
    }
}

extension AIServerDetailViewController : AOTagDelegate{

    func tagDidRemoveTag(tag: AOTag!) {
        let titl = tag.tTitle
        
        dataSource.enumerateObjectsUsingBlock { (object, index, sd) -> Void in
            let fitlerModel = object as! dataModel
            
            if fitlerModel.title == titl {
                NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.UIAIASINFOOpenRemoveViewNotification, object: titl)
                
                self.dataSource.removeObjectAtIndex(index)
                self.tableView.reloadData()
                return
            }
        }
        
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

extension AIServerDetailViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let model =  dataSource.objectAtIndex(indexPath.section) as! dataModel
        if indexPath.row == 0 {
            return 50
        }
        
        if indexPath.row == 1 {
            switch model.type! {
            case cellType.cellTypeDate:
                return 270
            case cellType.cellTypeCoverflow:
                return 220
            case cellType.cellTypeFilght:
                return 260
            case cellType.cellTypeparames:
                return 100
            case cellType.cellTypeMutiChoose:
                return 80
            }
        }
        
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if dataSource.count > indexPath.section{
            let model =  dataSource.objectAtIndex(indexPath.section) as! dataModel
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITitleServiceDetailCell) as! AITitleServiceDetailCell
                cell.title.text = model.title ?? ""
                
                switch model.type! {
                case cellType.cellTypeDate:
                    cell.closeButton.hidden = true
                case cellType.cellTypeCoverflow:
                    cell.closeButton.hidden = false
                case cellType.cellTypeFilght:
                    cell.closeButton.hidden = false
                case cellType.cellTypeparames:
                    cell.closeButton.hidden = true
                case cellType.cellTypeMutiChoose:
                    cell.closeButton.hidden = false
                }
                cell.closeButton.addTarget(self, action: "closeCurrentSectionAction:", forControlEvents: UIControlEvents.TouchUpInside)
               
                return cell
            }else{
                
                if model.type == cellType.cellTypeDate {
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
                
                if  model.type == cellType.cellTypeCoverflow {
                    let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AISDSubDetailCell) as! AISDSubDetailCell
                    cell.carousel.type = .CoverFlow2
                    
                    let list = NSMutableArray()
                    let modelArray = model.placeHolderModel as! NSMutableArray
                    modelArray.enumerateObjectsUsingBlock({ (modelObj, index, bol) -> Void in
                        do{
                            let model = try ServiceList(dictionary: modelObj as! [NSObject : AnyObject])
                            list.addObject(model)
                            
                        }catch{
                        }
                    })
                    
                    let ls = NSArray(array: list) as! [ServiceList]
                    cell.dataSource = ls
                    cell.carousel.reloadData()
                    return cell
                }
                
                if  model.type == cellType.cellTypeFilght { 
                    
                    let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITableCellHolderParms)
                    for subview in cell?.contentView.subviews as [UIView]! {
                        subview.removeFromSuperview()
                    }
                    
                    let ticketGroupView = AirTicketGroupView()
                    cell?.contentView.addSubview(ticketGroupView)
                    layout(ticketGroupView) { viewTic in
                        viewTic.left == viewTic.superview!.left + 9
                        viewTic.top == viewTic.superview!.top
                        viewTic.right == viewTic.superview!.right - 9
                        viewTic.height == 280
                    }
                    ticketGroupView.setTicketsData()
                    
                    return cell!
                    
                }
                
                if  model.type == cellType.cellTypeparames {
                    
                     let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITableCellHolder)
                    
                    let switchView = SwitchServiceView.createSwitchServiceView()
                    
                    for subview in cell?.contentView.subviews as [UIView]! {
                        subview.removeFromSuperview()
                    }
                    
                    cell?.contentView.addSubview(switchView)
                    
                    layout(switchView) { switchView in
                        switchView.left == switchView.superview!.left
                        switchView.top == switchView.superview!.top
                        switchView.right == switchView.superview!.right
                        switchView.height == SwitchServiceView.HEIGHT
                    }
                    return cell!
                    
                }
                
                if model.type == cellType.cellTypeMutiChoose {
                    let list = NSMutableArray()
                    let modelArray = model.placeHolderModel as! NSMutableArray
                    modelArray.enumerateObjectsUsingBlock({ (modelObj, index, bol) -> Void in
                        do{
                            let model = try ServiceList(dictionary: modelObj as! [NSObject : AnyObject])
                            list.addObject(model)
                            
                        }catch{
                        }
                    })

                    let ls = NSArray(array: list) as! [ServiceList]
                    let hori = HorizontalCardView(frame: CGRectMake(0, 0, self.view.width, 80), serviceListModelList: ls,multiSelect : false)
                        let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITableCellHolder)
                    
                        for subview in cell?.contentView.subviews as [UIView]! {
                            subview.removeFromSuperview()
                        }
                        cell?.contentView.addSubview(hori)
                        return cell!
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
            let costom:ServiceList = dataSource![index]
            coverView.fillDataWithModel(costom)
            view = coverView
            
        }
        
        return view
    }
    
    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .Spacing){
            return value * 0.5
        }
        
        if (option == .Wrap){
            return CGFloat(true)
        }
        return value
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