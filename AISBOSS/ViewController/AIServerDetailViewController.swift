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
        
        var data3 =  dataModel()
        data3.title = "FLIGHT"
        data3.type = cellType.cellTypeFilght
        
        var data4 =  dataModel()
        data4.title = "Pararmes"
        data4.type = cellType.cellTypeparames
        
        
        var data5 =  dataModel()
        data5.title = "PararmesMuti"
        data5.type = cellType.cellTypeMutiChoose
        
        
        var data6 =  dataModel()
        data6.title = "CTypeCoverflow"
        data6.type = cellType.cellTypeCoverflow
        
        return NSMutableArray(array: [data,data3,data6,data4,data5])
        }()
    
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
    
        self.tableView.reloadData()
        
//        tableView.estimatedRowHeight = 44//UITableViewAutomaticDimension
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "ChangeDateViewNotification", name: AIApplication.Notification.UIAIASINFOChangeDateViewNotification, object: nil)
        
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
        self.scrollView.addSubview(tags!) 
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, 180)
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
                return 300
            case cellType.cellTypeCoverflow:
                return 220
            case cellType.cellTypeFilght:
                return 280
            case cellType.cellTypeparames:
                return 100
            case cellType.cellTypeMutiChoose:
                return 200
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
                cell.closeButton.addTarget(self, action: "closeCurrentSectionAction:", forControlEvents: UIControlEvents.TouchDragInside)
               
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
                    return cell
                }
                
                if  model.type == cellType.cellTypeFilght {
                    /*let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AISDFightCell) as! AISDFightCell
                   
                    return cell
                    */
                    
                   
                    
                    let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITableCellHolder)
                    var ticketGroupView:AirTicketGroupView
                    if cell?.contentView.subviews.count == 0 {
                        ticketGroupView = AirTicketGroupView()
                        ticketGroupView.tag = 3
                        cell?.contentView.addSubview(ticketGroupView)
                        layout(ticketGroupView) { viewTic in
                            viewTic.left == viewTic.superview!.left + 9
                            viewTic.top == viewTic.superview!.top
                            viewTic.right == viewTic.superview!.right - 9
                            viewTic.height == 280
                        }
                        ticketGroupView.setTicketsData()
                    }else{
                        ticketGroupView = cell?.contentView.viewWithTag(3) as! AirTicketGroupView
                    }
                    
                    ticketGroupView.layoutIfNeeded()
                    
                    return cell!
                    
                }
                
                if  model.type == cellType.cellTypeparames {
                    
                    let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AISDParamsCell) as! AISDParamsCell
                    cell.title.text = "Flight Some Sosd"
                    cell.descri.text = "Parson Accident insoure has incloud the project"
                    cell.price.text = "$20"
                    cell.line.setHeight(0.5)
                    return cell
                }
                
                if model.type == cellType.cellTypeMutiChoose {
                    
                        let p = SchemeParamList()
                        p.param_key = 1
                        p.param_value = "value"
                        p.param_value_id = NSNumber(int: 1)
                    
                        let ser = ServiceList()
                        ser.service_id = 1
                        ser.service_img = "http://img1.gtimg.com/news/pics/hv1/40/169/1927/125346310_small.jpg"
                        ser.service_intro = "introeslkdf"
                        ser.service_name = "SomeTimes"
                        ser.service_price = "12.0"
                        ser.service_rating = NSNumber(int: 12)
                        ser.service_param_list = [p]
                        ser.provider_id = 12
                        ser.provider_name = "tinkle"
                        ser.provider_icon = ""
                        
                        let hori = HorizontalCardView(frame: CGRectMake(0, 0, self.view.width, 100), serviceListModelList: [ser,ser])
                        
                        let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITableCellHolder)
                        if cell?.contentView.subviews.count == 0 {
                            cell?.contentView.addSubview(hori)
                        }
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
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int
    {
        return 5
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
            var costomModel = AICustomerServiceCoverFlowModel()
            costomModel.service_id = 1
            costomModel.provider_name = "Timmy Jones"
            costomModel.provider_icon = "http://pic41.nipic.com/20140520/18505720_142810265175_2.jpg"
            costomModel.provider_id = 1
            
            costomModel.service_img = "http://pic25.nipic.com/20121119/6835836_115116793000_2.jpg"
            costomModel.service_name = "Great fishing exprience."
            costomModel.service_intro = "Fishing is the Best all yourself can be  expred on th brench."
            costomModel.service_price = "123.0"
            costomModel.service_rating = 2
            
            coverView.fillDataWithModel(costomModel)
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