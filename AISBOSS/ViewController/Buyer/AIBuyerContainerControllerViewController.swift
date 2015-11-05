//
//  AIBuyerContainerControllerViewController.swift
//  AIVeris
//
//  Created by 王坜 on 15/11/5.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIBuyerContainerControllerViewController: UIViewController {

    let firstChildViewController : AIBuyerViewController = AIBuyerViewController()
    var secondChildViewController : AIBuyerDetailViewController?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addChildViewControllers () {
        self.addChildViewController(firstChildViewController)
        firstChildViewController.didMoveToParentViewController(self)
        //
        
    }

}
