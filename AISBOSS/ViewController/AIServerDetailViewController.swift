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


enum cellType:Int{
    case cellTypeDate = 0
    case cellTypeCoverflow = 1
    case cellTypeFilght = 2
    case cellTypeparames = 3
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
        return NSMutableArray(array: [data,data3,data4])
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
        
        tableView.estimatedRowHeight = 44//UITableViewAutomaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
        
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //
        if dataSource.count > indexPath.section{
            let model =  dataSource.objectAtIndex(indexPath.section) as! dataModel
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITitleServiceDetailCell) as! AITitleServiceDetailCell
                cell.title.text = model.title ?? ""
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
                    let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AISDFightCell) as! AISDFightCell
                   
                    return cell
                }
                
                if  model.type == cellType.cellTypeparames {
                    
                    let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AISDParamsCell) as! AISDParamsCell
                    cell.title.text = "Flight Some Sosd"
                    cell.descri.text = "Parson Accident insoure has incloud the project"
                    cell.price.text = "$20"
                    cell.line.setHeight(0.5)
                    return cell
                    
                }

            }
            
            
            
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if  //Day
        if indexPath.row == 0 {
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
    @IBAction func closeAction(sender: AnyObject) {
    }
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
            //coverView.fillDataWithModel()
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