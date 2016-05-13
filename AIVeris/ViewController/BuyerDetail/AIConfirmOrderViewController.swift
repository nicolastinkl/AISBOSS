//
//  AIConfirmOrderViewController.swift
//  AIVeris
//
// Copyright (c) 2016 ___ASIAINFO___
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Spring
import Cartography

class AIConfirmOrderViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var heightDic: [String:CGFloat] = Dictionary<String,CGFloat>()
    
    var dataSource: AIProposalInstModel!
    
    private var current_service_list: NSArray? {
        get {
            guard dataSource?.service_list == nil else {
                let result = dataSource?.service_list.filter (){
                    return ($0 as! AIProposalServiceModel).service_del_flag == ServiceDeletedStatus.NotDeleted.rawValue
                }
                return result
            }
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        /**
         Init.
         */
        InitData()
        
        tableView.reloadData()
        
    }
    
    func InitData(){
        
        self.backButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(60 / PurchasedViewDimention.CONVERT_FACTOR)
        self.priceLabel.font = AITools.myriadLightSemiCondensedWithSize(39 / PurchasedViewDimention.CONVERT_FACTOR)
        
        let name = dataSource?.proposal_name ?? ""
        self.backButton.setTitle(name, forState: UIControlState.Normal)
        if NSString(string: name).containsString("AIBuyerDetailViewController.pregnancy".localized) {
            // 处理字体
            let price = dataSource?.proposal_price ?? ""
            let richText = NSMutableAttributedString(string:(price))
            richText.addAttribute(NSFontAttributeName, value: AITools.myriadLightSemiCondensedWithSize(45 / PurchasedViewDimention.CONVERT_FACTOR) , range: NSMakeRange(price.length - 6, 6)) // 设置字体大小
            self.priceLabel.attributedText = richText
            
        } else {
            self.priceLabel.text = dataSource?.proposal_price
        }
        
        self.priceLabel.textColor = AITools.colorWithR(253, g: 225, b: 50)
        
        let footView = UIView()
        let providerView =  AIProviderView.currentView()
        tableView.tableFooterView = footView
        providerView.content.text = dataSource.proposal_desc ?? ""
        
        footView.addSubview(providerView)
        
    }
    
    @IBAction func dissMissView(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func startOrderVideoAction(sender: AnyObject) {
                
    }
    
    @IBAction func pleaseMyOrderAction(sender: AnyObject) {
        
        
    }
    
    
}

extension AIConfirmOrderViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return current_service_list?.count ?? 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = current_service_list?.objectAtIndex(indexPath.row) as? AIProposalServiceModel
        
        if model?.is_expend == 0 {
            model?.is_expend = 1
        }else{
            model?.is_expend = 0
        }
        
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let model = current_service_list?.objectAtIndex(indexPath.row) as? AIProposalServiceModel
        
        
        let CELL_ID = "UITableViewCell\(model?.service_id  ?? 0)"
        
        var tempCell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(CELL_ID)
        
        if tempCell == nil {
            tempCell = UITableViewCell(style: .Default, reuseIdentifier: CELL_ID)
            
        }
        tempCell?.selectionStyle = .None
        
        tempCell?.backgroundColor = UIColor.clearColor()
        tempCell?.contentView.backgroundColor = UIColor.clearColor()
        
        if model?.is_expend == 0 {
            
            tempCell?.viewWithTag(2)?.hidden = true
            
            if let _ = tempCell?.viewWithTag(1) {
                
            }else{
                //default
                if let cellView = AIConfirmOrderCellView.initFromNib(){
                    tempCell?.addSubview(cellView)
                    cellView.tag = 1
                }
            }
            
            if let orderCellView = tempCell?.viewWithTag(1) as? AIConfirmOrderCellView{
                orderCellView.hidden = false
                orderCellView.initData(model!)
                
                
                if indexPath.row % 2 == 0 {
                    orderCellView.backgroundColor = UIColor(hexString: "#5E504D", alpha: 0.3)
                }else{
                    orderCellView.backgroundColor = UIColor(hexString: "#5E546E", alpha: 0.3)
                }
                
            }
            
            
            
        }else{
            //expend
            
            tempCell?.viewWithTag(1)?.hidden = true
            
            if let _ = tempCell?.viewWithTag(2) {
                
            }else{
                //default
                if let cellView = SimpleServiceViewContainer.initFromNib() {
                    tempCell?.addSubview(cellView)
                    cellView.tag = 2
                }
            }
                        
            if let serviceView = tempCell?.viewWithTag(2) as? SimpleServiceViewContainer {
                serviceView.hidden = false
                //serviceView.settingState.tag = indexPath.row
                //serviceView.settingButtonDelegate = self
                serviceView.loadData(model!)
                heightDic["\(model?.service_id)"] = serviceView.selfHeight()
                
                // Add constrain
                constrain(serviceView, tempCell!) {(view, container) ->() in
                    view.left == container.left
                    view.top == container.top
                    view.bottom == container.bottom
                    view.right == container.right
                }
                
            }
            
        }
        
        /*
        if let _ = tempCell?.viewWithTag(4) {
        }else{
            let leftTop = DesignableView()
            let rightTop = DesignableView()
            let leftBottom = DesignableView()
            let rightBottom = DesignableView()
            
            tempCell?.addSubview(leftTop)
            tempCell?.addSubview(rightTop)
            tempCell?.addSubview(leftBottom)
            tempCell?.addSubview(rightBottom)
            
            constrain([leftTop,rightTop,leftBottom,rightBottom], block: { (layouts) in
                let layoutLT = layouts[0]
                layoutLT.leading == layoutLT.superview!.leading - 15
                layoutLT.top == layoutLT.superview!.top - 15
                
                let layoutRT = layouts[1]
                layoutRT.leading == layoutRT.superview!.trailing - 15
                layoutRT.top == layoutRT.superview!.top - 15
                
                let layoutLB = layouts[2]
                layoutLB.leading == layoutLB.superview!.leading - 15
                layoutLB.bottom == layoutLB.superview!.bottom - 15
                
                let layoutRB = layouts[3]
                layoutRB.leading == layoutRB.superview!.trailing - 15
                layoutRB.bottom == layoutRB.superview!.bottom - 15
                
            })
            
            settingsBlackColor([leftTop,rightTop,leftBottom,rightBottom])
        }
        
        */
        
        return tempCell ?? UITableViewCell()
    }
    
    func settingsBlackColor(sviews: [DesignableView]){
        
        for sview in sviews {
            
            sview.clipsToBounds = true
            sview.tag = 4
            sview.backgroundColor = UIColor.blackColor()
            sview.cornerRadius = 15
            
            constrain(sview) { (layout) in
                layout.width == 30
                layout.height == 30
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let model = current_service_list?.objectAtIndex(indexPath.row) as? AIProposalServiceModel
        if model?.is_expend == 0 {
            return 50
        }else{
            return heightDic["\(model?.service_id)"] ?? 0
        }
    
    }
}