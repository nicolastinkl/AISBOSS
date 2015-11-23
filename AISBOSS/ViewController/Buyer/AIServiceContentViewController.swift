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

///  - AIServiceContentViewController
internal class AIServiceContentViewController: UIViewController {

    // MARK: -> Internal properties
    
    private let redColor : String = "b32b1d"
    
    internal var serviceContentType : AIServiceContentType!
    
    private let topView = AINavigationBarView.currentView()
    
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
        let gView = AIGalleryView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 192))
        return gView
    }()
    
    // MARK: -> Internal init methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
        导航栏
        */
        makeTopView()
        
        /**
        ScrollView数据填充
        */
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
        
//        let image = topImage()
//        let size = AITools.imageDisplaySizeFrom1080DesignSize(image.size) as CGSize
//        self.view.addSubview(topView)
        
        self.view.addSubview(topView)
        topView.pinToSideEdgesOfSuperview()
        self.view.addSubview(scrollView)
        
        scrollView.frame = CGRectMake(0, topView.height , self.view.width, self.view.height-topView.height)
        
    }
    
    func makeContentView () {
        
        // Add gallery View
        scrollView.addSubview(galleryView)
        galleryView.imageModelArray = ["","","",""]
        galleryView.setTop(0)
        
        let tagsHold = UIView()
        
        
        scrollView.addSubview(tagsHold)
        tagsHold.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200)
        tagsHold.setTop(galleryView.top + galleryView.height + 5)
        
        let custView =  AICustomView.currentView()
        addNewSubView(custView, preView: tagsHold)
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
        addNewSubView(audioView, preView: custView)
        
        let audio1 = AIAudioMessageView.currentView()
        addNewSubView(audio1, preView: audioView)
        
        let text1 = AITextMessageView.currentView()
        addNewSubView(text1, preView: audio1)
        
        let text2 = AITextMessageView.currentView()
        addNewSubView(text2, preView: text1)
    }
    
    func addNewSubView(cview:UIView,preView:UIView){
        scrollView.addSubview(cview)
        
        cview.setWidth(self.view.width)
        cview.setTop(preView.top + preView.height)
        cview.backgroundColor = UIColor(hex: redColor)
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), cview.top + cview.height)
        
    }
    
}

