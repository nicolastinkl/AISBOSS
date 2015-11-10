//
//  UITransViewController.swift
//  AITrans
//
//  Created by wantsor on 18/7/2015.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//

import UIKit
import AISpring


let cellIdentify = "viewCell"

class AICustomHomeViewController: UIViewController,UICollectionViewDelegateWaterfallLayout {
    
    // MARK: - IBVariable
    @IBOutlet weak var searchBar:UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - IBActions
    @IBAction func addAction(sender: UIButton) {
        
    }
    
    @IBAction func logoAction(sender: UIButton) {
        resetDefaultData()
        AIOpeningView.instance().show()
    }
    
    var collectionData:[AICustomerServiceSolutionModel]!
    var tempCollectionData:[AICustomerServiceSolutionModel]!
    
    //swipeView
    var swipeView : AICustomerSwipeView!
    var selectedColor: AICustomerFilterFlag!
    private var lastExpandedCell = -1
    
    //topMsgView
//    var topMsgView : AITopMsgView!
    
    //height besides tableView
    let collectionFixHeight:CGFloat = 125
    
    //reload collection view flag
    private var reloadFlag = false
    
    // MARK: - lifeCycle
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var frame:CGRect = collectionView.frame
        frame.origin.x = 0
        frame.size.width = CGRectGetWidth(self.view.frame)
        collectionView.frame = frame
        
        buildCollectionViewHeaderFooter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewWaterfallLayout()
        layout.columnCount = 2
        layout.itemWidth = CGRectGetWidth(self.view.frame) / 2 + 2
        
        layout.sectionInset = UIEdgeInsetsMake(0,0,0,0)
        layout.delegate = self
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(UINib(nibName: "AICustomerCollectionCellView", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: cellIdentify)
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "backgroundCell")
        
        swipeView = AICustomerSwipeView.current()
        swipeView.delegate = self
        swipeView.setSspScrollView(collectionView)
        
        //        collectionView.registerClass(AICustomerCollectionCellView.self, forCellWithReuseIdentifier: cellIdentify)
        
        //init FakeData
        tempCollectionData = buildFakeData()
        
        //init topMsgView
//        topMsgView = AITopMsgView.current()
//        topMsgView.frame = CGRectMake(0, -60, self.view.bounds.width, 60)
//        topMsgView.alpha = 0
//        topMsgView.delegate = self
//        self.view.addSubview(topMsgView)
        //set searchbar textfield
        let string = "_searchField"
        let txfSearchField = searchBar.valueForKey(string) as! UITextField
        txfSearchField.backgroundColor = UIColor.lightGrayColor()
        searchBar.backgroundColor = UIColor.clearColor()
        //        let bgView = searchBar.subviews[0] as UIView
        //        bgView.removeFromSuperview()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        if reloadFlag {
        //            buildCollectionViewHeaderFooter()
        //            reloadFlag = false
        //        }
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewWaterfallLayout!, heightForItemAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        //last fix cell height
        if indexPath.item == tempCollectionData.count {
            let layout = collectionView.collectionViewLayout as! UICollectionViewWaterfallLayout
            let lastAttr = layout.itemAttributes[tempCollectionData.count - 1] as! UICollectionViewLayoutAttributes
            let lastFrame = lastAttr.frame
            
            buildCollectionViewHeaderFooterByItemOrigin()
            //如果只有1条数据，那么补齐的数据就放另外一边，跟唯一那个cell一致
            if tempCollectionData.count == 1{
                let blackCellHeight = lastFrame.origin.y + lastFrame.size.height
                //println("blackCellHeight : \(blackCellHeight)")
                return blackCellHeight
            }
            
            
            let last2Attr = layout.itemAttributes[tempCollectionData.count - 2] as! UICollectionViewLayoutAttributes
            
            let last2Frame = last2Attr.frame
            let blackCellHeight = fabs(lastFrame.origin.y + lastFrame.size.height - (last2Frame.origin.y + last2Frame.size.height)) + 4
            //println("blackCellHeight : \(blackCellHeight)")
            
            return blackCellHeight
        }
        
        let cellData = tempCollectionData![indexPath.item]
        
