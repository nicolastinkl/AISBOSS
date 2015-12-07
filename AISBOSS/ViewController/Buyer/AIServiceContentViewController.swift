//
//  AIServiceContentViewController.swift
//  AIVeris
//
//  Created by 王坜 on 15/11/6.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography
import AISpring

public enum AIServiceContentType : Int {
    case MusicTherapy = 100 ,Escort
}

///  - AIServiceContentViewController
internal class AIServiceContentViewController: UIViewController {

    // MARK: -> Internal properties
    
    
    var curAudioView : AIAudioMessageView?
    
    
    private let redColor : String = "b32b1d"
    
    var serviceContentModel:AIProposalServiceModel?

    private var currentDatasource:AIProposalServiceDetailModel?
    
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
        let gView = AIGalleryView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200))
        return gView
    }()
    
    private var audioView:AIAudioRecordView?
    
    // MARK: -> Internal init methods
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 切换视图的时候停止播放录音
        curAudioView?.stopPlay()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        /** 导航栏 */
        makeTopView()
     
        //SCI
        makeButtonWithFrame(CGRectMake( self.view.width - 90, 50, 50, 50), action: "scrollViewBottom")        
        
        // Add Pull To Referesh..
        self.scrollView.addHeaderWithCallback { [weak self]() -> Void in
            if let strongSelf = self {
                // Init Data
                /** 处理数据请求 */
                strongSelf.initData()
                
            }
        }
        
        self.scrollView.headerBeginRefreshing()
        
        
        /**
        Notification Keyboard...
        */
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func initData(){
        
        self.scrollView.hideErrorView()
        
        Async.userInitiated(after: 0.5) {[weak self]  () -> Void in
            if let strongSelfss = self {
                BDKProposalService().queryCustosmerServiceDetail(strongSelfss.serviceContentModel?.service_id ?? 0, success:
                    {[weak self] (responseData) -> Void in
                        
                        if let strongSelf = self {
                            strongSelf.currentDatasource = responseData
                            
                            //InitControl Data
                            
                            /** ScrollView数据填充 */
                            strongSelf.makeContentView()

                            strongSelf.scrollView.headerEndRefreshing()
                        }
                        
                    },fail : {[weak self]
                        (errType, errDes) -> Void in
                        print(errDes)
                        
                        if let strongSelf = self {
                            
                            strongSelf.scrollView.headerEndRefreshing()
                            //处理错误警告
                            
                            strongSelf.scrollView.showErrorContentView()
                            
                        }
                        
                })
            }
            
        }
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShowNotification(notification: NSNotification) {
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0)
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
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
        self.parentViewController!.dismissViewControllerAnimated(true, completion: nil)
        //self.dismissViewControllerAnimated(true, completion: nil)
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
        if self.serviceContentType == AIServiceContentType.Escort {
          //  topView.naviDetailBar?.backgroundColor = UIColor(hex: "")
        }
        
        //init recording view
        audioView =  AIAudioRecordView.currentView()
        if let auView = audioView {
            self.view.addSubview(auView)
            auView.hidden = true
            auView.setWidth(self.view.width)
            auView.setTop((self.view.height - auView.height)/2)
        }
         
        // 数据填充
        topView.backButton.setTitle(serviceContentModel?.service_desc ?? "", forState: UIControlState.Normal)
        
    }    
    
    func makeContentView () {
        
        // Add gallery View
        scrollView.addSubview(galleryView)
        
        var imageArray = [String]()
        _ = self.currentDatasource?.service_intro_img_list.filter({ (imgModel) -> Bool in
            let imageModel = imgModel as! AIProposalServiceDetail_Intro_img_listModel
            imageArray.append(imageModel.service_intro_img ?? "")
            return true
        })
        galleryView.imageModelArray = imageArray
        galleryView.setTop(5)

        var holdView:UIView?
        if self.serviceContentType == AIServiceContentType.Escort {
            //陪护
//            galleryView.imageModelArray = ["http://tinkl.qiniudn.com/tinklUpload_FreeLancer@3x.png","http://tinkl.qiniudn.com/tinklUpload_FreeLancer@3x.png","http://tinkl.qiniudn.com/tinklUpload_FreeLancer@3x.png","http://tinkl.qiniudn.com/tinklUpload_FreeLancer@3x.png"]
            
            
            let paramedicFrame = CGRectMake(0, galleryView.top + galleryView.height, CGRectGetWidth(scrollView.frame), 600)
            let paramedicView = AIParamedicView(frame: paramedicFrame, model: currentDatasource)
            //scrollView.addSubview(musicView)
            addNewSubView(paramedicView, preView: galleryView)
            paramedicView.backgroundColor = UIColor.clearColor()
            holdView = paramedicView
        }else{
            //音乐疗养
            
            let musicFrame = CGRectMake(0, galleryView.top + galleryView.height, CGRectGetWidth(scrollView.frame), 600)
            let musicView = AIMusicTherapyView(frame: musicFrame, model: currentDatasource)
            //scrollView.addSubview(musicView)
            addNewSubView(musicView, preView: galleryView)
            musicView.backgroundColor = UIColor.clearColor()
            holdView = musicView
        }
           
        let custView =  AICustomView.currentView()
        addNewSubView(custView, preView: holdView!)
        
        //处理数据填充
        if let wish:AIProposalServiceDetail_wish_list_listModel = self.currentDatasource?.wish_list {
            if var labelList = wish.label_list as? [AIProposalServiceDetail_label_list_listModel] {
                if labelList.count > 5 {
                    labelList.removeLast()
                }
                custView.fillTags(labelList, isNormal: true)
            }
            custView.content.text = wish.intro ?? ""
        }
        
        let audioView = AICustomAudioNotesView.currentView()
        addNewSubView(audioView, preView: custView)
        audioView.delegateAudio = self
        audioView.inputText.delegate = self
        
        let audio1 = AIAudioMessageView.currentView()
        audio1.delegate = self
        addNewSubView(audio1, preView: audioView)
        
        let model = AIProposalHopeAudioTextModel()
        model.audio_url = ""
        model.audio_length = 8
        model.type = 0
        audio1.fillData(model)
        audio1.delegate = self
        
        let text1 = AITextMessageView.currentView()
        addNewSubView(text1, preView: audio1)
        text1.delegate = self
        
        let text2 = AITextMessageView.currentView()
        addNewSubView(text2, preView: text1)
        text2.delegate = self
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

// MARK : Delegate

extension AIServiceContentViewController: UITextFieldDelegate{

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // add a new View Model
        let audio1 = AITextMessageView.currentView()
        if let cview = preCacheView {

            addNewSubView(audio1, preView: cview)
            audio1.content.text = textField.text
            scrollViewBottom()
            audio1.delegate = self
        }
        textField.resignFirstResponder()
        textField.text = ""

        return true
    }
}

