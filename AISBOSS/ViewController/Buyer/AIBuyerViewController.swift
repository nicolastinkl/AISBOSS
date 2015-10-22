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
    
   
    
    // MARK: - Constants
    var screenWidth : CGFloat = UIScreen.mainScreen().bounds.size.width
    
    
    // MARK: - Variable
    var bubbleView : UIView!
    
    var tableView : UITableView!
    
    var topBar : UIView!
    
    
    
    // MARK: - Life Cycle

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.makeBaseProperties()
        self.makeTableView()
        self.makeBubbleView()
        self.makeTopBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let height = CGRectGetHeight(self.view.frame)
        bubbleView = UIView(frame: CGRectMake(0, 0, screenWidth, height))
        bubbleView?.backgroundColor = UIColor.whiteColor()
        bubbleView?.clipsToBounds = true
        
        tableView?.tableHeaderView = bubbleView
        
        // add bubbles
  
        let bubbles : AIBubblesView = AIBubblesView(frame: (bubbleView?.bounds)!, models: nil)
        bubbleView?.addSubview(bubbles)
        
    }
    
    // MARK: - 构造顶部Bar
    
    func makeTopBar () {
        let barHeight : CGFloat = 44
        let buttonWidth : CGFloat = 80
        let imageSize : CGFloat = (UIImage(named: "Buyer_Search")?.size.width)! * 3 / 2.46
        
        topBar = UIView (frame: CGRectMake(0, 0, screenWidth, barHeight))
        topBar?.backgroundColor = UIColor(white: 0.6, alpha: 0.6)
        self.view.addSubview(topBar!)
        
        
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
        topBar?.addSubview(moreButton)
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
        tableView?.registerClass(AITableExpandedCellHolder.self, forCellReuseIdentifier: AIApplication.MainStoryboard.CellIdentifiers.AITableExpandedCellHolder)

        self.view.addSubview(tableView!)
        
        
    }
    
    
    // MARK: - TableView Delegate And Datasource
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        return  nil
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
   
        return 96
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : AITableFoldedCellHolder = tableView.dequeueReusableCellWithIdentifier("AITableFoldedCellHolder") as! AITableFoldedCellHolder
        
        cell.selectionStyle = .None
        cell.backgroundColor = UIColor.clearColor()
        if cell.contentView.subviews.count == 0{
            let folderCellView = AIFolderCellView.currentView()
            folderCellView.frame = cell.contentView.bounds
            folderCellView.tag = 1
            cell.contentView.addSubview(folderCellView)
            let expandedCellFrame = CGRectMake(0, 0, cell.contentView.width, 250)
            let expandedCellView = AIExpandedCellView(frame: expandedCellFrame)
            expandedCellView.hidden = true
            expandedCellView.tag = 2
            cell.contentView.addSubview(expandedCellView)
        }
        cell.contentView.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! AITableFoldedCellHolder
        if cell.contentView.subviews.count == 2 {
            let folderCellView = cell.contentView.subviews.first
            let expandedCellView = cell.contentView.subviews.last
            if folderCellView?.hidden == false{
                folderCellView?.hidden = true
                expandedCellView?.hidden = false                
            }
            else{
                folderCellView?.hidden = false
                expandedCellView?.hidden = true
            }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    // MARK: - ScrollViewDelegate
    
    
    func handleScrollEventWithOffset(offset:CGFloat) {

        let maxHeight = CGRectGetHeight((bubbleView?.frame)!)
        
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

}
