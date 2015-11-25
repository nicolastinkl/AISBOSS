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
    private var preCacheView:UIView?
    
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
    
    private var audioView:AIAudioRecordView?
    
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
//        let image = bottomImage()
//        let size = AITools.imageDisplaySizeFrom1080DesignSize(image.size) as CGSize
//        let frame = CGRectMake(0, size.height - 10, CGRectGetWidth(scrollView.frame), 10)
//        scrollView.scrollRectToVisible(frame, animated: true)
    }
    
    func makeTopView () {
        
//        let image = topImage()
//        let size = AITools.imageDisplaySizeFrom1080DesignSize(image.size) as CGSize
        
        let topView = AINavigationBarView.currentView()
        self.view.addSubview(topView)
        self.view.addSubview(scrollView)
        topView.setWidth(self.view.width)
        scrollView.frame = CGRectMake(0, topView.height , self.view.width, self.view.height-topView.height)
        
        topView.backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        //init recording view
        audioView =  AIAudioRecordView.currentView()
        if let auView = audioView {
            self.view.addSubview(auView)
            auView.hidden = true
            auView.setWidth(self.view.width)
            auView.setTop((self.view.height - auView.height)/2)
        }
    }    
    
    func makeContentView () {
        
        // Add gallery View
        scrollView.addSubview(galleryView)
        galleryView.imageModelArray = ["http://tinkl.qiniudn.com/tinklUpload_DSHJKFLDJSLF.png","http://tinkl.qiniudn.com/tinklUpload_DSHJKFLDJSLF.png","http://tinkl.qiniudn.com/tinklUpload_DSHJKFLDJSLF.png","http://tinkl.qiniudn.com/tinklUpload_DSHJKFLDJSLF.png"]
        galleryView.setTop(0)
        
        //
        let musicFrame = CGRectMake(0, galleryView.top + galleryView.height, CGRectGetWidth(scrollView.frame), 600)
        let musicView = AIMusicTherapyView(frame: musicFrame)
        //scrollView.addSubview(musicView)
        addNewSubView(musicView, preView: galleryView)
        musicView.backgroundColor = UIColor.clearColor()
        
        ///----
        
//        let paramedicFrame = CGRectMake(0, galleryView.top + galleryView.height, CGRectGetWidth(scrollView.frame), 600)
//        let paramedicView = AIParamedicView(frame: paramedicFrame)
//        //scrollView.addSubview(musicView)
//        addNewSubView(paramedicView, preView: galleryView)
//        paramedicView.backgroundColor = UIColor.clearColor()
        ///---
        
        
        
//
        ///

        let custView =  AICustomView.currentView()
        addNewSubView(custView, preView: musicView)
     
        var model1 = AIBuerSomeTagModel()
        model1.tagName = "irritated"
        model1.unReadNumber = 2
        model1.bsId = 12
        
        var model2 = AIBuerSomeTagModel()
        model2.tagName = "fatigued"
        model2.unReadNumber = 6
        model2.bsId = 13
        
        var model3 = AIBuerSomeTagModel()
        model3.tagName = "endorine disorders"
        model3.unReadNumber = 731
        model3.bsId = 16
        
        
        var model4 = AIBuerSomeTagModel()
        model4.tagName = "disorders the"
        model4.unReadNumber = 69
        model4.bsId = 17
        
        
        var model5 = AIBuerSomeTagModel()
        model5.tagName = "depressed"
        model5.unReadNumber = 18
        model5.bsId = 18
        custView.fillTags([model1,model2,model5,model3,model4], isNormal: true)
        
        let audioView = AICustomAudioNotesView.currentView()
        addNewSubView(audioView, preView: custView)
        audioView.delegateAudio = self
        
        let audio1 = AIAudioMessageView.currentView()
        addNewSubView(audio1, preView: audioView)
        
        let text1 = AITextMessageView.currentView()
        addNewSubView(text1, preView: audio1)
        
        let text2 = AITextMessageView.currentView()
        addNewSubView(text2, preView: text1)
    }
    
    /**
     添加定制的view到scrollview中
     
     - parameter cview:   被添加的view
     - parameter preView: 上一个view
     */
    func addNewSubView(cview:UIView,preView:UIView){
        scrollView.addSubview(cview)
        cview.setWidth(self.view.width)
        cview.setTop(preView.top + preView.height)
        cview.backgroundColor = UIColor(hex: redColor)
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), cview.top + cview.height)
        preCacheView = cview
        
    }
}

extension AIServiceContentViewController:AICustomAudioNotesViewDelegate{
    
    /**
     开始录音处理
     */
    func startRecording() {
        audioView?.hidden = false
    }
    
    //更新Meters 图片处理
    func updateMetersImage(lowPass: Double) {
        var imageName:String = "RecordingSignal001"
        if lowPass >= 0.8 {
            imageName = "RecordingSignal008"
        }else if lowPass >= 0.7 {
            imageName = "RecordingSignal007"
        }else if lowPass >= 0.6 {
            imageName = "RecordingSignal006"
        }else if lowPass >= 0.5 {
            imageName = "RecordingSignal005"
        }else if lowPass >= 0.4 {
            imageName = "RecordingSignal004"
        }else if lowPass >= 0.3 {
            imageName = "RecordingSignal003"
        }else if lowPass >= 0.2 {
            imageName = "RecordingSignal002"
        }else if lowPass >= 0.1 {
            imageName = "RecordingSignal001"
        }else{
            imageName = "RecordingSignal001"
        }
        
        audioView?.passImageView.image = UIImage(named: imageName)
    }
    
    //结束录音添加view到scrollview
    func endRecording(audioUrl: String) {
        audioView?.hidden = true
        // add a new View Model
        let audio1 = AIAudioMessageView.currentView()
        if let cview = preCacheView {
            addNewSubView(audio1, preView: cview)
        }
        
    }
    
    
}
