//
//  AIBuyerViewController.swift
//  AIVeris
//
//  Created by 王坜 on 15/10/20.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit


class AIBuyerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    var dataSource  = [ProposalOrderModelWrap]()
    var tableViewCellCache = NSMutableDictionary()
    var cellList = NSMutableArray()
    
    // MARK: - Constants
    let screenWidth : CGFloat = UIScreen.mainScreen().bounds.size.width
    
    let tableCellRowHeight : CGFloat = 96
    
    // MARK: - Variable
    var bubbleView : UIView!
    
    var tableView : UITableView!
    
    var topBar : UIView!
    
    var currentIndexPath : NSIndexPath?
    
    // MARK: - Life Cycle

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.makeData()
        self.makeBaseProperties()
        
        self.makeTableView()
        self.makeBubbleView()
        self.makeTopBar()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        tableViewCellCache.removeAllObjects()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - 构造属性
    
    
    func makeBaseProperties () {
        self.view.backgroundColor = UIColor.blackColor()
        self.navigationController?.navigationBarHidden = true
        
        // bg 
        
        let bgImageView = UIImageView(image: UIImage(named: "Buyer_topBar_Bg"))
        bgImageView.frame = self.view.frame
        self.view.addSubview(bgImageView)
        
    }
    
    
    // MARK: - 构造气泡区域
    
    func makeBubbleView () {
        
        if let b = bubbleView {
            b.removeFromSuperview()
        }
        
        let height = CGRectGetHeight(self.view.frame)
        bubbleView = UIView(frame: CGRectMake(0, 0, screenWidth, height))
        ///bubbleView?.backgroundColor = UIColor.whiteColor()
        bubbleView?.clipsToBounds = true
        
        tableView?.tableHeaderView = bubbleView
        
        // add bubbles
  
        let bubbles : AIBubblesView = AIBubblesView(frame: CGRectMake(0, 44, screenWidth, height - 44), models: nil)
        bubbleView?.addSubview(bubbles)
        
    }
    
    // MARK: - 构造顶部Bar
    
    func makeTopBar () {
        let barHeight : CGFloat = 44
        let buttonWidth : CGFloat = 80
        let imageSize : CGFloat = (UIImage(named: "Buyer_Search")?.size.width)! * 3 / 2.46
        
        topBar = UIView (frame: CGRectMake(0, 0, screenWidth, barHeight))
        self.view.addSubview(topBar!)
    
        let bgview = UIView(frame: topBar.bounds)
        topBar.addSubview(bgview)
        
        
        // calculate
        
        let top = (barHeight - imageSize) / 2

        // make search
        
        let searchButton = UIButton(type: .Custom)
        searchButton.frame = CGRectMake(0, 0, buttonWidth, barHeight)
        searchButton.setImage(UIImage(named: "Buyer_Search"), forState: UIControlState.Normal)
        searchButton.imageEdgeInsets = UIEdgeInsetsMake(top, top, top, buttonWidth - imageSize - top)
        topBar?.addSubview(searchButton)
        
        // make logo
        
        let logo = UIImage(named: "Buyer_Logo")
        let logoSie = (logo?.size.width)! * 3 / 2.46
        let logoButton = UIButton(type: .Custom)
        logoButton.frame = CGRectMake(0, 0, logoSie, logoSie)
        logoButton.setImage(logo, forState: UIControlState.Normal)
        logoButton.imageEdgeInsets = UIEdgeInsetsMake(top, 0, 0, 0)
        logoButton.center = CGPointMake(screenWidth / 2, barHeight / 2)
        topBar?.addSubview(logoButton)
        
        
        // make more
        
        let moreButton = UIButton(type: .Custom)
        moreButton.frame = CGRectMake(screenWidth - 80, 0, buttonWidth, barHeight)
        moreButton.setImage(UIImage(named: "Buyer_More"), forState: UIControlState.Normal)
        moreButton.imageEdgeInsets = UIEdgeInsetsMake(top, buttonWidth - imageSize - top, top, top)
        moreButton.addTarget(self, action: "moreButtonAction", forControlEvents: .TouchUpInside)
        topBar?.addSubview(moreButton)
    }
    
    
    func moreButtonAction() {
        self.makeBubbleView()
    }
    
    // MARK: - 构造列表区域
    
    
    func makeTableView () {
        
        let frame = CGRectMake(0, 44, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))
        tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = .None
        tableView?.showsVerticalScrollIndicator = true
        tableView?.backgroundColor = UIColor.clearColor()
        tableView?.registerClass(AITableFoldedCellHolder.self, forCellReuseIdentifier: AIApplication.MainStoryboard.CellIdentifiers.AITableFoldedCellHolder)
        tableView?.registerClass(AITableExpandedCellHolder.self, forCellReuseIdentifier: AIApplication.MainStoryboard.CellIdentifiers.AITableExpandedCellHolder)

        self.view.addSubview(tableView!)
        
        
    }
    
    
    // MARK: - TableView Delegate And Datasource
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        let height = CGRectGetHeight(tableView.frame) - 5 * tableCellRowHeight
        
        return height
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        return  nil
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if  dataSource[indexPath.row].isExpanded{
            print("cell height : \(dataSource[indexPath.row].expandHeight)")
            return dataSource[indexPath.row].expandHeight!
        }
        else {
            return tableCellRowHeight
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : AITableFoldedCellHolder!
        
        let key = "rows\(indexPath.row)"
        if let cacheCell : AITableFoldedCellHolder = tableViewCellCache.valueForKey(key) as! AITableFoldedCellHolder?{
            cell = cacheCell
        }
        else{
            cell = AITableFoldedCellHolder()
            cell.tag = indexPath.row
            let folderCellView = AIFolderCellView.currentView()
            folderCellView.tag = 100
            folderCellView.frame = cell.contentView.bounds
            cell.contentView.addSubview(folderCellView)
            let expandedCellView = buildExpandCellView(indexPath)
            expandedCellView.tag = 200
            cell.contentView.addSubview(expandedCellView)
            cell.selectionStyle = .None
            cell.backgroundColor = UIColor.clearColor()
            cell.contentView.layer.cornerRadius = 10
            //add to cache
            
            tableViewCellCache.setValue(cell, forKey: key)
        }
        
        
        let folderCellView = cell.contentView.viewWithTag(100)
        let expandedCellView = cell.contentView.viewWithTag(200)
        if dataSource[indexPath.row].isExpanded {
            folderCellView?.hidden = true
            expandedCellView?.hidden = false
            print("expandedCellView frame :\(expandedCellView?.frame)")
        }
        else{
            folderCellView?.hidden = false
            expandedCellView?.hidden = true
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //如果有，做比较
        if let _ = currentIndexPath{
            //如果点击了不同的cell
            if currentIndexPath?.row != indexPath.row
            {
                dataSource[currentIndexPath!.row].isExpanded = !dataSource[currentIndexPath!.row].isExpanded
                dataSource[indexPath.row].isExpanded = !dataSource[indexPath.row].isExpanded
                //tableView.reloadRowsAtIndexPaths([indexPath,currentIndexPath!], withRowAnimation: UITableViewRowAnimation.None)
                currentIndexPath = indexPath;
            }
            else{
                dataSource[indexPath.row].isExpanded = !dataSource[indexPath.row].isExpanded
                //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                currentIndexPath = nil
            }
        }
        else{
            dataSource[indexPath.row].isExpanded = !dataSource[indexPath.row].isExpanded
            //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            currentIndexPath = indexPath;
        }
        tableView.reloadData()
        
        
    }
    
    // MARK: - ScrollViewDelegate
    
    
    func handleScrollEventWithOffset(offset:CGFloat) {

        let maxHeight = CGRectGetHeight((bubbleView?.frame)!) - 44
        
        if (offset > maxHeight / 2 && offset <= maxHeight) {
            tableView?.scrollRectToVisible(CGRectMake(0, maxHeight, screenWidth, CGRectGetHeight((tableView?.frame)!)), animated: true)
        }
        else if (offset < maxHeight / 2)
        {
            tableView?.scrollRectToVisible(CGRectMake(0, 0, screenWidth, CGRectGetHeight((tableView?.frame)!)), animated: true)
        }
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.handleScrollEventWithOffset(scrollView.contentOffset.y)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
         self.handleScrollEventWithOffset(scrollView.contentOffset.y)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y > 0)
        {
            topBar.backgroundColor = UIColor(white: 0.6, alpha: 0.6)
        }
        else
        {
            topBar.backgroundColor = UIColor.clearColor()
        }
    }

    // MARK: - MakeDemoData
    func makeData() {
        let bdk = BDKProposalService()
        bdk.getProposalList({ (responseData) -> Void in
            for proposal in responseData.proposal_order_list {
                let wrapModel = self.proposalToProposalWrap(proposal as! ProposalModel)
                self.dataSource.append(wrapModel)
            }
            
            self.tableView?.reloadData()
            }) { (errType, errDes) -> Void in
                
        }
    }
    
    private func proposalToProposalWrap(model: ProposalModel) -> ProposalOrderModelWrap {
        var p = ProposalOrderModelWrap()
        p.model = model
        return p
    }
    
    func buildExpandCellView(indexPath : NSIndexPath) -> ProposalExpandedView {
        let proposalModel = dataSource[indexPath.row].model!
        
        let viewWidth = tableView.frame.size.width
        let servicesViewContainer = ProposalExpandedView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: 50))
        servicesViewContainer.proposalOrder = proposalModel
        servicesViewContainer.dimentionListener = self
        
        
        for serviceModel in proposalModel.order_list {
            let serviceOrder = serviceModel as! ServiceOrderModel
            
            let serviceView = PurchasedServiceView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: PurchasedViewDimention.SERVICE_COLLAPSED_HEIGHT))
            serviceView.serviceOrderData = serviceOrder
     
            for paraModel in serviceOrder.service_param_list {
                let param = paraModel as! ParamModel
                    
                if paraModel.param_key == "25043309" {
                    let expandContent = ImageContent(frame: CGRect(x: 0, y: 0, width: viewWidth, height: 180))
                    expandContent.imgUrl = param.param_value

                    serviceView.addExpandView(expandContent)
                }
            }
            
            servicesViewContainer.addServiceView(serviceView)
        }
        

        //新建展开view时纪录高度
        servicesViewContainer.indexPath = indexPath
        dataSource[indexPath.row].expandHeight = servicesViewContainer.getHeight()
        //servicesViewContainer.frame.size.height = servicesViewContainer.getHeight()
        return servicesViewContainer
    }
}


extension AIBuyerViewController : DimentionChangable {
    func heightChanged(changedView: UIView, beforeHeight: CGFloat, afterHeight: CGFloat) {
        let expandView = changedView as! ProposalExpandedView
        let indexPath = expandView.indexPath!
        dataSource[(indexPath.row)].expandHeight = afterHeight
        //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        tableView.reloadData()
    }
    
}
