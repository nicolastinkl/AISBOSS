//
//  UIBuyerDetailViewController.swift
//  AIVeris
//
//  Created by tinkl on 3/11/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

import UIKit
import AISpring
import Cartography

protocol AIBuyerDetailDelegate:class{
    func closeAIBDetailViewController()
}

class AIBuyerDetailViewController : UIViewController {
    
    // MARK: Priate Variable
    
    private var cellHeights: [Int : CGFloat] = [Int : CGFloat]()
    private var dataSource : AIProposalInstModel!
    var bubleModel : AIBuyerBubbleModel?
    var delegate: AIBuyerDetailDelegate?
    
    // MARK: swift controls
    
    @IBOutlet weak var bgLabel: DesignableLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var OrderFromLabel: UILabel!
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomView: UIView!
    // MARK: getters and setters
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50.0, 0)
        
        // Init Data
        initData()
        
        // Init Label Font
        InitLabelFont()
        
        // Make
        //makeBuyButton()
     
        // Init Bottom Page white area
        InitBottomView()
    }
    
    func AddImageView(){
        self.infoButton.hidden = false
        let imageview =  UIImageView(image: UIImage(named: "pregnancyCare"))
        imageview.contentMode = .ScaleAspectFit
        
        let width = CGRectGetWidth(self.view.frame)
        let height = AITools.displaySizeFrom1080DesignSize(3819)
        
        imageview.frame = CGRectMake(0, 0, width, height)
        self.scrollview.addSubview(imageview)
        self.scrollview.contentInset = UIEdgeInsetsMake(0, 0, 50.0, 0)
        self.scrollview.contentSize = CGSizeMake(width, height)
        
        ///  action 1
        var label = UILabel(frame: CGRectMake(0, 0, width, 200))
        self.scrollview.addSubview(label)
        label.userInteractionEnabled = true
        var tap = UITapGestureRecognizer(target: self, action: "targetDetail")
        label.addGestureRecognizer(tap)
        
        /// action 2
        
        label = UILabel(frame: CGRectMake(0, AITools.displaySizeFrom1080DesignSize(1240), self.view.width, AITools.displaySizeFrom1080DesignSize(700)))
        self.scrollview.addSubview(label)
        label.userInteractionEnabled = true
        tap = UITapGestureRecognizer(target: self, action: "targetDetail2")
        label.addGestureRecognizer(tap)
    }
    
    func targetDetail(){
        /**
        let vc = AIServiceContentViewController()
        vc.serviceContentType = AIServiceContentType.MusicTherapy
        self.showViewController(vc, sender: self)
        */
        
        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIPageBueryViewController) as! AIPageBueryViewController
        
        viewController.bubleModelArray = [bubleModel!,bubleModel!,bubleModel!]
        self.showViewController(viewController, sender: self)
        
    }
    
    func targetDetail2(){
        let vc = AIServiceContentViewController()
        vc.serviceContentType = AIServiceContentType.Escort
        self.showViewController(vc, sender: self)
    }
      
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.bgLabel.animation = "zoomOut"
        self.bgLabel.duration = 0.5
        self.bgLabel.animate()
        
    }    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.tableView.layoutSubviews()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.NSNotiryAricToNomalStatus, object: nil)
    }
    
    func makeBuyButton () {
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 100, CGRectGetWidth(self.view.frame), 100)
        button.addTarget(self, action: "showNextViewController", forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
    }
    
    func InitBottomView () {
        let bzView = UIBezierPageView(frame: CGRectMake(0,38,200,50))
        bzView.setX((self.view.width - bzView.width)/2)
        bzView.refershView(8)
        //bzView.center = (self.bottomView.subviews.first as! UIImageView).center
        self.bottomView.addSubview(bzView)
        
    }
    
    
    func showNextViewController () {
     
        let vc = AIServiceContentViewController()
        vc.serviceContentType = AIServiceContentType.MusicTherapy
        self.showViewController(vc, sender: self)
            
    }
    
    func InitController(){
        
        let name = dataSource?.proposal_name ?? ""
        self.backButton.setTitle(name, forState: UIControlState.Normal)
        self.moneyLabel.text = dataSource?.order_total_price
        
        self.numberLabel.text = "\(dataSource?.order_times ?? 0)"
        self.whereLabel.text = dataSource?.proposal_origin
        self.contentLabel.text =  dataSource?.proposal_desc
        self.OrderFromLabel.text = "From"
        
        if NSString(string: name).containsString("Pregnancy") {
            // 处理字体
            let price = dataSource?.proposal_price
            let richText = NSMutableAttributedString(string: (price)!)
            richText.addAttribute(NSFontAttributeName, value:AITools.myriadLightSemiCondensedWithSize(45 / PurchasedViewDimention.CONVERT_FACTOR) , range: NSMakeRange(price!.length - 6, 6)) //设置字体大小
            self.totalMoneyLabel.attributedText = richText
            
        }else{
            self.totalMoneyLabel.text = dataSource?.proposal_price
        }
        
        self.totalMoneyLabel.textColor = AITools.colorWithR(253, g: 225, b: 50)
    }
    
    func InitLabelFont(){
        self.backButton.titleLabel?.font =  AITools.myriadSemiCondensedWithSize(80 / PurchasedViewDimention.CONVERT_FACTOR)
        self.moneyLabel.font =  AITools.myriadLightSemiCondensedWithSize(45 / PurchasedViewDimention.CONVERT_FACTOR)
        self.numberLabel.font =  AITools.myriadLightSemiCondensedWithSize(45 / PurchasedViewDimention.CONVERT_FACTOR)
        self.OrderFromLabel.font = AITools.myriadLightSemiCondensedWithSize(48 / PurchasedViewDimention.CONVERT_FACTOR)
        self.totalMoneyLabel.font =  AITools.myriadSemiCondensedWithSize(70 / PurchasedViewDimention.CONVERT_FACTOR)
        self.whereLabel.font = AITools.myriadLightSemiCondensedWithSize(48 / PurchasedViewDimention.CONVERT_FACTOR)
        self.contentLabel.font = AITools.myriadLightSemiCondensedWithSize(48 / PurchasedViewDimention.CONVERT_FACTOR)
    }
    
    // MARK: event response
    
    @IBAction func closeThisViewController(){
        delegate?.closeAIBDetailViewController()
        self.dismissViewControllerAnimated(false) { () -> Void in
            
        }
    }
    
    // MARK: private methods
    
    func refershData(){
        
    }
    
    func initData(){
        if let m = bubleModel {
            
            //test
            
            let name = m.proposal_name ?? ""
            if NSString(string: name).containsString("Pregnancy") {
                //INIT
                AddImageView()
                self.tableView.hidden = true
                let newlayout = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 77)//150
                
                self.contentView.addConstraints([newlayout])
                
                self.contentView.updateConstraints()

            } else {
                let newlayout = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 77)
                
                self.contentView.addConstraints([newlayout])
                
                self.contentView.updateConstraints()
            }
        
            BDKProposalService().queryCustomerProposalDetail(m.proposal_id, success:
                {[weak self] (responseData) -> Void in
                    
                    if let strongSelf = self {
                        strongSelf.dataSource = responseData
                        
                        //InitControl Data
                        strongSelf.InitController()
                        strongSelf.tableView.reloadData()
                    }
                    
                },fail : {
                    (errType, errDes) -> Void in
                    
            })
            
        }
        
    }
    
}