        let cardView:AICardView = AICardView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width / 2 - 15, 0), cards: cellData.service_cells! as [AnyObject]);
        
        let cellHeight:CGFloat = cardView.frame.size.height + self.collectionFixHeight
        
        return cellHeight
    }
    
    func buildFakeData() -> [AICustomerServiceSolutionModel] {
        
        if collectionData == nil {
            let url = NSBundle.mainBundle().URLForResource("collectionData", withExtension: "plist")
            let serviceDictionariesArray = NSArray(contentsOfURL: url!)
            collectionData = [AICustomerServiceSolutionModel]()
            
            for serviceDictinary in serviceDictionariesArray! {
                
                var solution = AICustomerServiceSolutionModel()
                solution.service_id = serviceDictinary["service_id"] as? Int
                solution.service_name = serviceDictinary["service_name"] as? String
                solution.service_total_cost = serviceDictinary["service_total_cost"] as? String
                solution.service_order_mount = serviceDictinary["service_order_mount"] as? Int
                solution.service_source = serviceDictinary["service_source"] as? String
                solution.service_price = serviceDictinary["service_price"] as? String
                solution.service_flag = serviceDictinary["service_flag"] as? Int
                solution.is_comp_service = serviceDictinary["is_comp_service"] as? Int
                solution.service_cells = serviceDictinary["service_cells"] as? NSArray
                
                //                var serviceItemsDictinarys:NSArray = serviceDictinary["service_items"] as NSArray
                //                var serviceItems = [AICustomerServiceSolutionItemModel]()
                //
                //                for serviceItemDictionary in serviceItemsDictinarys {
                //
                //                    var serviceItem = AICustomerServiceSolutionItemModel()
                //                    serviceItem.status = serviceItemDictionary["status"] as? Int
                //                    serviceItem.service_content = serviceItemDictionary["service_content"] as? String
                //                    serviceItem.provider_portrait_url = serviceItemDictionary["provider_portrait_url"] as? String
                //
                //                    serviceItems.append(serviceItem)
                //                }
                //                solution.service_items = serviceItems
                collectionData!.append(solution)
            }
        }
        
        return collectionData!
    }
    
    
}

func makeCollectionCells()
{
    
}

// TODO: implement collection view protocols
extension AICustomHomeViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tempCollectionData!.count > 0 {
            return tempCollectionData!.count + 1
        }
        else{
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        
        //cal last cell height and x
        if indexPath.item == tempCollectionData.count  {
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("backgroundCell", forIndexPath: indexPath) 
            cell.backgroundColor = UIColor(rgba: "#1e1b38")
            return cell
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentify, forIndexPath: indexPath) as! AICustomerCollectionCellView
        let cellData = tempCollectionData[indexPath.item]
        //bind data
        cell.serviceName.text = cellData.service_name
        cell.servicePrice.text = cellData.service_price
        cell.serviceSource.text = cellData.service_source
        cell.totalCost.text = cellData.service_total_cost
        cell.totalTimes.text = "\(cellData.service_order_mount!)"
        cell.cards = cellData.service_cells

        if let serviceFlag = AICustomerFilterFlag(rawValue: cellData.service_flag!){
            switch serviceFlag {
            case .Timer:
                cell.cellBg.image = UIImage(named: "service_item_time_bg")
                cell.timerBtn.selected = true
                cell.favoriteBtn.selected = false
                cell.splitLine1.image = UIImage(named: "customer_split_line_timer")
                cell.splitLine2.image = UIImage(named: "customer_split_line_timer")
            case .Favorite:
                cell.cellBg.image = UIImage(named: "service_item_star_bg")
                cell.favoriteBtn.selected = true
                cell.timerBtn.selected = false
                cell.splitLine1.image = UIImage(named: "customer_split_line_star")
                cell.splitLine2.image = UIImage(named: "customer_split_line_star")
            default:
                cell.cellBg.image = UIImage(named: "service_item_default_bg")
                cell.favoriteBtn.selected = false
                cell.timerBtn.selected = false
                cell.splitLine1.image = UIImage(named: "customer_split_line_default")
                cell.splitLine2.image = UIImage(named: "customer_split_line_default")
            }
            
            
        }
        
        
        return cell
    }
}

