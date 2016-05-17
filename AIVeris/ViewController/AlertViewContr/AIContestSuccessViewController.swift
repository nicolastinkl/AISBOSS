//
//  AIContestSuccessViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/5/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIContestSuccessViewController: UIViewController {

    
    @IBOutlet weak var seperateViewNeeds: AIDottedLineLabelView!
    @IBOutlet weak var orderInfoView: AIIconLabelVerticalContainerView!
    @IBOutlet weak var seperateViewUser: AIDottedLineLabelView!
    @IBOutlet weak var customerBannerView: AICustomerBannerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buildNavigationTitleLabel()
        customerBannerView.loadData()
        seperateViewNeeds.loadData("User needs")
        seperateViewUser.loadData("Single success")
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildNavigationTitleLabel(){
        let NAVIGATION_TITLE = AITools.myriadSemiCondensedWithSize(80 / 3)
        let frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        let titleLabel = UILabel(frame: frame)
        titleLabel.font = NAVIGATION_TITLE
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "Service detail"
        self.navigationItem.titleView = titleLabel
        let backImage = UIImage(named: "se_back")
        let leftButtonItem = UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AIContestSuccessViewController.backAction(_:)))
        leftButtonItem.tintColor = UIColor.lightGrayColor()
        self.navigationItem.leftBarButtonItem = leftButtonItem
    }
    
    func backAction(button : UIBarButtonItem){
        self.dismissPopupViewController(true, completion: nil)
    }
    
    
    func loadData(){
        
        let orderInfosModel = [AIIconLabelViewModel(labelText: "November 3, 2015", iconUrl: "http://171.221.254.231:3000/upload/shoppingcart/CTQJUtkd0VWNI.png") , AIIconLabelViewModel(labelText: "Haidian District Garden Road, Beijing, 49", iconUrl: "http://171.221.254.231:3000/upload/shoppingcart/CTQJUtkd0VWNI.png") , AIIconLabelViewModel(labelText: "Accompany pregnant woman to produce a check, queue,take a number, buy foodGeneration of pregnant women", iconUrl: "http://171.221.254.231:3000/upload/shoppingcart/CTQJUtkd0VWNI.png")]
        orderInfoView.loadData(orderInfosModel)
    }
    

    // MARK: - IBActions
    @IBAction func startWorkAction(sender: AnyObject) {
        let taskDetailVC = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.TaskExecuteStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.TaskDetailViewController) as! TaskDetailViewController
        
        self.navigationController?.pushViewController(taskDetailVC, animated: true)
    }
}
