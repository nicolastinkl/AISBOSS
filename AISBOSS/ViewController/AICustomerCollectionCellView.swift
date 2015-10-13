//
//  AICustomerCollectionCellView.swift
//  AITrans
//
//  Created by 刘先 on 15/7/14.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

import UIKit

class AICustomerCollectionCellView: UICollectionViewCell,UITableViewDataSource,UITableViewDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var totalTimes: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var servicePrice: UILabel!
    @IBOutlet weak var serviceSource: UILabel!
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var cellBg: UIImageView!
    @IBOutlet weak var splitLine1: UIImageView!
    @IBOutlet weak var splitLine2: UIImageView!
    
    var itemCardBlackBg: UIImageView = UIImageView(frame: CGRectZero)
    @IBOutlet weak var timerBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    var cards:NSArray?
    
    var cardView:AICardView?
    
    var tableViewOriginalX:CGFloat = 0
    var tableViewOriginalY:CGFloat = 0
    var tableViewOriginalW:CGFloat = 0
    
    @IBAction func favoriteAction(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            cellBg.image = UIImage(named: "service_item_default_bg")
            splitLine1.image = UIImage(named: "customer_split_line_default")
            splitLine2.image = UIImage(named: "customer_split_line_default")
        }
        else{
            sender.selected = true
            cellBg.image = UIImage(named: "service_item_star_bg")
            splitLine1.image = UIImage(named: "customer_split_line_star")
            splitLine2.image = UIImage(named: "customer_split_line_star")
        }
    }
    @IBAction func shareAction(sender: UIButton) {
        
    }
    @IBAction func settingsAction(sender: UIButton) {
        
    }
    
    @IBAction func timerAction(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            cellBg.image = UIImage(named: "service_item_default_bg")
            splitLine1.image = UIImage(named: "customer_split_line_default")
            splitLine2.image = UIImage(named: "customer_split_line_default")
        }
        else{
            sender.selected = true
            cellBg.image = UIImage(named: "service_item_time_bg")
            splitLine1.image = UIImage(named: "customer_split_line_timer")
            splitLine2.image = UIImage(named: "customer_split_line_timer")
        }
    }
     
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        var cornerImage = UIImage(named: "item_card_black_bg_2")        
        cornerImage = cornerImage!.resizableImageWithCapInsets(UIEdgeInsetsMake(25/2, 25/2 , 25/2, 25/2), resizingMode: UIImageResizingMode.Stretch)
        itemCardBlackBg.image = cornerImage
        
        self.addSubview(itemCardBlackBg)
    }
    
    func initCardView()
    {
        if (cardView != nil)
        {
            cardView?.removeFromSuperview()
        }
        cardView = AICardView(frame:  CGRectMake(0, 0, self.frame.size.width, 0), cards: cards! as [AnyObject])
    }
    
    func prepare(){
        
        self.initCardView()
        self.setCardView()
        self.setBorder()
    }
    
    func setCardView()
    {
        let dot = self.viewWithTag(200)!
        
        tableViewOriginalY = tableViewOriginalY == 0 ? dot.frame.origin.y : tableViewOriginalY
        tableViewOriginalW = tableViewOriginalW == 0 ? self.frame.size.width : tableViewOriginalW
        self.tableView.frame = CGRectMake(0, tableViewOriginalY, self.frame.size.width, cardView!.frame.size.height)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.addSubview(cardView!)
        self.tableView.scrollEnabled = false
    }
    
    func setBorder()
    {
        self.clipsToBounds = false
        let blackBgFrame = CGRectMake(-1, 0, self.bounds.width+1.5, self.bounds.height)
        itemCardBlackBg.frame = blackBgFrame
        self.bringSubviewToFront(itemCardBlackBg)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = "hello"
        cell.detailTextLabel?.text = "hello2"
        return cell
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        prepare()
        
    }
    
    class func currentView()->AICustomerCollectionCellView{
        let selfView = NSBundle.mainBundle().loadNibNamed("AICustomerCollectionCellView", owner: self, options: nil).first  as! AICustomerCollectionCellView
        return selfView
    }
    
}