extension AICustomHomeViewController : CustomerIndicatorDelegate{
    
    func onButtonClick(sender: AnyObject, filterFlag: AICustomerFilterFlag) {
        selectedColor = filterFlag
        
        loadData(selectedColor)
        
        _ = loadData(selectedColor)
        //topMsgView.updateLabelData(resultCnt, colorId: selectedColor.intValue())
        //setupTopMsgAnimate(true,nil)
        
        AILocalStore.setAccessMenuTag(filterFlag.intValue())
        lastExpandedCell = 0
    }
    
    func swipeViewVisibleChanged(isVisible: Bool) {
        if isVisible {
            //setIndexNumber()
        }
    }
    
    func loadData(filterFlag: AICustomerFilterFlag) -> Int{
        tempCollectionData = [AICustomerServiceSolutionModel]()
        if filterFlag.intValue() == -1 {
            tempCollectionData = collectionData
        }
        else {
            for solutionData:AICustomerServiceSolutionModel in collectionData{
                if solutionData.service_flag == filterFlag.intValue() {
                    tempCollectionData.append(solutionData)
                }
                //判断是否复合服务由专有字段is_comp_service决定
                if filterFlag.intValue() == 3 && solutionData.is_comp_service == 1{
                    tempCollectionData.append(solutionData)
                }
            }
        }
        collectionView.reloadData()
        if let oldView2 = self.view.viewWithTag(1002) {
            oldView2.removeFromSuperview()
        }
        return tempCollectionData.count
    }
    
    func resetDefaultData(){
        tempCollectionData = collectionData
        collectionView.reloadData()
        if let oldView2 = self.view.viewWithTag(1002) {
            oldView2.removeFromSuperview()
        }
    }
    
    func buildCollectionViewHeaderFooter(){
        //clear subview first
        if let oldView1 = self.view.viewWithTag(1001) {
            oldView1.removeFromSuperview()
        }
        if let oldView2 = self.view.viewWithTag(1002) {
            oldView2.removeFromSuperview()
        }
        //add collectionView header and footer
        let view1:UIView = UIView(frame: CGRectMake(0, -500, 1000, 500))
        view1.backgroundColor = UIColor(rgba: "#1e1b38")
        view1.tag = 1001
        collectionView.addSubview(view1)
        
        let view2:UIView = UIView(frame: CGRectMake(0, collectionView.contentSize.height, 1000, 500))
        view2.backgroundColor = UIColor(rgba: "#1e1b38")
        view2.tag = 1002
        collectionView.addSubview(view2)
    }
    
    func buildCollectionViewHeaderFooterByItemOrigin(){
        //clear subview first
        if let oldView1 = self.view.viewWithTag(1001) {
            oldView1.removeFromSuperview()
        }
        if let oldView2 = self.view.viewWithTag(1002) {
            oldView2.removeFromSuperview()
        }
        let view1:UIView = UIView(frame: CGRectMake(0, -500, 1000, 500))
        view1.backgroundColor = UIColor(rgba: "#1e1b38")
        view1.tag = 1001
        collectionView.addSubview(view1)
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewWaterfallLayout
        let lastItemAttribute = layout.itemAttributes.lastObject as! UICollectionViewLayoutAttributes
        
        let y = lastItemAttribute.frame.origin.y + lastItemAttribute.frame.size.height
        let view2:UIView = UIView(frame: CGRectMake(0, y, 1000, 500))
        view2.backgroundColor = UIColor(rgba: "#1e1b38")
        view2.tag = 1002
        collectionView.addSubview(view2)
    }
}

// MARK: Scrollview Delegate

extension AICustomHomeViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        swipeView.scrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //    indicator.scrollViewDidScroll(scrollView)
        //setIndexNumber()
        
        swipeView.scrollViewDidScroll(scrollView)
        //setIndexNumber(scrollView)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        swipeView.scrollViewDidEndDecelerating(scrollView)
        //      indicator.scrollViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        //     indicator.scrollViewDidScrollToTop(scrollView)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //     indicator.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    
    // MARK: Private Function
    
}

