//
//  AIServiceContentViewController.swift
//  AIVeris
//
//  Created by 王坜 on 15/11/6.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography

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
        
        /**
        layout(topView) { (ticketView) -> () in
        ticketView.left == ticketView.superview!.left
        ticketView.top == ticketView.superview!.top
        ticketView.right == ticketView.superview!.right
        ticketView.height == size.height
        }
        */
        
        
        self.view.addSubview(scrollView)
//        scrollView.pinToTopEdgeOfSuperview(offset: size.height)
//        scrollView.pinToSideEdgesOfSuperview()
//        scrollView.pinToBottomEdgeOfSuperview()
        
        scrollView.frame = CGRectMake(0, size.height, self.view.width, self.view.height-size.height)
        
        /**layout(scrollView) { (ticketView) -> () in
            ticketView.left == ticketView.superview!.left
            ticketView.top == ticketView.superview!.top + size.height
            ticketView.right == ticketView.superview!.right
            ticketView.bottom ==  ticketView.superview!.bottom
        }*/
        
        
        
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
        
      
        
        //scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), tags.bottom + tags.height)
       
        scrollView.addSubview(galleryView)
        galleryView.imageModelArray = ["","","",""]
        galleryView.setTop(0)
        
        let tagsHold = UIView()
        
        
        scrollView.addSubview(tagsHold)
        tagsHold.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200)
        tagsHold.setTop(galleryView.top + galleryView.height + 5)
        
        
        let custView =  AICustomView.currentView()
        scrollView.addSubview(custView)
        custView.setTop(tagsHold.top + tagsHold.height + 5)
        custView.setWidth(self.view.width)
        
        
        var model1 = AIBuerSomeTagModel()
        model1.tagName = "irritated"
        model1.unReadNumber = 2
        
        var model2 = AIBuerSomeTagModel()
        model2.tagName = "fatigued"
        model2.unReadNumber = 6
        
        var model3 = AIBuerSomeTagModel()
        model3.tagName = "endorine disorders"
        model3.unReadNumber = 731
        
        custView.fillTags([model1,model2,model3], isNormal: true)
        
        let audioView = AICustomAudioNotesView.currentView()
        scrollView.addSubview(audioView)
        audioView.setTop(custView.top + custView.height)
        
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), audioView.top + audioView.height)
        
        
    }
     
}

