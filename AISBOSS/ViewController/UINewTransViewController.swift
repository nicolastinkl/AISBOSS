//
//  UINewTransViewController.swift
//  AITrans
//
//  Created by Rocky on 15/7/1.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

import Foundation
import AIAlertView

class UINewTransViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [AITransformContentModel]?
    var transformManager: AITransformManager?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
        
        loadContentData()
        
        let nib = UINib(nibName: "ContentsCellView", bundle: nil)
        tableView.registerNib(nib,
            forCellReuseIdentifier: "ContentCell")
    }
    
    private func loadContentData() {
        
        view.showProgressViewLoading()
        transformManager = AIHttpTransformManager()
        //   transformManager = AIMockTransformManager()
        
        transformManager?.queryCollectedContents(1, pageSize: 10, tags: nil, origin: nil, favoriteFlag: nil, colorFlags: nil, completion: loadData)
    }
    
    private func loadData(result: (model: [AITransformContentModel], err: Error?)) {
        view.hideProgressViewLoading()
        if result.err == nil {
            dataSource = result.model

            tableView.reloadData()
            
        } else if result.err != nil {
            view.showErrorView()
            AIAlertView().showError("加载失败", subTitle: result.err!.message, closeButtonTitle: "关闭", duration: 3)
        }
    }

    
    
}

extension UINewTransViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContentCell") as! ContentsCellView
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource != nil {
            return dataSource!.count
        } else {
            return 0
        }
    }
}