extension AIServiceContentViewController:AICustomAudioNotesViewDelegate, AIAudioMessageViewDelegate{
    
    
    
    // AIAudioMessageViewDelegate
    func willPlayRecording(audioView :AIAudioMessageView) {
        curAudioView?.stopPlay()
        curAudioView = audioView;
    }
    
    func didEndPlayRecording(audioView :AIAudioMessageView) {
        curAudioView = nil
    }
    
    
    
    
    
    
    /**
     开始录音处理
     */
    func willStartRecording() {
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
    func endRecording(audioModel: AIProposalHopeAudioTextModel) {
        audioView?.hidden = true
        if audioModel.audio_length > 0 {
            // add a new View Model
            let audio1 = AIAudioMessageView.currentView()
            audio1.delegate = self
            if let cview = preCacheView {
                addNewSubView(audio1, preView: cview)
                audio1.fillData(audioModel)
                audio1.delegate = self
                scrollViewBottom()
            }
        }
        
    }
    
    
    // 即将结束录音
    func willEndRecording() {
        
    }
    
    
    // 录音发生错误
    func endRecordingWithError(error: String) {
        
    }
    
    func scrollViewBottom(){
        let bottomPoint = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
        self.scrollView.setContentOffset(bottomPoint, animated: true)
    }
    
    
}

extension AIServiceContentViewController : AIDeleteActionDelegate{
    
    func deleteAction(cell: UIView?) {
        
        springWithCompletion(0.3, animations: { () -> Void in
             cell?.alpha = 0
            }) { (complate) -> Void in
                cell?.removeFromSuperview()
        }
        
    }
}
