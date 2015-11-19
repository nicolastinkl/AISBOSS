//
//  AIServiceContentViewController.swift
//  AIVeris
//
//  Created by 王坜 on 15/11/6.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

public enum AIServiceContentType : Int {
    case MusicTherapy = 100 ,Escort
}

internal class AIServiceContentViewController: UIViewController {

    // MARK: -> Internal properties
    internal var serviceContentType : AIServiceContentType!
    
    private let topView = UIView()
    
    private lazy var scrollView:UIScrollView = {
        // Setup the paging scroll view
        let pageScrollView = UIScrollView()
        pageScrollView.backgroundColor = UIColor.clearColor()
        pageScrollView.pagingEnabled = false
        pageScrollView.showsHorizontalScrollIndicator = false
        pageScrollView.showsVerticalScrollIndicator = false
        return pageScrollView
    }()
    
    private lazy var galleryView : AIGalleryView = {
        let gView = AIGalleryView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 120))
        return gView
    }()
    
    // MARK: -> Internal init methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTopView()
        
        makeContentView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bottomImage() -> UIImage {
        
        var name = "Fake_Content"
        let type : AIServiceContentType = serviceContentType
        switch type {
        case  .MusicTherapy:
            name = "Fake_Content"
        case .Escort:
            name = "Fake_Escort_Bottom"
        }

        return UIImage(named: name)!
    }
    
    
    func topImage() -> UIImage {
        var name = "Fake_Top"
        let type : AIServiceContentType = serviceContentType
        switch type {
        case  .MusicTherapy:
            name = "Fake_Top"
        case .Escort:
            name = "Fake_Escort_Top"
            
        }
        
        return UIImage(named: name)!
    }

    func makeButtonWithFrame(frame:CGRect, action:Selector) -> UIButton {
        let button = UIButton(type: .Custom)
        button.frame = frame
        button.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        
        return button
    }
    
    func backAction () {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scrollAction () {
        let image = bottomImage()
        let size = AITools.imageDisplaySizeFrom1080DesignSize(image.size) as CGSize
        let frame = CGRectMake(0, size.height - 10, CGRectGetWidth(scrollView.frame), 10)
        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    func makeTopView () {
        
        let image = topImage()
        let size = AITools.imageDisplaySizeFrom1080DesignSize(image.size) as CGSize
        self.view.addSubview(topView)
        topView.sizeToHeight(size.height)
        topView.pinToSideEdgesOfSuperview()
        
        self.view.addSubview(scrollView)
        scrollView.pinToTopEdgeOfSuperview(offset: size.height)
        scrollView.pinToSideEdgesOfSuperview()
        scrollView.pinToBottomEdgeOfSuperview()
        
        let topImageView = UIImageView(image: image)
        topImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), size.height)
        topView.addSubview(topImageView)
        
        // add back action 
        
        let backFrame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), size.height / 2)
        topView.addSubview(self.makeButtonWithFrame(backFrame, action: "backAction"))
        
        // add scroll action
        let scrollFrame = CGRectMake(CGRectGetWidth(self.view.frame) * 2 / 3, CGRectGetHeight(backFrame), CGRectGetWidth(self.view.frame) / 3, size.height / 2)
        topView.addSubview(self.makeButtonWithFrame(scrollFrame, action: "scrollAction"))
    }
    
    
    func makeContentView () {
        
        // Add gallery View
        
//        galleryView.pinToTopEdgeOfSuperview()
//        galleryView.pinToSideEdgesOfSuperview()
//        galleryView.sizeToHeight(120)
        
        // make contentSize
        
//        let image = bottomImage()
//        let size = AITools.imageDisplaySizeFrom1080DesignSize(image.size) as CGSize
//        let contentImageView = UIImageView(image: image)
//        contentImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), size.height)
//        scrollView.addSubview(contentImageView)
//        scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), size.height)
        
        scrollView.addSubview(galleryView)
        galleryView.imageModelArray = ["","","",""]
        
        let tags = UICustomsTags.currentView()
//        self.view.addSubview(tags)

        tags.frame = CGRectMake(10, galleryView.top + galleryView.height + 10, 275, 50)
        
    }
    
    
}

