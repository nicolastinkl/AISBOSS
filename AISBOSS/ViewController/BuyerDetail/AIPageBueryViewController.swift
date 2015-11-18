//
//  AIPageBueryViewController.swift
//  AIVeris
//
//  Created by tinkl on 18/11/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit


internal class AIPageBueryViewController: UIViewController {
    
    
    var bubleModelArray : [AIBuyerBubbleModel]?
    var delegate: AIBuyerDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgImageView = UIImageView(image: UIImage(named: "Buyer_topBar_Bg"))
        bgImageView.frame = self.view.frame
        self.view.addSubview(bgImageView)
        
        // Setup the paging scroll view
        let pageScrollView = UIScrollView()
        pageScrollView.backgroundColor = UIColor.clearColor()
        pageScrollView.pagingEnabled = true
        pageScrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(pageScrollView)
        pageScrollView.pinToEdgesOfSuperview()
        
        // Add the album view controllers to the scroll view
        var pageViews: [UIView] = []
        for _ in bubleModelArray! {
            let pageView = UIView()
            pageScrollView.addSubview(pageView)
            pageView.clipsToBounds = true
            pageView.sizeWidthAndHeightToWidthAndHeightOfItem(pageScrollView)
            pageViews.append(pageView)
             
            let viewController = AIServiceContentViewController()
            viewController.serviceContentType = AIServiceContentType.Escort
            
            self.addSubViewController(viewController, toView: pageView)
            
        }
        if #available(iOS 9, *) {
            pageScrollView.boundHorizontally(pageViews)
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func addSubViewController(viewController: UIViewController, toView: UIView? = nil, belowSubview: UIView? = nil) {
        self.addChildViewController(viewController)
        var parentView = self.view
        if let view = toView {
            parentView = view
        }
        if let subview = belowSubview {
            parentView.insertSubview(viewController.view, belowSubview: subview)
        } else {
            parentView.addSubview(viewController.view)
        }
        viewController.didMoveToParentViewController(self)
        viewController.view.pinToEdgesOfSuperview()
    }
    
}