/*
extension AICustomHomeViewController:AITopMsgViewDelegate {
    typealias AnimationComplete = (Void) -> Void
    
    
    func setupTopMsgAnimate(showIt:Bool,animationComplete : AnimationComplete?){
        
        var alphaY:CGFloat = 0
        var animateY:CGFloat = 0
        
        spring(0.7, {
            if showIt {
                // show
                self.topMsgView.alpha = 1
                self.topMsgView.setTop(0)
                //self.searchBar.setHeight(0)
            }
            else {
                // hidden
                self.topMsgView.alpha = 0
                self.topMsgView.setTop(-self.topMsgView.height)
                //self.searchBar.setHeight(44)
            }
        })
        
    }
    
    func closeTopMsg(topMsgView: AITopMsgView) {
        setupTopMsgAnimate(false,nil)
        resetDefaultData()
    }
    
    // MARK: - Helper methods
    func setIndexNumber(scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let offsetY = scrollView.contentOffset.y
        let curPercent = offsetY / (contentHeight - scrollView.frame.height) * 10
        var intText = Int(curPercent) * 10
        if intText < 0 {
            intText = 0
        }
        else if intText > 100 {
            intText = 100
        }
        swipeView.label_number.text = "\(intText)%"
    }
}

*/

/*
let cellIdentify = "viewCell"

class AICustomHomeViewController: UIViewController,UICollectionViewDelegateWaterfallLayout {
    
    // MARK: - IBVariable
    @IBOutlet weak var searchBar:UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - IBActions
    @IBAction func addAction(sender: UIButton) {
        
    }
    
    @IBAction func logoAction(sender: UIButton) {
        AIOpeningView.instance().show()
    }
    
    var collectionData:[AICustomerServiceSolutionModel]!
    var tempCollectionData:[AICustomerServiceSolutionModel]!
    
    var swipeView : AICustomerSwipeView!
    var selectedColor: AICustomerFilterFlag!
    private var lastExpandedCell = -1
    
    //height besides tableView
    let collectionFixHeight:CGFloat = 120

    // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let layout = UICollectionViewWaterfallLayout()
        layout.columnCount = 2
        layout.itemWidth = UIScreen.mainScreen().bounds.width / 2 - 10
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 10, 5)
        layout.delegate = self
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
    collectionView.registerNib(UINib(nibName: "AICustomerCollectionCellView", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: cellIdentify)


        swipeView = AICustomerSwipeView.current()
        swipeView.delegate = self
        swipeView.setSspScrollView(collectionView)
        
//        collectionView.registerClass(AICustomerCollectionCellView.self, forCellWithReuseIdentifier: cellIdentify)

        // Do any additional setup after loading the view.
        tempCollectionData = buildFakeData()
        
        
//        let searchBackImageDefault = UIImage(named: "search_field_default")
//        let searchBackImageClicked = UIImage(named: "search_field_clicked")
        
        //set searchbar textfield
        let string = "_searchField"
        let txfSearchField = searchBar.valueForKey(string) as! UITextField
        txfSearchField.backgroundColor = UIColor.lightGrayColor()
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewWaterfallLayout!, heightForItemAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let cellData = tempCollectionData![indexPath.item]
        
        let cardView:AICardView = AICardView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width / 2 - 12, 0), cards: cellData.service_cells! as [AnyObject]);
        
        let cellHeight:CGFloat = cardView.frame.size.height + self.collectionFixHeight
        return cellHeight
    }
    
    func buildFakeData() -> [AICustomerServiceSolutionModel] {
        
        if collectionData == nil {
            let url = NSBundle.mainBundle().URLForResource("collectionData", withExtension: "plist")
            let serviceDictionariesArray = NSArray(contentsOfURL: url!)
            collectionData = [AICustomerServiceSolutionModel]()
            
            for serviceDictinary in serviceDictionariesArray! {
                
                var solution = AICustomerServiceSolutionModel()
                solution.service_id = serviceDictinary["service_id"] as? Int
                solution.service_name = serviceDictinary["service_name"] as? String
                solution.service_total_cost = serviceDictinary["service_total_cost"] as? String
                solution.service_order_mount = serviceDictinary["service_order_mount"] as? Int
                solution.service_source = serviceDictinary["service_source"] as? String
                solution.service_price = serviceDictinary["service_price"] as? String
                solution.service_flag = serviceDictinary["service_flag"] as? Int
                solution.service_cells = serviceDictinary["service_cells"] as? NSArray
                
                let serviceItemsDictinarys:NSArray = serviceDictinary["service_items"] as! NSArray
                var serviceItems = [AICustomerServiceSolutionItemModel]()
                
                for serviceItemDictionary in serviceItemsDictinarys {
                    
                    var serviceItem = AICustomerServiceSolutionItemModel()
                    serviceItem.status = serviceItemDictionary["status"] as? Int
                    serviceItem.service_content = serviceItemDictionary["service_content"] as? String
                    serviceItem.provider_portrait_url = serviceItemDictionary["provider_portrait_url"] as? String

                    serviceItems.append(serviceItem)
                }
                solution.service_items = serviceItems
                collectionData!.append(solution)
            }
        }
        
        return collectionData!
    }


}

func makeCollectionCells()
{
    
}

// TODO: implement collection view protocols
extension AICustomHomeViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempCollectionData!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentify, forIndexPath: indexPath) as! AICustomerCollectionCellView
        let cellData = tempCollectionData[indexPath.item]
        //bind data
        cell.serviceName.text = cellData.service_name
        cell.servicePrice.text = cellData.service_price
        cell.serviceSource.text = cellData.service_source
        cell.totalCost.text = cellData.service_total_cost
        cell.totalTimes.text = "\(cellData.service_order_mount!)"
        cell.cards = cellData.service_cells
        
        if let serviceFlag = AICustomerFilterFlag(rawValue: cellData.service_flag!){
            switch serviceFlag {
            case .Timer:
                cell.cellBg.image = UIImage(named: "service_item_time_bg")
            case .Favorite:
                cell.cellBg.image = UIImage(named: "service_item_star_bg")
            default:
                cell.cellBg.image = UIImage(named: "service_item_default_bg")
            }
            

        }
        
        
        return cell
    }
}

extension AICustomHomeViewController : CustomerIndicatorDelegate{
    
    func onButtonClick(sender: AnyObject, filterFlag: AICustomerFilterFlag) {
        selectedColor = filterFlag
        
        loadData(selectedColor)
        
        AILocalStore.setAccessMenuTag(filterFlag.intValue())
        lastExpandedCell = 0
    }
    
    func swipeViewVisibleChanged(isVisible: Bool) {
        if isVisible {
            //setIndexNumber()
        }
    }
    
    func loadData(filterFlag: AICustomerFilterFlag){
        tempCollectionData = [AICustomerServiceSolutionModel]()
        if filterFlag.intValue() == -1 {
            tempCollectionData = collectionData
        }
        else {
            for solutionData:AICustomerServiceSolutionModel in collectionData{
                if solutionData.service_flag == filterFlag.intValue() {
                    tempCollectionData.append(solutionData)
                }
            }
        }
        collectionView.reloadData()
    }
    
    func resetDefaultData(){
        tempCollectionData = collectionData
        collectionView.reloadData()
    }
}

// MARK: Scrollview Delegate

extension AICustomHomeViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        swipeView.scrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

   //    indicator.scrollViewDidScroll(scrollView)
        //setIndexNumber()

        swipeView.scrollViewDidScroll(scrollView)
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        swipeView.scrollViewDidEndDecelerating(scrollView)
  //      indicator.scrollViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
   //     indicator.scrollViewDidScrollToTop(scrollView)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
   //     indicator.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    
    // MARK: Private Function
    
    // MARK: - Helper methods
//    func setIndexNumber() {
//        var bar: UIView = tableView.subviews.last as UIView
//        
//        var point = CGPointMake(CGRectGetMidX(bar.frame), CGRectGetMidY(bar.frame))
//        
//        if let indexPath = self.tableView.indexPathForRowAtPoint(point) {
//            swipeView.label_number.text = "\(indexPath.section + 1)"
//        }
//    }
}
*/

