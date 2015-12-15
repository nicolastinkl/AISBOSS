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
import AIAlertView

public enum AIServiceContentType : Int {
    case MusicTherapy = 100 ,Escort
}

///  - AIServiceContentViewController
internal class AIServiceContentViewController: UIViewController {

    // MARK: -> Internal properties
    
    
    var curAudioView : AIAudioMessageView?
    
    var curTextField : UITextField?
    
    private let redColor : String = "b32b1d"
    
    var serviceContentModel:AIProposalServiceModel?

    private var currentDatasource:AIProposalServiceDetailModel?
    
    internal var serviceContentType : AIServiceContentType!
    
    private var topNaviView : AINavigationBarView?

    private var preCacheView:UIView?
    
    private var currentAudioView:AIAudioInputView?
    
    private lazy var scrollView:UIScrollView = {
        // Setup the paging scroll view
        let pageScrollView = UIScrollView()
        pageScrollView.backgroundColor = UIColor.clearColor()
        pageScrollView.pagingEnabled = false
        pageScrollView.showsHorizontalScrollIndicator = false
        pageScrollView.showsVerticalScrollIndicator = false
        pageScrollView.delegate = self
        return pageScrollView
    }()
    
    private lazy var galleryView : AIGalleryView = {
        let gView = AIGalleryView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200))
        return gView
    }()
    
    private var audioView_AudioRecordView:AIAudioRecordView?
    
    // MARK: -> Internal init methods
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        shouldHideKeyboard()
        // 切换视图的时候停止播放录音
        curAudioView?.stopPlay()
    }
    
    // MARK: 取消键盘
    
    func shouldHideKeyboard ()
    {
        if curTextField != nil {
            curTextField?.resignFirstResponder()
            curTextField = nil
        }
    }
    
    // MARK: 键盘事件
    
    func addKeyboardNotifications () {
       NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidChange:", name: UIKeyboardDidChangeFrameNotification, object: nil)

    }
    
    func keyboardDidChange(notification : NSNotification) {
        //change keyboard height
        
        if let userInfo = notification.userInfo {
            
            // step 1: get keyboard height
            let keyboardRectValue : NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            let keyboardRect : CGRect = keyboardRectValue.CGRectValue()
            let keyboardHeight : CGFloat = min(CGRectGetHeight(keyboardRect), CGRectGetWidth(keyboardRect))
            if let view1 = self.currentAudioView {
                if keyboardHeight > 0 {
                    let newLayoutConstraint = keyboardHeight - view1.holdViewHeigh
                    view1.inputButtomValue.constant = newLayoutConstraint
                }
            }
            
        }
        
    }
    
    func keyboardWillShow(notification : NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            // step 1: get keyboard height
            let keyboardRectValue : NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
            let keyboardRect : CGRect = keyboardRectValue.CGRectValue()
            let keyboardHeight : CGFloat = min(CGRectGetHeight(keyboardRect), CGRectGetWidth(keyboardRect))
        
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
            scrollViewBottom()
            
            // hidden
            if let view1 = self.currentAudioView {
                view1.audioButtonView.hidden = true
            }
            
        }
    }
    
    func keyboardDidShow(notification : NSNotification) {
        scrollView.userInteractionEnabled = true
    }
    
    func keyboardWillHide(notification : NSNotification) {
 
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        scrollViewBottom()
        
    }    
    
    func keyboardDidHide(notification : NSNotification) {
        scrollView.userInteractionEnabled = true
        if let view1 = self.currentAudioView {
            view1.inputButtomValue.constant = 1

            view1.audioButtonView.hidden = false
        }
    }
    

    // MARK: Life Cricel..
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addKeyboardNotifications()
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
        
        Async.main { () -> Void in
            self.scrollView.headerBeginRefreshing()
        }
    }
    
    func initData(){
        
        self.scrollView.hideErrorView()
        
        BDKProposalService().findServiceDetail(self.serviceContentModel?.service_id ?? 0, success:
            {[weak self] (responseData) -> Void in
                
                Async.main({ () -> Void in
                    if let strongSelf = self {
                        strongSelf.currentDatasource = responseData
                        
                        //InitControl Data
                        
                        /** ScrollView数据填充 */
                        strongSelf.makeContentView()
                        strongSelf.scrollView.headerEndRefreshing()
                    }
                })
                
                
                
            },fail : {[weak self]
                (errType, errDes) -> Void in
                print(errDes)
                
                Async.main({ () -> Void in
                    if let strongSelf = self {
                        
                        strongSelf.scrollView.headerEndRefreshing()
                        //处理错误警告
                        
                        strongSelf.scrollView.showErrorContentView()
                        
                    }
                })
                
                
            })
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        
        /*
        self.parentViewController!.view.showLoadingWithMessage("Please Wait...")
        
        Async.main(after: Double(0.5)) { () -> Void in
            self.parentViewController!.view.dismissLoading()
            self.parentViewController!.dismissViewControllerAnimated(true, completion: nil)
        }
        */
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
        /*
        audioView_AudioRecordView =  AIAudioRecordView.currentView()
        if let auView = audioView_AudioRecordView {
            self.view.addSubview(auView)
            auView.hidden = true
            auView.setWidth(self.view.width)
            auView.setTop((self.view.height - auView.height)/2)
        }*/
        
        topNaviView = topView
        
        // 数据填充
        //topNaviView?.backButton.setTitle(serviceContentModel?.service_desc ?? "", forState: UIControlState.Normal)
    }    
    
    func makeContentView () {
        
        if self.currentDatasource?.service_name.length > 0 {
             topNaviView?.backButton.setTitle(self.currentDatasource?.service_name  ?? "", forState: UIControlState.Normal)
        } 
        
        addGalleryView()

        var serviceContentView: UIView!
        if self.serviceContentType == AIServiceContentType.Escort {
            //陪护
            serviceContentView = addEscortView()
        } else {
            //音乐疗养
            serviceContentView = addMusicView()
        }
   
        let custView =  addCustomView(serviceContentView)
        
        addAudioView(custView)
    }
    
    private func addGalleryView() {
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
    }
    
    private func addEscortView() -> UIView {
        let paramedicFrame = CGRectMake(0, galleryView.top + galleryView.height, CGRectGetWidth(scrollView.frame), 600)
        let paramedicView = AIParamedicView(frame: paramedicFrame, model: currentDatasource)
        addNewSubView(paramedicView, preView: galleryView)
        paramedicView.backgroundColor = UIColor.clearColor()
        return paramedicView
    }
    
    private func addCustomView(preView: UIView) -> AICustomView {
        let custView =  AICustomView.currentView()
        addNewSubView(custView, preView: preView)
        
        //处理数据填充
        if let wish:AIProposalServiceDetail_wish_list_listModel = self.currentDatasource?.wish_list {
            if let labelList = wish.label_list as? [AIProposalServiceDetail_label_list_listModel] {
                custView.fillTags(labelList, isNormal: true)
            }
            custView.content.text = wish.intro ?? ""
            
        }
        
        return custView
    }
    
    private func addMusicView() -> UIView {
        let musicFrame = CGRectMake(0, galleryView.top + galleryView.height, CGRectGetWidth(scrollView.frame), 600)
        let musicView = AIMusicTherapyView(frame: musicFrame, model: currentDatasource)
        addNewSubView(musicView, preView: galleryView)
        musicView.backgroundColor = UIColor.clearColor()
        return musicView
    }
    
    private func addAudioView(preView: UIView) {
        let audioView = AICustomAudioNotesView.currentView()
        addNewSubView(audioView, preView: preView)
        audioView.delegateShowAudio = self
        //        audioView.delegateAudio = self
        //        audioView.inputText.delegate = self
        
        
        //处理语音 文本数据
        //处理数据填充
        if let wish:AIProposalServiceDetail_wish_list_listModel = self.currentDatasource?.wish_list {
            if let hopeList = wish.hope_list as? [AIProposalServiceDetail_hope_list_listModel] {
                var perViews:UIView?
                for item in hopeList {
                    if item == hopeList.first {
                        perViews = audioView
                    }
                    
                    if item.type == 1 {
                        // text.
                        let newText = AITextMessageView.currentView()
                        newText.content.text = item.text ?? ""
                        let newSize = item.text?.sizeWithFont(AITools.myriadLightSemiCondensedWithSize(36/2.5), forWidth: self.view.width - 50)
                        newText.setHeight(30 + newSize!.height)
                        addNewSubView(newText, preView: perViews!)
                        newText.delegate = self
                        perViews = newText
                        
                    } else if item.type == 2 {
                        // audio.
                        let audio1 = AIAudioMessageView.currentView()
                        audio1.audioDelegate = self
                        audio1.deleteDelegate = self
                        addNewSubView(audio1, preView: perViews!)
                        audio1.fillData(item)
                        perViews = audio1
                    }
                }
                if let s = perViews {
                    self.preCacheView = s
                }
                
            }
        }
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

// MARK: Delegate

extension AIServiceContentViewController:AICustomAudioNotesViewShowAudioDelegate{
    // show audio view...
    func showAudioView() {
        let childView = AIAudioInputView.currentView()
        childView.alpha = 0
        self.view.addSubview(childView)
        
        childView.delegateAudio = self
        childView.textInput.delegate = self
        
        currentAudioView = childView
        
        
        layout(childView) { (cview) -> () in
            cview.leading == cview.superview!.leading
            cview.trailing == cview.superview!.trailing
            cview.top == cview.superview!.top
            cview.bottom == cview.superview!.bottom
        }
        spring(0.5) { () -> Void in
            childView.alpha = 1
        }
        
        
    }
    
}

extension AIServiceContentViewController: UITextFieldDelegate,UIScrollViewDelegate{
    
// MARK: ScrollDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if curTextField != nil {
            shouldHideKeyboard()
        }
    }
    

    func textFieldDidBeginEditing(textField: UITextField) {
        curTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        //scrollView.userInteractionEnabled = false
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.length < 198
        {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // add a new View Model
        let newText = AITextMessageView.currentView()
        if let cview = preCacheView {
            newText.content.text = textField.text
            let newSize = textField.text?.sizeWithFont(AITools.myriadLightSemiCondensedWithSize(36/2.5), forWidth: self.view.width - 50)
            newText.setHeight(30 + newSize!.height)
            addNewSubView(newText, preView: cview)
            scrollViewBottom()
            newText.delegate = self
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
        audioView_AudioRecordView?.hidden = false
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
        
        audioView_AudioRecordView?.passImageView.image = UIImage(named: imageName)
    }
    
    //结束录音添加view到scrollview
    func endRecording(audioModel: AIProposalServiceDetail_hope_list_listModel) {

        audioView_AudioRecordView?.hidden = true
        if audioModel.time > 1000 {
            // add a new View Model
            let audio1 = AIAudioMessageView.currentView()
            audio1.audioDelegate = self
            if let cview = preCacheView {
                addNewSubView(audio1, preView: cview)
                audio1.fillData(audioModel)
                audio1.deleteDelegate = self
                scrollViewBottom()
            }
        }
        else {
            AIAlertView().showInfo("AIServiceContentViewController.record".localized, subTitle: "AIAudioMessageView.info".localized, closeButtonTitle: "AIAudioMessageView.close".localized, duration: 3)
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
            //刷新UI
            let height = cell?.height ?? 0
            let top = cell?.top
            
            let newListSubViews = self.scrollView.subviews.filter({ (subview) -> Bool in
                return subview.top > top
            })
            
            for nsubView in newListSubViews {
                nsubView.setTop(nsubView.top - height)
            }
         
            var contentSizeOld = self.scrollView.contentSize
            contentSizeOld.height -= height
            self.scrollView.contentSize = contentSizeOld
            
            }) { (complate) -> Void in
                cell?.removeFromSuperview()
        }
        
    }
}
