//
//  AIServiceContentViewController.swift
//  AIVeris
//
//  Created by 王坜 on 15/11/6.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Cartography
import Spring
import AIAlertView

public enum AIServiceContentType : Int {
    case None = 100, MusicTherapy ,Escort
}

// MARK: 返回事件回调

protocol AIServiceContentDelegate : class{
    
    func contentViewWillDismiss ()
    
}


///  - AIServiceContentViewController
internal class AIServiceContentViewController: UIViewController {


    // MARK: -> Internal properties
    
    var serviceContentView : AIServiceParamView?

    // MARK: - Internal properties

    var displayForSeller : Bool = false
    
    weak var contentDelegate : AIServiceContentDelegate?
    
    var curAudioView : AIAudioMessageView?
    
    var curTextField : UITextField?
    
    var configuredParameters : NSMutableDictionary?
    
    var customID : String?
    
    private let redColor : String = "#b32b1d"
    
    var serviceContentModel: AIProposalServiceModel?
    
    var propodalId: Int = 0

    var pageIndex: Int = 0
    
    private var currentDatasource: AIProposalServiceDetailModel?
    
    var serviceContentType : AIServiceContentType = .None
    
    private var topNaviView : AINavigationBarView?

    private var preCacheView: UIView?
    
    private var currentAudioView: AIAudioInputView?
    private var brandView: AIDropdownBrandView?
    private var musicView: AIMusicTherapyView?
    private var paramedicView: AIParamedicView?
    
    private var isfinishLoadData:Bool = false

