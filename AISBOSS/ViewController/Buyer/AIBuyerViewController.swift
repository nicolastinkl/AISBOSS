//
//  AIBuyerViewController.swift
//  AIVeris
//
//  Created by 王坜 on 15/10/20.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AISpring

class AIBuyerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AIBuyerDetailDelegate {

    // MARK: - Properties
    
    var dataSource  = [ProposalOrderModelWrap]()
    var dataSourcePop = [AIBuyerBubbleModel]()
    var tableViewCellCache = [Int: UIView]()
    
    var bubbles : AIBubblesView!
    
    var curBubbleCenter : CGPoint?
    
    var curBubbleScale : CGFloat?
    
    var originalViewCenter : CGPoint?

    // MARK: - Constants
    
    let bubblesTag : NSInteger = 9999

    let progressLabelTag = 321
    
    let screenWidth : CGFloat = UIScreen.mainScreen().bounds.size.width
    
    let tableCellRowHeight : CGFloat = AITools.displaySizeFrom1080DesignSize(240)
    
    let topBarHeight : CGFloat = AITools.displaySizeFrom1080DesignSize(130)
    
    // MARK: - Variable
    
    var bubbleViewContainer : UIView!
    
    var tableView : UITableView!
    
    var topBar : UIView!
    
    
    private let BUBBLE_VIEW_MARGIN = AITools.displaySizeFrom1080DesignSize(40)
    
    private let BUBBLE_VIEW_HEIGHT = AITools.displaySizeFrom1080DesignSize(1538)
    
    var lastSelectedIndexPath : NSIndexPath?
    
    private var selfViewPoint:CGPoint?
    var maxBubbleViewController : UIViewController?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selfViewPoint = self.view.center
        
        self.makeBaseProperties()
        self.makeTableView()
        self.makeTopBar()
        
        // Add Pull To Referesh..

        setupLanguageNotification()
        setupUIWithCurrentLanguage()
        
