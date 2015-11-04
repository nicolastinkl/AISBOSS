//
//  AIBuyerViewController.swift
//  AIVeris
//
//  Created by 王坜 on 15/10/20.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AISpring

class AIBuyerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate ,AIBubblesViewDelegate{

    // MARK: - Properties
    var dataSource  = [ProposalOrderModelWrap]()
    var dataSourcePop = [AIBuyerBubbleModel]()
    var tableViewCellCache = [Int: UIView]()
    
    // MARK: - Constants
    let screenWidth : CGFloat = UIScreen.mainScreen().bounds.size.width
    
    let tableCellRowHeight : CGFloat = AITools.displaySizeFrom1080DesignSize(240)
    
    let topBarHeight : CGFloat = AITools.displaySizeFrom1080DesignSize(130)
    
    // MARK: - Variable
    var bubbleView : UIView!
    
    var tableView : UITableView!
    
    var topBar : UIView!
    
    var lastSelectedIndexPath : NSIndexPath?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.makeData()
        self.makeBaseProperties()
        
        self.makeTableView()
        self.makeBubbleView()
        self.makeTopBar()
        
    }
    
    deinit{
        tableViewCellCache.removeAll()
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
        
        let bgImageView = UIImageView(image: UIImage(named: "Buyer_topBar_Bg"))
        bgImageView.frame = self.view.frame
        self.view.addSubview(bgImageView)
        
    }
    
    func sphereDidSelected(index: Int) {
        print("\(index)")
    }
    
    
    // MARK: - 构造气泡区域
    
    func makeBubbleView () {
        
        if let b = bubbleView {
            b.removeFromSuperview()
        }
        
        let margin : CGFloat = AITools.displaySizeFrom1080DesignSize(40)
        let bheight = AITools.displaySizeFrom1080DesignSize(1538)
        
        let height = CGRectGetHeight(self.view.bounds) - AITools.displaySizeFrom1080DesignSize(116)
        bubbleView = UIView(frame: CGRectMake(0, 0, screenWidth, height))
        tableView?.tableHeaderView = bubbleView
        
        // add bubbles
     
        let bubbles = AIBubblesView(frame: CGRectMake(margin, topBarHeight + margin, screenWidth - 2 * margin, bheight), models: NSMutableArray(array: self.dataSourcePop))
        bubbleView?.addSubview(bubbles)
       
        let y = CGRectGetMaxY(bubbles.frame)
        let label : UPLabel = AIViews.normalLabelWithFrame(CGRectMake(margin, y, screenWidth-2*margin, 20), text: "Progress", fontSize: 20, color: UIColor.whiteColor())
        label.textAlignment = .Right
        
        label.verticalAlignment = UPVerticalAlignmentMiddle
        label.font = AITools.myriadRegularWithSize(20);
        bubbleView.addSubview(label)
        bubbles.addGestureBubbleAction  {  [weak self]   (bubleModel,bubbleView) -> Void in
            if let strongSelf = self{
                /**
                let bView:UIView = bubbleView
                let newPoint = bView.convertPoint(bView.center, toView: strongSelf.view)
                
                spring(1) { () -> Void in
                strongSelf.view.transform = CGAffineTransformMakeScale(3.635, 3.635)
                strongSelf.view.center = newPoint
                }*/
                
                strongSelf.showBuyerDetailAction()
            }
        }
    }
    
    func  showBuyerDetailAction() {
        
        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIBuyerDetailViewController) as! AIBuyerDetailViewController
        viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        viewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        self.showDetailViewController(viewController, sender: self)
    }
    
    // MARK: - 构造顶部Bar
    
    func makeTopBar () {
        let barHeight : CGFloat = topBarHeight;
        let buttonWidth : CGFloat = 80
        let imageSize : CGFloat = AITools.imageDisplaySizeFrom1080DesignSize((UIImage(named: "Buyer_Search")?.size)!).width
        
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
        searchButton.addTarget(self, action: nil, forControlEvents: .TouchUpInside)
        topBar?.addSubview(searchButton)
        
        // make logo
        
        let logo = UIImage(named: "Buyer_Logo")
        let logoSie = AITools.imageDisplaySizeFrom1080DesignSize((logo?.size)!).width
        let logoButton = UIButton(type: .Custom)
        logoButton.frame = CGRectMake(0, 0, logoSie, logoSie)
        logoButton.setImage(logo, forState: UIControlState.Normal)
        logoButton.center = CGPointMake(screenWidth / 2, barHeight / 2 + 5)
        logoButton.addTarget(self, action: "backToFirstPage", forControlEvents: .TouchUpInside)
        
        topBar?.addSubview(logoButton)
        
        
        // make more
        
        let moreButton = UIButton(type: .Custom)
        moreButton.frame = CGRectMake(screenWidth - 80, 0, buttonWidth, barHeight)
        moreButton.setImage(UIImage(named: "Buyer_More"), forState: UIControlState.Normal)
        moreButton.imageEdgeInsets = UIEdgeInsetsMake(top, buttonWidth - imageSize - top, top, top)
        moreButton.addTarget(self, action: "moreButtonAction", forControlEvents: .TouchUpInside)
        topBar?.addSubview(moreButton)
    }
    
    
    func backToFirstPage () {
        AIOpeningView.instance().show()
    }
    
    func moreButtonAction() {
        self.makeBubbleView()
    }
    
    // MARK: - 构造列表区域
    func makeTableView () {
        
        tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = .None
        tableView?.showsVerticalScrollIndicator = true
        tableView?.backgroundColor = UIColor.clearColor()
        tableView?.registerClass(AITableFoldedCellHolder.self, forCellReuseIdentifier: AIApplication.MainStoryboard.CellIdentifiers.AITableFoldedCellHolder)

        self.view.addSubview(tableView!)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if  dataSource[indexPath.row].isExpanded {
            return dataSource[indexPath.row].expandHeight!
        } else {
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
        
        if let cacheCell : AITableFoldedCellHolder = tableViewCellCache[indexPath.row] as! AITableFoldedCellHolder? {
            cell = cacheCell
        } else {
            cell = buildTableViewCell(indexPath)
 
            tableViewCellCache[indexPath.row] = cell
        }
        
        let folderCellView = cell.foldedView
        let expandedCellView = cell.expanedView
        
        if dataSource[indexPath.row].isExpanded {
            folderCellView?.hidden = true
            expandedCellView?.hidden = false
        } else {
            folderCellView?.hidden = false
            expandedCellView?.hidden = true
        }
        
        
        return cell
    }
    
    private func cellNeedRebuild(cell: AITableFoldedCellHolder) -> Bool {
        var needRebuild = false
        
        if let expanedView = cell.expanedView {
            needRebuild = expanedView.serviceOrderNumberIsChanged
        }
        
        return needRebuild
    }
    
    private func buildTableViewCell(indexPath: NSIndexPath) -> AITableFoldedCellHolder {
        let proposalModel = dataSource[indexPath.row].model!
        
        let cell = AITableFoldedCellHolder()
        cell.tag = indexPath.row
        let folderCellView = AIFolderCellView.currentView()
        folderCellView.loadData(proposalModel)
        folderCellView.frame = cell.contentView.bounds
        cell.foldedView = folderCellView
        cell.contentView.addSubview(folderCellView)
        
        let expandedCellView = buildExpandCellView(indexPath)
        cell.expanedView = expandedCellView
        cell.contentView.addSubview(expandedCellView)
        cell.selectionStyle = .None
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.layer.cornerRadius = 15

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !dataSource[indexPath.row].isExpanded{
            rowSelectAction(indexPath)
        }
    }
    
    //处理表格点击事件
    func rowSelectAction(indexPath : NSIndexPath){
        dataSource[indexPath.row].isExpanded = !dataSource[indexPath.row].isExpanded
        //如果有，做比较
        if let _ = lastSelectedIndexPath {
            //如果点击了不同的cell
            if lastSelectedIndexPath?.row != indexPath.row {
                dataSource[lastSelectedIndexPath!.row].isExpanded = !dataSource[lastSelectedIndexPath!.row].isExpanded
                lastSelectedIndexPath = indexPath;
            } else {
                lastSelectedIndexPath = nil
            }
        } else {
            lastSelectedIndexPath = indexPath;
        }
        
        if let cacheCell : AITableFoldedCellHolder = tableViewCellCache[indexPath.row] as! AITableFoldedCellHolder? {
            if cellNeedRebuild(cacheCell) {
                tableViewCellCache[indexPath.row] = buildTableViewCell(indexPath)
            }
        }
        tableView.reloadData()

    }
    
    // MARK: - ScrollViewDelegate
    func handleScrollEventWithOffset(offset:CGFloat) {

        let maxHeight = CGRectGetHeight((bubbleView?.frame)!) - topBarHeight
        
        if (offset > maxHeight / 2 && offset <= maxHeight) {
            tableView?.scrollRectToVisible(CGRectMake(0, maxHeight - AITools.displaySizeFrom1080DesignSize(96), screenWidth, CGRectGetHeight((tableView?.frame)!)), animated: true)
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
        if (scrollView.contentOffset.y > 0) {
            topBar.backgroundColor = UIColor(white: 0, alpha: 0.55)
        } else {
            topBar.backgroundColor = UIColor.clearColor()
        }
    }

    func makeData() {
        let bdk = BDKProposalService()
        // 列表数据
        bdk.getProposalList({ (responseData) -> Void in
            
            for proposal in responseData.proposal_order_list {
                let wrapModel = self.proposalToProposalWrap(proposal as! ProposalOrderModel)
                self.dataSource.append(wrapModel)
            }
            
            // 添加占位区
            let offset = CGRectGetHeight(self.view.bounds) - self.topBarHeight - (CGFloat(self.dataSource.count)  *  self.tableCellRowHeight);
            if (offset > 0) {
                let view = UIView(frame: CGRectMake(0, 0, self.screenWidth, offset))
                self.tableView.tableFooterView = view
            }
            
            self.tableView?.reloadData()
            }) { (errType, errDes) -> Void in
        }
        
        bdk.getPoposalBubbles({ (responseData) -> Void in
            if let pops = responseData.proposal_list {
                if pops.count > 0 {
                    self.dataSourcePop = pops as! [AIBuyerBubbleModel]
                    
                    self.makeBubbleView()
                    self.tableView?.reloadData()
                }
            }
            
            }) { (errType, errDes) -> Void in
        }        
    }
    
    private func proposalToProposalWrap(model: ProposalOrderModel) -> ProposalOrderModelWrap {
        var p = ProposalOrderModelWrap()
        p.model = model
        return p
    }
    
    func buildExpandCellView(indexPath : NSIndexPath) -> ProposalExpandedView {
        let proposalModel = dataSource[indexPath.row].model!
        let viewWidth = tableView.frame.size.width
        let servicesViewContainer = ProposalExpandedView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: PurchasedViewDimention.PROPOSAL_HEAD_HEIGHT))
        servicesViewContainer.proposalOrder = proposalModel
        servicesViewContainer.dimentionListener = self
        servicesViewContainer.delegate = self
        //新建展开view时纪录高度
        servicesViewContainer.tag = indexPath.row
        dataSource[indexPath.row].expandHeight = servicesViewContainer.getHeight()
        return servicesViewContainer
    }
    
   
    
}


extension AIBuyerViewController : DimentionChangable,ProposalExpandedDelegate {
    func heightChanged(changedView: UIView, beforeHeight: CGFloat, afterHeight: CGFloat) {
        let expandView = changedView as! ProposalExpandedView
        let row = expandView.tag
        dataSource[row].expandHeight = afterHeight
        tableView.reloadData()
    }
    
    func headViewTapped(proposalView: ProposalExpandedView){
        let indexPath = NSIndexPath(forRow: proposalView.tag, inSection: 0)
        rowSelectAction(indexPath)
    }
}
