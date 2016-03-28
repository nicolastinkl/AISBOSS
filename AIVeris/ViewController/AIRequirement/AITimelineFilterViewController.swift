//
//  AITimelineFilterViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/3/23.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AITimelineFilterViewController: UIViewController,AIPopupChooseViewDelegate {

    var popupChooseView : AIPopupChooseBaseView!
    var itemModelArray : [AIPopupChooseModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        buildLimitListView()
        if let itemModelArray = itemModelArray{
            popupChooseView.loadData(itemModelArray)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(itemModelArray : [AIPopupChooseModel]){
        self.itemModelArray = itemModelArray
        
    }
    
    func buildLimitListView(){
        let limitFrame = CGRect(x: 0, y: 0, width: view.width, height: 0)
        popupChooseView = AIPopupChooseBaseView(frame: limitFrame)
        popupChooseView.delegate = self
        view.addSubview(popupChooseView)
    }
    
    
    // MARK: - delegate
    func didConfirm(view : AIPopupChooseBaseView){
        self.dismissPopupViewController(true, completion: nil)
        print(AIBaseViewModel.printArrayModelContent(popupChooseView.itemModels!))
    }
    
    func didCancel(view : AIPopupChooseBaseView){
        self.dismissPopupViewController(true, completion: nil)
    }


}
