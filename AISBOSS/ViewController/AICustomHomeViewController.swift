//
//  UITransViewController.swift
//  AITrans
//
//  Created by wantsor on 18/7/2015.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//

import UIKit

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
                let serviceItems = [AICustomerServiceSolutionItemModel]()
                
                for serviceItemDictionary in serviceItemsDictinarys {
                    
                    let serviceItem = AICustomerServiceSolutionItemModel()
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