        loadData()
    }
    
    func setupLanguageNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setupUIWithCurrentLanguage", name: LCLLanguageChangeNotification, object: nil)
    }
    
    func setupUIWithCurrentLanguage() {
        //TODO: reload data with current language
        
        //remake bubble
        let label = bubbleViewContainer?.viewWithTag(progressLabelTag) as? UILabel
        label?.text = "AIBuyerViewController.progress".localized
        
        // reset refresh view
        tableView.removeHeader()
        weak var weakSelf = self
        tableView.addHeaderWithCallback { () -> Void in
            print("HeaderWithCallback\n")
            weakSelf!.loadData()
        }
        
        tableView.addHeaderRefreshEndCallback { () -> Void in
            weakSelf!.tableView.reloadData()
        }
        
        
        // reload bottom tableView
        tableViewCellCache.removeAll()
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    private func loadData() {

        
        self.tableView.hideErrorView()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let listData : ProposalOrderListModel? = appDelegate.buyerListData
        let proposalData : AIProposalPopListModel? = appDelegate.buyerProposalData
        weak var weakSelf = self
        if (listData != nil && proposalData != nil) {
            Async.main(after: 0.3, block: { () -> Void in
                weakSelf!.parseListData(listData)
                weakSelf!.parseProposalData(proposalData)
                appDelegate.buyerListData = nil
                appDelegate.buyerProposalData = nil
                weakSelf?.tableView.reloadData()
                
            })
     
        } else {
            let bdk = BDKProposalService()
            var listDone = false
            var bubblesDone = false
            // 列表数据
            bdk.getProposalList({ (responseData) -> Void in
                listDone = true
                weakSelf!.parseListData(responseData)
                
                if bubblesDone {
                    weakSelf!.tableView.headerEndRefreshing()
                }
                
                
                }, fail: { (errType, errDes) -> Void in
                    weakSelf!.tableView.headerEndRefreshing()
                    weakSelf!.tableView.showErrorContentView()
            })
        
            bdk.getPoposalBubbles({ (responseData) -> Void in
                bubblesDone = true
                weakSelf!.parseProposalData(responseData)
                
                if listDone {
                    weakSelf!.tableView.headerEndRefreshing()
                  
                }
                }, fail: { (errType, errDes) -> Void in
                    weakSelf!.tableView.headerEndRefreshing()
                    weakSelf!.tableView.showErrorContentView()
            })
            
        }
    }
    
    
    deinit {
        tableViewCellCache.removeAll()
    }
    

    
    // MARK: - 构造属性
    func makeBaseProperties () {
        self.view.backgroundColor = UIColor.blackColor()
        self.navigationController?.navigationBarHidden = true
        
        let bgImageView = UIImageView(image: UIImage(named: "Buyer_topBar_Bg"))
        bgImageView.frame = self.view.frame
        self.view.addSubview(bgImageView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadDataAfterUserChanged", name: kShouldUpdataUserDataNotification, object: nil)
    }
    
    func reloadDataAfterUserChanged() {
        
        weak var ws = self
        Async.main(after: 0.2) { () -> Void in
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.buyerListData = nil
            appDelegate.buyerProposalData = nil
            ws!.tableView.headerBeginRefreshing()
        }
    }
    
        
    // 回调
    func closeAIBDetailViewController() {
        
        self.view.userInteractionEnabled = false
        self.view.transform = CGAffineTransformMakeScale(curBubbleScale!, curBubbleScale!)
        self.view.center = curBubbleCenter!
        
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            self.view.transform = CGAffineTransformMakeScale(1, 1)
            self.view.center = self.originalViewCenter!
            }) { (Bool) -> Void in
                self.view.userInteractionEnabled = true
        }
    }
    
    
    func makeBubblesWithFrame(frame:CGRect) -> AIBubblesView {

        // add bubbles
        bubbles = AIBubblesView(frame: frame, models: NSMutableArray(array: self.dataSourcePop))
        bubbles.tag = bubblesTag
        bubbleViewContainer?.addSubview(bubbles)
        
        bubbles.addGestureBubbleAction  {  [weak self]   (bubbleModel, bubble) -> Void in
            if self != nil {
                self!.showBuyerDetailWithBubble(bubble, model: bubbleModel)
            }
        }
        
        return bubbles
    }
    
    
    func makeBubbleView () {
        if let _ = bubbles {
            recreateBubbleView()
        } else {
            createBubbleView()
        }
    }
    
    private func recreateBubbleView() {
        bubbles.removeFromSuperview()

        makeBubblesWithFrame(CGRectMake(BUBBLE_VIEW_MARGIN, topBarHeight + BUBBLE_VIEW_MARGIN, screenWidth - 2 * BUBBLE_VIEW_MARGIN, BUBBLE_VIEW_HEIGHT))
    }
    
    private func createBubbleView() {
        let height = CGRectGetHeight(self.view.bounds) - AITools.displaySizeFrom1080DesignSize(116)
        
        bubbleViewContainer = UIView(frame: CGRectMake(0, 0, screenWidth, height))
        tableView?.tableHeaderView = bubbleViewContainer
        
        // add bubbles
        makeBubblesWithFrame(CGRectMake(BUBBLE_VIEW_MARGIN, topBarHeight + BUBBLE_VIEW_MARGIN, screenWidth - 2 * BUBBLE_VIEW_MARGIN, BUBBLE_VIEW_HEIGHT))
        
        let y = CGRectGetMaxY(bubbles.frame)
        let label : UPLabel = AIViews.normalLabelWithFrame(CGRectMake(BUBBLE_VIEW_MARGIN, y, screenWidth - 2 * BUBBLE_VIEW_MARGIN, 20), text: "AIBuyerViewController.progress".localized, fontSize: 20, color: UIColor.whiteColor())
        label.textAlignment = .Right
        label.tag = progressLabelTag
        
        label.verticalAlignment = UPVerticalAlignmentMiddle
        label.font = AITools.myriadRegularWithSize(20);
        bubbleViewContainer.addSubview(label)
    }
    
    func convertPointToScaledPoint(point:CGPoint, scale:CGFloat , baseRect : CGRect) -> CGPoint {
        var scaledPoint : CGPoint = CGPointZero
        let xOffset = CGRectGetWidth(baseRect) * (scale - 1) / 2
        let yOffset = CGRectGetHeight(baseRect) * (scale - 1) / 2

        scaledPoint = CGPointMake(CGRectGetMinX(baseRect) - xOffset + point.x * scale, CGRectGetMinY(baseRect) - yOffset + point.y * scale)
        
        return scaledPoint
    }
    
    func showBuyerDetailWithBubble(bubble : AIBubble, model : AIBuyerBubbleModel) {
        
        // 获取原始中心点
        originalViewCenter = self.view.center
        
        // 获取放大后的半径 和 中心点
        let maxRadius = AITools.displaySizeFrom1080DesignSize(1384)
        let maxCenter = CGPointMake(CGRectGetWidth(self.view.frame) / 2, AITools.displaySizeFrom1080DesignSize(256))
        
        // 获取放大倍数
        curBubbleScale =  maxRadius / bubble.radius

        // 获取bubble在self.view的正确位置
        let realPoint : CGPoint  = bubble.superview!.convertPoint(bubble.center, toView: self.view)
        
        // 获取bubble放大以后再view中的坐标
        let scaledPoint = self.convertPointToScaledPoint(realPoint, scale: curBubbleScale!, baseRect: self.view.frame)
        
        // 计算中心点要移动的距离
        let xOffset = maxCenter.x - scaledPoint.x
        let yOffset = maxCenter.y - scaledPoint.y
        
        // 计算移动后的中心点
        curBubbleCenter = CGPointMake(self.view.center.x + xOffset, self.view.center.y + yOffset)
        
        // 动画过程中禁止响应用户的手势
        self.view.userInteractionEnabled = false
        
        // 处理detailViewController
        unowned let detailViewController = createBuyerDetailViewController(model)

        detailViewController.view.alpha = 0
        let detailScale : CGFloat = bubble.radius * 2 / CGRectGetWidth(self.view.frame)
        
        // self.presentViewController在真机iPhone5上会crash...
        self.presentViewController(detailViewController, animated: false) { () -> Void in
            
            detailViewController.view.alpha = 1
            detailViewController.view.transform =  CGAffineTransformMakeScale(detailScale, detailScale)
            detailViewController.view.center = realPoint
            // 开始动画
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in

                detailViewController.view.transform =  CGAffineTransformMakeScale(1, 1)
                detailViewController.view.center = self.originalViewCenter!
                
                self.view.transform =  CGAffineTransformMakeScale(self.curBubbleScale!, self.curBubbleScale!)
                self.view.center = self.curBubbleCenter!
                }, completion: { (complate) -> Void in
                    
                    springEaseIn(0.2, animations: { () -> Void in
                        self.view.transform =  CGAffineTransformMakeScale(1, 1)
                        self.view.center = self.originalViewCenter!
                    })
                    
                    self.view.userInteractionEnabled = true
                })
            }
    }  

    func  createBuyerDetailViewController(model: AIBuyerBubbleModel) -> UIViewController {
        
        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIBuyerDetailViewController) as! AIBuyerDetailViewController
        
        viewController.bubbleModel = model

        viewController.delegate = self
        
        let naviController = UINavigationController(rootViewController: viewController)
        naviController.navigationBarHidden = true
        
        viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        viewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        
        
        return viewController
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
        if let bView = bubbleViewContainer {
            let maxHeight = CGRectGetHeight(bView.frame) - topBarHeight
            
            if (offset > maxHeight / 2 && offset <= maxHeight) {
                tableView?.scrollRectToVisible(CGRectMake(0, maxHeight - AITools.displaySizeFrom1080DesignSize(96), screenWidth, CGRectGetHeight((tableView?.frame)!)), animated: true)
            } else if (offset < maxHeight / 2) {
                tableView?.scrollRectToVisible(CGRectMake(0, 0, screenWidth, CGRectGetHeight((tableView?.frame)!)), animated: true)
            }
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
    
    
    func parseListData(listData : ProposalOrderListModel?) {
        
        if let data = listData {
            dataSource.removeAll()
            
            for proposal in data.proposal_order_list {
                let wrapModel = self.proposalToProposalWrap(proposal as! ProposalOrderModel)
                
                dataSource.append(wrapModel)
            }
            
            // 添加占位区
            let offset = CGRectGetHeight(self.view.bounds) - self.topBarHeight - (CGFloat(self.dataSource.count)  *  self.tableCellRowHeight);
            if (offset > 0) {
                let view = UIView(frame: CGRectMake(0, 0, self.screenWidth, offset))
                self.tableView.tableFooterView = view
            }
            
            
        }
    }
    
    
    func parseProposalData(proposalData : AIProposalPopListModel?) {
        
        
        if let data = proposalData {
            if let pops = data.proposal_list {
                if pops.count > 0 {
                    self.dataSourcePop = pops as! [AIBuyerBubbleModel]
                    self.makeBubbleView()
                }
            }
        }
        
    }

    
    
    func proposalToProposalWrap(model: ProposalOrderModel) -> ProposalOrderModelWrap {
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