// MARK: delegate

// MARK: datesource

// MARK: function extension
extension AIBuyerDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource == nil{
            return 0
        }
        else {
            
            return dataSource.service_list.count
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let height = cellHeights[indexPath.row] {
            cell.contentView.subviews.first?.frame.size.height = height
        }
        
    }
  
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor.clearColor()
        
        let serviceDataModel = dataSource.service_list[indexPath.row] as! AIProposalServiceModel
        
        let offset:CGFloat = 20.0
        let width = CGRectGetWidth(UIScreen.mainScreen().bounds) - offset * 2
//        var serviceView: ServiceContainerView!
//        
//        if dataSource.service_list.count == 1 {
//            let singleServiceView = NSBundle.mainBundle().loadNibNamed("TopServiceContainer", owner: self, options: nil).first as! TopServiceContainerView
//            singleServiceView.isSingle = true
//            singleServiceView.isPrimeService(true)
//            serviceView = singleServiceView
//        } else {
//            if indexPath.row == 0 {
//                let topServiceView = NSBundle.mainBundle().loadNibNamed("TopServiceContainer", owner: self, options: nil).first as! TopServiceContainerView
//                topServiceView.isPrimeService(true)
//                serviceView = topServiceView
//            } else if indexPath.row == dataSource.service_list.count - 1 {
//                let bottomView = NSBundle.mainBundle().loadNibNamed("BottomServiceContainer", owner: self, options: nil).first  as! BottomServiceContainerView
//                serviceView = bottomView
//
//            } else {
//                let middleView = NSBundle.mainBundle().loadNibNamed("MiddleServiceContainer", owner: self, options: nil).first  as! MiddleServiceContainerView
//                serviceView = middleView
//            }
//        }
        
        let serviceView = NSBundle.mainBundle().loadNibNamed("SimpleServiceViewContainer", owner: self, options: nil).first as! SimpleServiceViewContainer
        
        serviceView.frame = CGRectMake(offset, 0, width, 200)
        serviceView.loadData(serviceDataModel)
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        cell.contentView.addSubview(serviceView)
        cellHeights[indexPath.row] = serviceView.frame.height
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let height = cellHeights[indexPath.row] {
            return height
        } else {
            return 1
        }
    }


}