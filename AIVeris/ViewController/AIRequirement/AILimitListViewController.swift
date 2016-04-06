//
//  AILimitListViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/3/22.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AILimitListViewController: UIViewController {
    
    var limitListView : AILimitListView!
    var limitModelArray : [AILimitModel]?
    var popupDelegate : AIPopupChooseViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buildLimitListView()
        if let limitModelArray = limitModelArray{
            limitListView.loadData(limitListModel: limitModelArray)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(limitModelArray : [AILimitModel]){
        self.limitModelArray = limitModelArray
        
    }
    
    func buildLimitListView(){
        let limitFrame = CGRect(x: 0, y: 0, width: view.width, height: 0)
        limitListView = AILimitListView(frame: limitFrame)
        limitListView.delegate = popupDelegate
        view.addSubview(limitListView)
    }
    
}