    private var isStepperEditing = false {
        didSet {
            if isStepperEditing {
                removeKeyboardNotifications()
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { [weak self] () -> Void in
                    // 修复 stepper 编辑时 scrollview 滚到底部的bug
                    self?.addKeyboardNotifications()
                    })
            }
        }
    }
    
    private var scrollViewSubviews = [UIView]()
    
    private lazy var scrollView:UIScrollView = {
        // Setup the paging scroll view
        let result = UIScrollView()
        result.backgroundColor = UIColor.clearColor()
        result.pagingEnabled = false
        result.showsHorizontalScrollIndicator = false
        result.showsVerticalScrollIndicator = false
        result.delegate = self
        result.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
        return result
    }()
    
    private lazy var galleryView : AIGalleryView = {
        let gView = AIGalleryView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 184))
        return gView
    }()
    
    private var audioView_AudioRecordView:AIAudioRecordView?
    
    
    // MARK: Life Cricel..
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        shouldHideKeyboard()
        // 切换视图的时候停止播放录音
        curAudioView?.stopPlay()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AITools.colorWithR(0x1e, g: 0x1b, b: 0x38);
        addKeyboardNotifications()
        /** 导航栏 */
        makeTopView()
        
        //SCI
        makeButtonWithFrame(CGRectMake( self.view.width - 90, 50, 50, 50), action: #selector(AIServiceContentViewController.scrollViewBottom))
        
        // Add Pull To Referesh..
        weak var weakSelf = self
        self.scrollView.addHeaderWithCallback { () -> Void in
            weakSelf!.initData()
        }

        var s = NSStringFromClass(AIServiceContentViewController)
        s = s+"\(self.pageIndex)"
        print(s)
        
        NSNotificationCenter.defaultCenter().addObserverForName(s, object: nil, queue: nil) { (NSNotificationOBJ) -> Void in
            
            guard weakSelf?.isfinishLoadData == true else{
                weakSelf?.loadDataNecessary()
                return
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName("kStepperIsEditing", object: nil, queue: nil) { (NSNotificationOBJ) -> Void in
            weakSelf?.isStepperEditing = Bool(NSNotificationOBJ.object as! Int)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIServiceContentViewController.serviceParamsViewHeightChanged(_:)), name: "kServiceParamsViewHeightChanged", object: nil)
    }
    
    // 缓存输入信息
    private var inputMessageCache:String = ""
    
    // MARK: 取消键盘
    
    func shouldHideKeyboard ()
    {
        if curTextField != nil {
            curTextField?.resignFirstResponder()
            curTextField = nil
        }
    }
    
    
    //MARK: 保存数据
    
    
    func saveDataForVS(vc : AIServiceContentViewController, proposalId : Int, completion:(()->())?=nil) {
        
        let data : NSMutableDictionary = NSMutableDictionary()
        
        if let params : [String : AnyObject] = vc.getAllParameters() {
            
            if params.keys.count > 0 {
                data.addEntriesFromDictionary(params)
                data.setObject(proposalId, forKey: "proposal_id")
                data.setObject(0, forKey: "role_id")
                
                let message = AIMessage()
                message.body.addEntriesFromDictionary(["desc":["data_mode":"0","digest":""],"data":data])
                print(message.body)
                message.url = AIApplication.AIApplicationServerURL.saveServiceParameters.description
                
                AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
                    if let c = completion {
                        c()
                    }
                    }, fail: { (ErrorType : AINetError, error : String!) -> Void in
                        
                })
            }
        }
    }
    
    func saveChangeService( serviceid : Int, completion:(()->())?=nil) {
        
        let data : NSMutableDictionary = NSMutableDictionary()
        let userId : String = NSUserDefaults.standardUserDefaults().objectForKey(kDefault_UserID) as! String
        data.setObject(userId, forKey: "customer_id")
        data.setObject(-1, forKey: "service_id")
        data.setObject((serviceContentModel?.role_id)!, forKey: "role_id")
        data.setObject(propodalId, forKey: "proposal_id")
        data.setObject(["service_id":serviceid], forKey: "save_data")
        
        let message = AIMessage()
        message.body.addEntriesFromDictionary(["desc":["data_mode":"0","digest":""],"data":data])
        print(message.body)
        message.url = AIApplication.AIApplicationServerURL.saveServiceParameters.description
        view.showLoading()
        AINetEngine.defaultEngine().postMessage(message, success: { (response) -> Void in
            self.view.hideLoading()
            }, fail: { [weak self] (ErrorType : AINetError, error : String!) -> Void in
                self?.view.hideLoading()
                self?.serviceContentModel?.service_id = serviceid
                if let c = completion {
                    c()
                }
        })
    }
    
    
    // MARK: 查询金额
    
    func getPriceParameters () -> [String : AnyObject]? {
        var params : [String : AnyObject] = [String : AnyObject]()
        params["service_id"] = currentDatasource?.service_id
        params["customer_id"] = NSUserDefaults.standardUserDefaults().objectForKey("Default_UserID") as? String
        
        return params
    }
    
    // MARK: 参数保存
    
    func getAllParameters () -> [String : AnyObject]? {
   
        var params : [String : AnyObject] = [String : AnyObject]()
        
        if let _ = serviceContentView {
            if let _  = serviceContentView?.getAllParams() {

                params["service_id"] = currentDatasource?.service_id
                params["customer_id"] = NSUserDefaults.standardUserDefaults().objectForKey("Default_UserID") as? String
                params["save_data"] = serviceContentView?.getAllParams()
            }
        }
        
        return params
    }
    
    func cleanAllParameters () {
        configuredParameters?.removeAllObjects()
    }
    

    // MARK: -> Internal init methods
    
    // MARK: 键盘事件
    
    func addKeyboardNotifications () {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIServiceContentViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIServiceContentViewController.keyboardDidShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIServiceContentViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIServiceContentViewController.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIServiceContentViewController.keyboardDidChange(_:)), name: UIKeyboardDidChangeFrameNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        let names = [UIKeyboardWillShowNotification,
            UIKeyboardDidShowNotification,UIKeyboardWillHideNotification,UIKeyboardDidHideNotification,UIKeyboardDidChangeFrameNotification]
        let center = NSNotificationCenter.defaultCenter()
        for name in names {
            center.removeObserver(self, name: name, object: nil)
        }
    }
    
    func keyboardDidChange(notification : NSNotification) {
        if self.isStepperEditing  {
            return
        }
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
        if self.parentViewController == nil {
            return
        }
        
        let parentVC : AIPageBueryViewController = self.parentViewController as! AIPageBueryViewController
        parentVC.pageScrollView.scrollEnabled = false
        if self.isStepperEditing  {
            return
        }
        
        if curTextField == nil {
            return
        }
        
        if let userInfo = notification.userInfo {
            self.currentAudioView?.changeModel(1)
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
        if self.isStepperEditing  {
            return
        }
        
        scrollView.userInteractionEnabled = true
    }
    
    func keyboardWillHide(notification : NSNotification) {
        if self.isStepperEditing  {
            return
        }
        
        if curTextField == nil {
            return
        }
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        scrollViewBottom()
        if let view1 = self.currentAudioView {
            view1.audioButtonView.hidden = false
        }
        
    }    
    
    func keyboardDidHide(notification : NSNotification) {
        
        if self.parentViewController == nil {
            return
        }
        
        let parentVC : AIPageBueryViewController = self.parentViewController as! AIPageBueryViewController
        parentVC.pageScrollView.scrollEnabled = true
        
        if self.isStepperEditing  {
            return
        }
        
        if curTextField == nil {
            return
        }
        
        scrollView.userInteractionEnabled = true
        if let view1 = self.currentAudioView {
            view1.inputButtomValue.constant = 1
        }
    }
    
    func loadDataNecessary(){
        Async.main { () -> Void in
            self.scrollView.headerBeginRefreshing()
        }
    }
    
    func removeContentView () {
        scrollViewSubviews.removeAll()
        for view in scrollView.subviews {
            if view != scrollView.headerView() {
                view.removeFromSuperview()
            }
        }
    }
    
    func initData(){
        
        scrollView.hideErrorView()
  
        BDKProposalService().findServiceDetail(self.serviceContentModel!, proposalId: propodalId,customID : customID, success:
            {[weak self] (responseData) -> Void in
                
                Async.main({ () -> Void in
                    if let strongSelf = self {
                        strongSelf.currentDatasource = responseData
                        
                        //InitControl Data
                        strongSelf.isfinishLoadData  = true
                        /** ScrollView数据填充 */
                        strongSelf.removeContentView()
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
    
    func topImage() -> UIImage {
        var name = "Fake_Top"
        let type : AIServiceContentType = serviceContentType
        switch type {
        case  .MusicTherapy:
            name = "Fake_Top"
        case .Escort:
            name = "Fake_Escort_Top"
        case .None: break
     
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
        
        if let delegate = contentDelegate {
            
            delegate.contentViewWillDismiss()
        } else {
            if let parent = self.parentViewController {
                parent.dismissViewControllerAnimated(true, completion: nil)
            }
            else
            
            {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }

    }
    
    func makeTopView () {
        
        let topView = AINavigationBarView.currentView()
        self.view.addSubview(topView)
        print(topView.height)
        self.view.addSubview(scrollView)
        topView.setWidth(self.view.width)
        scrollView.frame = CGRectMake(0, topView.height , self.view.width, self.view.height-topView.height)
        
        topView.backButton.addTarget(self, action: #selector(AIServiceContentViewController.backAction), forControlEvents: UIControlEvents.TouchUpInside)
        
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
        
    }
    
    /**
     update Position
     
     - parameter animated: YES
     */
    func updateFrames(animated animated:Bool=false) {
        var previousView:UIView = brandView ?? galleryView
        let duration = animated ? 0.25 : 0
        
            let validateViews = scrollViewSubviews.filter { (v) -> Bool in
                return v.superview == scrollView && v != brandView && v != galleryView
                }.sort({ (a, b) -> Bool in
                    return a.y < b.y
                })
        
        UIView.animateWithDuration(duration, animations: { [unowned self] () -> Void in
            
            self.brandView!.isExpanded = !self.brandView!.isExpanded
            validateViews.forEach { (v) -> () in
                var f = v.frame
                f.origin.y = previousView.bottom
                v.frame = f
                previousView = v
            }
            
            self.scrollView.contentSize = CGSizeMake(self.scrollView.width, CGRectGetMaxY((validateViews.last?.frame)!))
            }) { (stop) -> Void in
                
        }
    }
    
    func makeContentView () {
        if self.currentDatasource == nil || self.currentDatasource?.service_name == nil{
            return
        }
        //TODO: Old View Some Logic.
        if self.currentDatasource?.service_name?.length > 0 {
             topNaviView?.backButton.setTitle(self.currentDatasource?.service_name  ?? "", forState: .Normal)
        }
        
        addGalleryView()
        
        var contentView : UIView
        
        if currentDatasource?.service_intro_img_list?.count == 0
        {
            galleryView.setHeight(0)
        }
        
        //TODO: add text for seller
        
        if displayForSeller {
            contentView = AIDetailText(frame: CGRectMake(0, galleryView.bottom + 10, CGRectGetWidth(scrollView.frame), 0), titile: currentDatasource?.service_intro_title, detail: currentDatasource?.service_intro_content)
            addNewSubView(contentView, preView: galleryView, color: UIColor.clearColor())
        }
        else
        {
            //TODO: add brand View
            let parser : AIProposalServiceParser = AIProposalServiceParser(serviceID: (currentDatasource?.service_id)!, serviceParams: currentDatasource?.service_param_list, relatedParams: currentDatasource?.service_param_rel_list, displayParams: currentDatasource?.service_param_display_list)
            
            serviceContentView = AIServiceParamView(frame: CGRectMake(0, galleryView.bottom + 20, CGRectGetWidth(self.view.frame), 100), models: parser.displayModels, rootViewController : self)
            
            serviceContentView?.delegate = self
            serviceContentView!.onDropdownBrandViewSelectedIndexDidChanged = { [weak self] bView, selectedIndex in
                let id = bView.brands[selectedIndex].id
                self?.saveChangeService(id, completion: { () -> () in
                    self?.view.hideLoading()
                    self?.initData()
                })
            }
            // enum all service provider id get the selected service id and index
            if let dropdownBrandView = serviceContentView?.dropdownBrandView {
                for (index,(title:_,image:_,id:serviceId)) in dropdownBrandView.brands.enumerate() {
                    if serviceId == serviceContentModel?.service_id {
                        dropdownBrandView.selectedIndex = index
                    }
                }
            }
            
            serviceContentView!.rootViewController = self.parentViewController
            addNewSubView(serviceContentView!, preView: galleryView, color: UIColor.clearColor())
            serviceContentView!.frame = CGRectMake(0, galleryView.bottom + 10, CGRectGetWidth(self.view.frame), CGRectGetHeight(serviceContentView!.frame))

            contentView = serviceContentView!
        }
        
        //TODO: Add Routine Path View.
        let routeView = addRoutineView()
        addNewSubView(routeView, preView: contentView)
        routeView.backgroundColor = UIColor.clearColor()
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(AIServiceContentViewController.clickRouteViewEvent))
        routeView.addGestureRecognizer(tapGes)
        
        //TODO: Add helpfull views.
        let musicView = addMusicView(routeView)
        
        //TODO: Necessary public View.
        //TODO: DisplayForSeller.
        if let preView = addCustomView(musicView){
             addAudioView(preView)
        }
        
    }
    
    func clickRouteViewEvent(){
        let vc = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIAlertStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIServiceRouteViewController)
        let navigation = UINavigationController(rootViewController: vc)
        self.presentViewController(navigation, animated: true, completion: nil)
        vc.showMenuTitleViewController(navigation,title: "Select")
    }
    
    /**
      路径规划
     
     */
    private func addRoutineView() -> UIView {
        
        let routeView = UIView()
        routeView.frame = CGRectMake(0, 0, self.view.width, 100)
        routeView.backgroundColor = UIColor.clearColor()
        
        let line = UILabel()
        routeView.addSubview(line)
        line.backgroundColor = UIColor(hex: "#302F4D")
        constrain(line) { (titleLayout) in
            titleLayout.left == titleLayout.superview!.left
            titleLayout.right == titleLayout.superview!.right
            titleLayout.top == titleLayout.superview!.top + 1
            titleLayout.height == 0.5
        }
        
        let titleLabel = UILabel()
        routeView.addSubview(titleLabel)
        titleLabel.text = "Routine"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = AITools.myriadSemiCondensedWithSize(15)
        
        constrain(titleLabel) { (titleLayout) in
            titleLayout.left == titleLayout.superview!.left + 10
            titleLayout.top == titleLayout.superview!.top + 5
            titleLayout.height == 20
            titleLayout.width == 100
        }
        
        
        let indicator = UIImageView()
        routeView.addSubview(indicator)
        indicator.image = UIImage(named: "right_triangle")
        constrain(indicator) { (indicatorlayout) in
            indicatorlayout.right == indicatorlayout.superview!.right - 20
            indicatorlayout.top == indicatorlayout.superview!.top + 5
            indicatorlayout.height == 15
            indicatorlayout.width == 8
        }
        
        return routeView
        
    }
    
    
    
    private func addBrandView()-> AIDropdownBrandView? {
        brandView = AIDropdownBrandView(brands: [("Amazon","http://www.easyicon.net/api/resizeApi.php?id=1095742&size=128",321)], selectedIndex: 0, frame: view.frame)
        addNewSubView(brandView!, preView: galleryView, color: UIColor.clearColor())
    
        brandView?.onDownButtonDidClick = { [weak self] bView in
            self?.updateFrames(animated:true)
        }
        
        brandView?.onSelectedIndexDidChanged = { bView, selectedIndex in
            // handle selected index changed 
        }
        return brandView
    }
    
    private func addGalleryView() {
        // Add gallery View

        scrollView.addSubview(galleryView)
        scrollViewSubviews.append(galleryView)
        var imageArray = [String]()
        self.currentDatasource?.service_intro_img_list?.forEach({ imgModel in
            let imageModel = imgModel as! AIProposalServiceDetailIntroImgModel
            imageArray.append(imageModel.service_intro_img ?? "")
        })
        galleryView.imageModelArray = imageArray
        galleryView.setTop(5)
    }
    
    private func addEscortView(preView: UIView?) -> UIView {
        let preView = preView ?? galleryView
        let paramedicFrame = CGRectMake(0, preView.bottom, CGRectGetWidth(scrollView.frame), 600)
        paramedicView = AIParamedicView(frame: paramedicFrame, model: currentDatasource, shouldShowParams: serviceContentType != .None)

        addNewSubView(paramedicView!, preView: preView)
        paramedicView!.backgroundColor = UIColor.clearColor()
        return paramedicView!
    }
    
    private func addCustomView(preView: UIView) -> UIView? {
        
        var viw:UIView = preView
    
        //处理数据填充
        if let wish:AIProposalServiceDetail_WishModel = self.currentDatasource?.wish_list {
            
            let providerView =  AIProviderView.currentView()
            addNewSubView(providerView, preView: viw)
            viw = providerView
            providerView.content.text = wish.intro ?? ""
            
            if displayForSeller == false {
                if wish.label_list != nil || (wish.hope_list != nil) {
                    if    (wish.hope_list.count > 0 || wish.label_list.count > 0) {
                        let custView =  AICustomView.currentView()
                        let heisss = 191 + wish.label_list.count * 15
                        custView.setHeight(CGFloat(heisss))
                        addNewSubView(custView, preView: viw)
                        viw = custView
                        custView.wish_id = self.currentDatasource?.wish_list.wish_id ?? 0
                        if let labelList = wish.label_list as? [AIProposalServiceDetailLabelModel] {
                            custView.fillTags(labelList, isNormal: true)
                        }
                    }
                }
            }
        }
        if view == preView {
            return nil
        }
        return viw
    }
    
    private func addMusicView(preView: UIView?) -> UIView {
        var preView = preView ?? galleryView
        let musicFrame = CGRectMake(0, preView.top + preView.height, CGRectGetWidth(scrollView.frame), 0)
        musicView = AIMusicTherapyView(frame: musicFrame, model: currentDatasource, shouldShowParams: serviceContentType != .None)
        addNewSubView(musicView!, preView: preView)
        musicView!.backgroundColor = UIColor.clearColor()
        return musicView!
    }
    
    private func addAudioView(preView: UIView) {
        
        var preViewContent:UIView = preView
        
        if displayForSeller == false {
            let audioView = AICustomAudioNotesView.currentView()
            addNewSubView(audioView, preView: preView)
            audioView.delegateShowAudio = self
            preViewContent = audioView
        }
        //        audioView.delegateAudio = self
        //        audioView.inputText.delegate = self
        
        //处理语音 文本数据
        //处理数据填充
        if let wish:AIProposalServiceDetail_WishModel = self.currentDatasource?.wish_list {
            if let hopeList = wish.hope_list as? [AIProposalServiceDetailHopeModel] {
                var perViews:UIView?
                for item in hopeList {
                    if item == hopeList.first {
                        perViews = preViewContent
                    }
                    
                    if item.type == "Text" {
                        // text.
                        let newText = AITextMessageView.currentView()
                        newText.content.text = item.text ?? ""
                        let newSize = item.text?.sizeWithFont(AITools.myriadLightSemiCondensedWithSize(36/2.5), forWidth: self.view.width - 50)
                        newText.setHeight(30 + newSize!.height)
                        newText.wishID = wish.wish_id
                        newText.noteID = item.hope_id
                        addNewSubView(newText, preView: perViews!)
                        newText.delegate = self
                        perViews = newText
                        
                    } else if item.type == "Voice" {
                        // audio.
                        let audio1 = AIAudioMessageView.currentView()
                        audio1.audioDelegate = self
                        audio1.deleteDelegate = self
                        addNewSubView(audio1, preView: perViews!)
                        audio1.wishID = wish.wish_id
                        audio1.noteID = item.hope_id
                        audio1.fillData(item)                    
                        audio1.loadingView.hidden = true
                        
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
     - parameter color:   默认红色
     */
    func addNewSubView(cview:UIView,preView:UIView,color:UIColor = UIColor(hex: "b32b1d"),space:CGFloat=0){
        scrollView.addSubview(cview)
        scrollViewSubviews.append(cview)
        cview.setWidth(self.view.width)
        cview.setTop(preView.top + preView.height+space)
        cview.backgroundColor = color
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), cview.top + cview.height)
        preCacheView = cview
    }
    
    func addNewSubView(cview:UIView){
        scrollView.addSubview(cview)
        scrollViewSubviews.append(cview)
        cview.setWidth(self.view.width)
        cview.setTop(scrollView.contentSize.height)
        cview.backgroundColor = UIColor(hex: redColor)
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), cview.top + cview.height)
        preCacheView = cview
        
    }
    
    
}

// MARK: Delegate

extension AIServiceContentViewController: AICustomAudioNotesViewShowAudioDelegate{
    // show audio view...
    func showAudioView(type:Int) {
        //type 0 : audio  1: text
        let childView = AIAudioInputView.currentView()
        childView.alpha = 0
        self.view.addSubview(childView)
        
        childView.delegateAudio = self
        childView.textInput.delegate = self
        childView.inputTextView.delegate = self
        currentAudioView = childView
        
        constrain(childView) { (cview) -> () in
            cview.leading == cview.superview!.leading
            cview.trailing == cview.superview!.trailing
            cview.top == cview.superview!.top
            cview.bottom == cview.superview!.bottom
        }
        SpringAnimation.spring(0.5) { () -> Void in
            childView.inputTextView.text = self.inputMessageCache
            childView.alpha = 1
        }
        
        if type == 1 {
            childView.changeModel(1)
        }else{
            childView.changeModel(0)
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
        return serviceContentType != .None
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return textField.text?.length < 198
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
            
            if let c = currentAudioView {
                c.closeThisView()
            }
        }
        textField.resignFirstResponder()
        textField.text = ""

        return true
    }
}

extension AIServiceContentViewController: AICustomAudioNotesViewDelegate, AIAudioMessageViewDelegate{
    
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
    func endRecording(audioModel: AIProposalServiceDetailHopeModel) {

        audioView_AudioRecordView?.hidden = true
        if audioModel.time > 1000 {
            // add a new View Model
            let audio1 = AIAudioMessageView.currentView()
            audio1.audioDelegate = self
            
            addNewSubView(audio1)
            audio1.fillData(audioModel)
            audio1.deleteDelegate = self
            scrollViewBottom()
            
            audio1.loadingView.startAnimating()
            audio1.loadingView.hidden = false
            
            // upload

            let wishid = self.currentDatasource?.wish_list.wish_id ?? 0
            let message = AIMessageWrapper.addWishNoteWithWishID(wishid, type: "Voice", content: audioModel.audio_url, duration: audioModel.time)
            message.url = AIApplication.AIApplicationServerURL.addWishListNote.description
            audio1.messageCache = message
            weak var weakSelf = self
            AIRemoteRequestQueue().asyncRequset(audio1, message: message, successRequst: { (subView,response) -> Void in
                if let eView = subView as? AIAudioMessageView {
                    
                    eView.loadingView.stopAnimating()
                    eView.loadingView.hidden = true
                    eView.errorButton.hidden = true
                    
                    let NoteId = response["NoteId"] as? NSNumber
                    eView.noteID = NoteId?.integerValue ?? 0
                }
                
                weakSelf!.view.dismissLoading()
                
                }, fail: { (errorView, error) -> Void in
                    if let eView = errorView as? AIAudioMessageView {
                        eView.loadingView.stopAnimating()
                        eView.loadingView.hidden = true
                        eView.errorButton.hidden = false
                    }
                    
                    weakSelf!.view.dismissLoading()
                    AIAlertView().showInfo("AIErrorRetryView.NetError".localized, subTitle: "AIAudioMessageView.info".localized, closeButtonTitle: "AIAudioMessageView.close".localized, duration: 3)
            })
            
        }
        else {
            AIAlertView().showInfo("AIServiceContentViewController.record".localized, subTitle: "AIAudioMessageView.info".localized, closeButtonTitle: "AIAudioMessageView.close".localized, duration: 3)
        }
        
        if let c = currentAudioView {
            c.closeThisView()
        }
    }
    
    
    // 即将结束录音
    func willEndRecording() {
        
    }
    
    func cacheMessage(message: String?) {
        if let meg = message{
            self.inputMessageCache = meg
        }
    }
    
    // 录音发生错误
    func endRecordingWithError(error: String) {
        
    }
    
    func scrollViewBottom(){
        let bottomPoint = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
        self.scrollView.setContentOffset(bottomPoint, animated: true)
    }
    
}

// MARK: 参数修改回调

extension AIServiceContentViewController : AIBuyerParamsDelegate {
    @objc func getSelectedParams() -> [AnyObject]? {

        var selectedParams : [AnyObject]?
        
        if let musicParams = musicView?.getSelectedParams() {
            selectedParams = []
            selectedParams? += musicParams
        }
        
        if let paramedicParams = paramedicView?.getSelectedParams() {
            selectedParams = []
            selectedParams? += paramedicParams
        }
    
        return selectedParams
    }
}


extension AIServiceContentViewController : AIDeleteActionDelegate {
    
    func retrySendRequestAction(cell: UIView?) {
        if let audio1 = cell as? AIAudioMessageView {
            if let m = audio1.messageCache {
                AIRemoteRequestQueue().asyncRequset(audio1, message: m, successRequst: { (subView,response) -> Void in
                    if let eView = subView as? AIAudioMessageView {
                        eView.loadingView.stopAnimating()
                        eView.loadingView.hidden = true
                        eView.errorButton.hidden = true
                        
                        let NoteId = response["NoteId"] as? NSNumber
                        eView.noteID = NoteId?.integerValue ?? 0
                    }
                    
                    }, fail: { (errorView, error) -> Void in
                        if let eView = errorView as? AIAudioMessageView {
                            eView.loadingView.stopAnimating()
                            eView.loadingView.hidden = true
                            eView.errorButton.hidden = false
                        }
                })
            }
            
        }
        
        
    }
    
    
    func deleteAnimation (cell: UIView?) {
        SpringAnimation.springWithCompletion(0.3, animations: { () -> Void in
            
            cell?.alpha = 0
            //刷新UI
            let height = cell?.height ?? 0
            print("delete view: \(height)")
            let top = cell?.top
            
            let newListSubViews = self.scrollView.subviews.filter({ (subview) -> Bool in
                return subview.top > top
            })
            
            for nsubView in newListSubViews {
                nsubView.setTop(nsubView.top - height)
            }
            
            var contentSizeOld = self.scrollView.contentSize
            print(contentSizeOld.height)
            contentSizeOld.height -= height
            self.scrollView.contentSize = contentSizeOld            
            
            }) { (complate) -> Void in
                cell?.removeFromSuperview()
        }

    }
    
    
    func deleteAction(cell: UIView?) {
        
        let noteView = cell as? AIWishMessageView
        self.view.userInteractionEnabled = false
        self.view.showLoading()
        let message = AIMessageWrapper.deleteWishNoteWithWishID((noteView?.wishID)!, noteID: (noteView?.noteID)!)
        message.url = AIApplication.AIApplicationServerURL.delWishListNote.description
        
        weak var weakSelf = self
        AINetEngine.defaultEngine().postMessage(message, success: { (response ) -> Void in
            print(response)
            weakSelf!.deleteAnimation(cell)
            weakSelf!.view.hideLoading()
            weakSelf!.view.userInteractionEnabled = true
            }, fail: { (errorType : AINetError, errorStr:String!) -> Void in
                weakSelf!.view.hideLoading()
                weakSelf!.view.userInteractionEnabled = true
                AIAlertView().showInfo("AIAudioMessageView.info".localized, subTitle:"AIServiceContentViewController.wishDeleteError".localized , closeButtonTitle: "AIAudioMessageView.close".localized, duration: 3)
                
        })
        
        
    }
}

extension AIServiceContentViewController : UITextViewDelegate {
   
    func textViewDidChange(textView: UITextView) {
        if textView.text.length > 160 {
            let str = NSString(string: textView.text)
            let newStr = str.substringToIndex(160)
            textView.text = newStr
        }
        
        if let s = currentAudioView {
            
            if textView.contentSize.height < 100 {
                s.inputHeightConstraint.constant = 5 + textView.contentSize.height
            }else{
                s.inputHeightConstraint.constant = 5 + 97
            }
            textView.scrollRangeToVisible(NSMakeRange(0,0))
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if serviceContentType == .None
        {
            return false
        }
        
        if "\n" == text {
            textView.resignFirstResponder()
            self.inputMessageCache = "" //清空
            // add a new View Model
            let newText = AITextMessageView.currentView()
            newText.content.text = textView.text
            let newSize = textView.text?.sizeWithFont(AITools.myriadLightSemiCondensedWithSize(36/2.5), forWidth: self.view.width - 50)
            newText.setHeight(25 + newSize!.height) //30
            //addNewSubView(newText, preView: cview)
            addNewSubView(newText)
            scrollViewBottom()
            
            newText.delegate = self
            
            if let c = currentAudioView {
                c.closeThisView()
            }
            
            // add
            self.view.userInteractionEnabled = false
            view.showLoading()
            weak var weakSelf = self
            let message = AIMessageWrapper.addWishNoteWithWishID(currentDatasource?.wish_list.wish_id ?? 0, type: "Text", content: newText.content.text, duration: 0)
            message.url = AIApplication.AIApplicationServerURL.addWishListNote.description      
            newText.wishID = currentDatasource?.wish_list.wish_id ?? 0
            AIRemoteRequestQueue().asyncRequset(newText, message: message, successRequst: { (subView,response) -> Void in
                if let eView = subView as? AITextMessageView {
                    weakSelf!.view.hideLoading()
                    let NoteId = response["NoteId"] as? String ?? "0"
                    eView.noteID = Int(NoteId) ?? 0
                }
                weakSelf!.view.userInteractionEnabled = true
                
                }, fail: { (errorView, error) -> Void in
                    weakSelf!.view.hideLoading()
                    AIAlertView().showInfo("AIErrorRetryView.NetError".localized, subTitle: "AIAudioMessageView.info".localized, closeButtonTitle: "AIAudioMessageView.close".localized, duration: 3)
                    weakSelf!.view.userInteractionEnabled = true
            })
            return false
        }
        
        return true
    }
    
    func serviceParamsViewHeightChanged(notification:NSNotification) {
        if let obj = notification.object as? Dictionary<String,AnyObject> {
            let view = obj["view"] as! UIView
            if let _ = scrollView.subviews.indexOf(view) {
                let offset = obj["offset"] as! CGFloat
                moveViewsBelow(view, offset: offset)
            }
        }
    }
    
    func moveViewsBelow(view : UIView, offset : CGFloat) {
        let validateViews = scrollViewSubviews
        let anchor = validateViews.indexOf(view)! + 1

        // move
        
        for index : Int in anchor ..< scrollViewSubviews.count {
            let sview : UIView = scrollViewSubviews[index]
            if let v = sview as? AIMusicTherapyView {
                print(v)
            }
            var frame = sview.frame
            frame.origin.y += offset
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                sview.frame = frame
            })
        
        }
        
        var s = scrollView.contentSize
        s.height = CGRectGetMaxY(scrollView.subviews.last!.frame)
        scrollView.contentSize = s
    }
}

extension AIServiceContentViewController:AIServiceParamViewDelegate {
   
    func serviceParamsViewHeightChanged(offset : CGFloat, view : UIView) {
    }
    
     //MARK: 处理更新金额请求
    func newPriceNeedQuery(paramView:AIServiceParamView, body: NSDictionary) {
        let message = AIMessage()
        message.body = paramView.priceRelatedParam(body)
        message.url = AIApplication.AIApplicationServerURL.findServicePrice.description
        self.view.showLoading()
        AINetEngine.defaultEngine().postMessage(message, success: {[weak self] (response) -> Void in
            self?.view.hideLoading()
                paramView.modifyPrice(response)
            
            }, fail: {[weak self]  (ErrorType : AINetError, error : String!) -> Void in
                self?.view.hideLoading()
        })
    }
}