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
    
    // MARK: -> Internal properties
    var bubbleModelArray : [AIProposalServiceModel]?
    
    var selectCurrentIndex:Int? = 0
    var proposalId: Int = 0
    
    weak var delegate: AIBuyerDetailDelegate?
    
    // MARK: -> Internal static properties
    
    // MARK: -> Internal class methods

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = self.bubbleModelArray?.count ?? 0
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor(hex: "0c93d9")
        pageControl.transform = CGAffineTransformMakeScale(0.8, 0.8)
        return pageControl
    }()
    
    private lazy var pageScrollView:UIScrollView = {
        // Setup the paging scroll view
        let pageScrollView = UIScrollView()
        pageScrollView.backgroundColor = UIColor.clearColor()
        pageScrollView.pagingEnabled = true
        pageScrollView.showsHorizontalScrollIndicator = false
        return pageScrollView
    }()
    
    
    // MARK: -> Internal init methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化背景
        initBground()
        
        //初始化组件
        initControls()
        
        //处理数据
        initGetingData()
        
        //处理默认选中
        initDefaultSelect()
    }
    
    func initDefaultSelect(){
        let index = (self.selectCurrentIndex ?? 0)
        pageControl.currentPage  = index 
        
        pageScrollView.setContentOffset(CGPointMake(CGFloat(index) * self.view.width, 0), animated: false)
    }
    
    // MARK: -> Internal methods
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
    
    // MARK: -> Internal class
    
    func initBground(){
        
        self.view.backgroundColor = AITools.colorWithR(0x1e, g: 0x1b, b: 0x38);
        
//        let bgImageView = UIImageView(image: UIImage(named: "Buyer_topBar_Bg"))
//        bgImageView.frame = self.view.frame
//        self.view.addSubview(bgImageView)
    }
    
    func initControls(){
        
        // init layout
        pageScrollView.delegate = self
        self.view.addSubview(pageScrollView)
        pageScrollView.frame = self.view.frame
        self.view.addSubview(pageControl)
        pageControl.setTop(8)
        pageControl.setX((self.view.width - pageControl.width)/2)
        
        // Add the album view controllers to the scroll view
        //var pageViews: [UIView] = []
        var viewTag:Int = 0
        for model in bubbleModelArray! {
            let pageView = UIView()
            pageView.tag = viewTag
            pageScrollView.addSubview(pageView)
            pageView.clipsToBounds = true
            pageView.frame = CGRectMake(CGFloat(viewTag) * self.view.width, 0, self.view.width, pageScrollView.height)
            //pageView.sizeWidthAndHeightToWidthAndHeightOfItem(pageScrollView)
            //pageViews.append(pageView)
            let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIServiceContentViewController) as! AIServiceContentViewController
            
            viewController.contentDelegate = self
            if model.service_id == AIServiceDetailTool.MUSIC_SERVICE_ID {
                viewController.serviceContentType = AIServiceContentType.MusicTherapy
            } else {
                viewController.serviceContentType = AIServiceContentType.Escort
            }
            
            viewController.serviceContentModel = model
            viewController.propodalId = proposalId
            
            self.addSubViewController(viewController, toView: pageView)
            viewTag = viewTag + 1
        }
        pageScrollView.contentSize = CGSizeMake(self.view.width * CGFloat(viewTag), self.view.height)
    }
    
    deinit{
        _ = pageScrollView.subviews.filter { (viewss) -> Bool in
            viewss.removeFromSuperview()
            return true
        }
    }
    /**
     初始化数据
     */
    func initGetingData(){
        
    }
    
    
}


// MARK: ContentViewDelegate

extension AIPageBueryViewController : AIServiceContentDelegate {
    
    func contentViewWillDismiss() {

        // handle parameter upload actio here
        let submitDataDic = [NSString: AIServiceSubmitModel]()
        
        for vc in childViewControllers {
            
            let contentVC = vc as! AIServiceContentViewController
            parseParam(contentVC, submitDataDic: submitDataDic)
        }
        
        
        guard submitDataDic.count > 0 else {
            self.dismissViewControllerAnimated(true, completion: nil)
            return;
        }
        
        // http request, get each model from submitDataDic, do upload
    }
    
    private func parseParam(paramProvider: AIBuyerParamsDelegate, submitDataDic: [NSString: AIServiceSubmitModel]) {
        if let params = paramProvider.getSelectedParams() {
            if params.count > 0 {
                for model in params {
                    addToSubmitData(model as! JSONModel, submitDataDic: submitDataDic)
                }
            }
        }
    }
    
    private func addToSubmitData(paramModel: JSONModel, var submitDataDic: [NSString: AIServiceSubmitModel]) {
        var serviceId: NSString?
        var roleId: NSString!
        var isProduct: Bool = false
        
        if let productParam = paramModel as? AIProductParamItem {
            serviceId = productParam.service_id
            roleId = productParam.role_id
            isProduct = true
        } else if let serviceParam = paramModel as? AIServiceParamItem {
            serviceId = serviceParam.service_id
            roleId = serviceParam.role_id
        }
        
        if let sId = serviceId {
            var submitModel: AIServiceSubmitModel!
            submitModel = submitDataDic[sId]
                
            if submitModel == nil {
                submitModel = AIServiceSubmitModel()
                submitModel.service_id = Int(sId as String)!
                submitModel.role_id = Int(roleId! as String)!
                submitModel.proposal_id = proposalId
                submitModel.customer_id = 100000002410
                
                submitModel.save_data = AIServiceSaveDataModel()
                
                submitDataDic[sId] = submitModel
            }
            
            if isProduct {
                if submitModel.save_data.product_list == nil {
                    submitModel.save_data.product_list = [AIProductParamItem]()
                }
                
                submitModel.save_data.product_list.append(paramModel)
            } else {
                if submitModel.save_data.service_param_list == nil {
                    submitModel.save_data.service_param_list = [AIServiceParamItem]()
                }
                
                submitModel.save_data.service_param_list.append(paramModel)
            }
        }
    }
}


// MARK: -> Internal type alias
extension AIPageBueryViewController:UIScrollViewDelegate {

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        for  vc in self.childViewControllers {
            let contentVC : AIServiceContentViewController = vc as! AIServiceContentViewController
            contentVC.shouldHideKeyboard()
        }
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
        pageControl.currentPage = Int(index)
    }
    
}