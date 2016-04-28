//
//  UITransViewController.swift
//  AITrans
//
//  Created by tinkl on 23/6/2015.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//

import Foundation
import UIKit
import Spring
import MediaPlayer
import AIAlertView
import Cartography
import MediaPlayer
import YYImage

/*!
Cell identifier
*/
enum Cell_Identifier:Int{
    case Cell_TOP = 0
    case Cell_MEDIA = 1
    case Cell_CONTENT = 2
    case Cell_ACTION = 3
}
enum View_Tag:Int{
    case View_TOP = 11
    case View_MEDIA = 12
    case View_CONTENT = 13
    case View_ACTION = 14
}


/*!
*  @author tinkl, 15-06-23 17:06:16
*
*  Create Main View Controller
*/
class UITransViewController: UIViewController {
 
    // MARK: - viewController variables
    
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var swipeView: SpringView!
    
    @IBOutlet weak var closeImage: UIImageView!

    @IBOutlet weak var videoView: SpringView!
    @IBOutlet weak var filterImage: UIImageView!
    @IBOutlet weak var topMessageLabel: UILabel!
    @IBOutlet weak var topMessageView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var topMessageUnitLabel: UILabel!
    // MARK: - variable
    private var AIPathTableSlideInOffset:CGFloat = 16

    private let AITopMargeHeight:CGFloat = 10
    
    private var lastExpandedCell = -1
    private var selectedColor: AIColorFlag?
    private var player:YYAnimatedImageView = {
        let image = YYImage(imageLiteral: "loading")
        let imageView = YYAnimatedImageView(image: image)
        imageView.backgroundColor = UIColor.blackColor()
        return imageView
    }()
    
    let gradientLayer = CAGradientLayer()
    var tableViewFrameY:CGFloat?
    var filterTagViewFrameY:CGFloat?
    
    let LNNotificationAnimationDuration:NSTimeInterval = 0.5
    let TopMessageHeight:CGFloat = 75
    let TopMenuHeight:CGFloat = 70
    
    var dataSource: [AITransformContentModel]?
    var transformManager: AITransformManager?
    private var operateIndex: Int?
    
    //topMenuVariables
    var lastScrollPosition:CGFloat = 0.0
    var isReverseScroll:Bool = false
    var lastScrollDirection = "up"
    var isEnable = true
    
    var moviePlayer:MPMoviePlayerController?
    
    private var tagPreButton:UIButton?
    
    private var selectIndex:Int?
    
    // MARK: VAR
    var swipeView:AISwipeView = {
        return  AISwipeView.current()
        }()
    
    var topMenuDiyView:AIMenuTopView = {
            return AIMenuTopView.currentView()
        }()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /*!
        init swipeView
        */
        self.swipeView.delegate = self
        self.swipeView.setSuperScrollView(tableView)

        /*!
        init data
        */
        loadContentData()
        
        //add by liuxian
        setupLayer()
        bottomView.layer.addSublayer(gradientLayer)
        
        // FIXME: Action .. 
        self.view.addSubview(topMenuDiyView)
        topMenuDiyView.setTop(0)
        topMenuDiyView.alpha = 0
        topMenuDiyView.delegate = self
        topMenuDiyView.setWidth(self.view.width)
        
        self.videoView.hidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UITransViewController.PlayerPlaybackDidFinish), name: MPMoviePlayerPlaybackDidFinishNotification, object: moviePlayer)

        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0)
        
        
        /*
        First of all, We have to setting self.tableView.tableHeaderView's View and self.tableView.tableFooterView backgroundImageView. So next step you can see in the self.view display.
        */
        
        localCode({
            let labelBg = self.tableView.tableHeaderView?.viewWithTag(1) as! UILabel
            labelBg.backgroundColor = UIColor(patternImage: UIImage(named: "item_card_black_bgcun")!)
            
            let labelBg2 = self.tableView.tableFooterView?.viewWithTag(1) as! UILabel
            labelBg2.backgroundColor = UIColor(patternImage: UIImage(named: "item_card_black_bgcun")!)
            
        })
        setupLanguageNotification()
    }
    
    func setupLanguageNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UITransViewController.setupUIWithCurrentLanguage), name: LCLLanguageChangeNotification, object: nil)
    }
    
    func setupUIWithCurrentLanguage() {
        //TODO: reload data with current language
    }
    
    
    
    // Play end.
    func PlayerPlaybackDidFinish() {
        
        for videoV in self.videoView.subviews as [UIView] {
            videoV.removeFromSuperview()
        }
        self.videoView.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
        The ViewwillAppear haved fixd bug: interactivePopGestureRecognizer not reponse to userInitiated.
        */
        self.navigationController?.interactivePopGestureRecognizer!.delegate = nil

    }
        
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        /*
        Tell our TableView to reload, since items will now be
        reorganized into sections (or not), and thus will be identified by
        different NSIndexPaths.
        */
        self.tableView.reloadData()
        
    }
    
    // MARK: - Actions
    
    private func showNextViewController()
    {
        self.view.userInteractionEnabled = true
        if let data = self.dataSource {
            let model = data[selectIndex ?? 0]
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewIdentifiers.AIScanViewController) as! AIScanViewController
            viewController.varTitle = model.favoriteTitle ?? ""
            self.showViewController(viewController, sender: self)
        }else{
            //TEST
            
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewIdentifiers.AIScanViewController) as! AIScanViewController
            viewController.varTitle = ""
            self.showViewController(viewController, sender: self)
        }
        
    }
    
    // Loading and Fast video playing.
    func startLoading()
    {
        self.view.userInteractionEnabled = false
        self.view.addSubview(player)
        player.frame = self.view.frame
        
        Async.main(after: 2.5) {
            SpringAnimation.springWithCompletion(1, animations: {
                }, completion: { (ss) in
                    self.player.removeFromSuperview()
            })
            
            self.showNextViewController()
        }
        
    }

    @IBAction func targetSeverParseAction(sender: AnyObject) {
        startLoading()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func closeTopMessageAction(sender: UIButton) {
        self.transformManager?.queryCollectedContents(1, pageSize: 10, tags: nil, origin: nil, favoriteFlag: nil, colorFlags: nil, completion: self.loadData1)
        changeMesageView(false)
        //self.tableView.reloadData()
        setupAnimation(false, animationComplete: nil)
    }
    
    private func loadContentData() {

        view.showProgressViewLoading()
        transformManager = AIHttpTransformManager()
        //transformManager = AIMockTransformManager()
        transformManager?.queryCollectedContents(1, pageSize: 10, tags: nil, origin: nil, favoriteFlag: nil, colorFlags: nil, completion: loadDataFrist)
    }
    
    private func loadDataFrist(result: (model: [AITransformContentModel], err: Error?)) {
        
        view.hideProgressViewLoading()
        if result.err == nil {
            dataSource = result.model
            if selectedColor != nil {
                let filteCount = dataSource == nil ? 0 : dataSource!.count
                updateLabelData(filteCount, colorId: selectedColor!.rawValue)
                //筛选出现在顶端，所以出筛选的时候顶部菜单要隐藏
                topMenuDiyView.alpha = 0
            }
            self.tableView.reloadData()
            
            swipeView.label_number.text = ""
            
        } else if result.err != nil {
            view.showErrorView()

            AIAlertView().showError("AIErrorRetryView.loading".localized, subTitle: result.err!.message, closeButtonTitle: "AIAudioMessageView.close".localized, duration: 3)
        }
    }
    
    private func loadData(result: (model: [AITransformContentModel], err: Error?)) {
        
        view.hideProgressViewLoading()
        if result.err == nil {
            dataSource = result.model
            if selectedColor != nil {
                let filteCount = dataSource == nil ? 0 : dataSource!.count
                updateLabelData(filteCount, colorId: selectedColor!.rawValue)
                //筛选出现在顶端，所以出筛选的时候顶部菜单要隐藏
                topMenuDiyView.alpha = 0
            }
            self.tableView.reloadData()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //Basically maintain your logic to get the indexpath
                self.setupAnimation(true, animationComplete: nil)
            })
            
            swipeView.label_number.text = ""
            
        } else if result.err != nil {
            view.showErrorView()
            AIAlertView().showError("AIErrorRetryView.loading".localized, subTitle: result.err!.message, closeButtonTitle: "AIAudioMessageView.close".localized, duration: 3)
        }
    }
    
    func retryNetworkingAction(){
        view.hideErrorView()

        self.loadContentData()

    }    
}

// MARK: Scrollview Delegate

extension UITransViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        swipeView.scrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

   //    indicator.scrollViewDidScroll(scrollView)
        setIndexNumber()

        swipeView.scrollViewDidScroll(scrollView)
        
        handleTopMenu(scrollView,isEnable: isEnable)
        
//        var bar: UIView = scrollView.subviews.last as UIView
//        bar.alpha = 0
        

        if swipeView.panel.frame.origin.x == 98.0 {
            //hidden
            swipeView.setWidth(20.0)
            swipeView.setLeft(self.tableView.width - 20.0)
        }else if swipeView.panel.frame.origin.x == 0.0 {
            //show
            swipeView.setWidth(98.0)
            swipeView.setLeft(self.tableView.width - 98.0)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        swipeView.scrollViewDidEndDecelerating(scrollView)
  //      indicator.scrollViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
   //     indicator.scrollViewDidScrollToTop(scrollView)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
   //     indicator.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    
    // MARK: Private Function
    
    // MARK: - Helper methods
    func setIndexNumber() {
        let bar: UIView = tableView.subviews.last!
        
        let point = CGPointMake(CGRectGetMidX(bar.frame), CGRectGetMidY(bar.frame))
        
        if let indexPath = self.tableView.indexPathForRowAtPoint(point) {
            swipeView.label_number.text = "\(indexPath.section + 1)"
        }
    }
}

// MARK: Swipe Cell...
extension UITransViewController: SwipeableCellDelegate{
    
    func cellDidAimationFrame(position: CGFloat, cell: UITableViewCell!) {
        
        let superCell =  cell as! AICellIdentityCell
        if superCell.view_Content.left == 8.0 {
            superCell.backgroundColor = UIColor.clearColor()
        }else{
            self.tableView.scrollEnabled = false
            superCell.backgroundColor = UIColor(patternImage: UIImage(named: "item_card_black_bgcun")!)
        }
        
        var viewtag:Int = 0
        if (position >= 200 && position <= 230) {
            viewtag = 1
        }else if (position >= 162 && position <= 199) {
            viewtag = 2
        }else if (position >= 120 && position <= 160) {
            viewtag = 3
        }else if (position >= 80 && position <= 100) {
            viewtag = 4
        }else if (position >= 30 && position <= 60) {
            viewtag = 6
        }
        if viewtag > 0 {
            
            if let  preButton = tagPreButton {
                
                preButton.setBackgroundImage(UIColor.clearColor().imageWithColor(), forState: UIControlState.Normal)
                
            }
            
            let veiwTagsMore = (cell as! AICellIdentityCell).view_Content.viewWithTag(5)
            
            let button = veiwTagsMore?.viewWithTag(viewtag) as! UIButton
            
            tagPreButton = button //Cache ..
            
            button.setBackgroundImage(UIImage(named: "tags_select"), forState: UIControlState.Normal)
            
        }
    }
    
    
    func buttonActionForItemText(itemText: String!) {
        
    }
    
    func cellDidOpen(cell: UITableViewCell!) {
        //self.tableView.scrollEnabled = false
        let superCell =  cell as! AICellIdentityCell
        
        superCell.view_Tags.alpha = 0
        SpringAnimation.spring(0.7,animations: {
            superCell.view_Tags.alpha = 1
            superCell.backgroundColor = UIColor(patternImage: UIImage(named: "item_card_black_bgcun")!)
            for subButton in superCell.view_Tags.subviews as! [DesignableButton] {
                subButton.animation = "zoomIn"
                subButton.duration = 1.0
                subButton.animate()
            }
        })
    }
    
    func cellDidCloseCell(cell: UITableViewCell!) {
        let superCell =  cell as! AICellIdentityCell
        superCell.backgroundColor = UIColor.clearColor()
        
//        superCell.view_Tags.alpha = 1
//        SpringAnimation.spring(0.7, {
//            superCell.view_Tags.alpha = 0
//            superCell.backgroundColor = UIColor.clearColor()
//        })
        
    }
    
    func cellDidClose(cell: UITableViewCell!) {
        
        //self.tableView.scrollEnabled = true
        let superCell =  cell as! AICellIdentityCell
        self.tableView.scrollEnabled = true
        // button.tag self
        let indexPath =  self.tableView.indexPathForCell(cell)
        if indexPath == nil {
            return
        }
        
        if superCell.view_Content.left <= 8.0 && superCell.view_Content.left >= 0.0{
            return
        }
        
        let model =  dataSource![indexPath!.section ?? 0]
        
        func getAIColorFlagValue(value: Int) -> AIColorFlag{
            if value == 1 {
                return AIColorFlag.Red
            }
            if value == 2{
                return  AIColorFlag.Orange
            }
            if value == 3 {
                return  AIColorFlag.Cyan
            }
            if value == 4 {
                return AIColorFlag.Green
            }
            if value == 5 {
                return AIColorFlag.Blue
            }
            return AIColorFlag.Unknow
        }
        
        // Get Show Cell Button tags...
        let veiwTagsMore = (cell as! AICellIdentityCell).view_Content.viewWithTag(5)
        for itemView in veiwTagsMore?.subviews as! [UIButton] {
            let image:UIImage? =  itemView.backgroundImageForState(UIControlState.Normal)
            if let itemImage = image {
                if  itemImage == UIImage(named: "tags_select") {
                    // this tags ..
                    var tag = itemView.tag
                    if tag == 6 {
                        tag = 5
                    }
                    
                    if getAIColorFlagValue(tag) != AIColorFlag.Unknow {
                        let bol = model.colors?.filter({ (color) -> Bool in
                            let co = color as AIColorFlag
                            if co.intValue() == tag{
                                return true
                            }
                            return false
                        })
                        
                        if bol?.count > 0 {
                            // 选中
                            var indexTag = 0
                            var selectTag = 0
                            for modelsub in model.colors!  {
                                if modelsub == bol?.last {
                                    selectTag = indexTag
                                }
                                indexTag += 1
                            }
                            
                            model.colors?.removeAtIndex(selectTag)
                        }else{
                            
                            model.colors?.append(getAIColorFlagValue(tag))
                            
                        }
                        
                        
                        for  subview in superCell.view_Content.subviews as [UIView]{
                            if subview is AITopInfoView {
                                
                                let views =  subview as! AITopInfoView
                                fillAITopInfoView(model, topView: views, indexPath: indexPath!)
                            }
                        }
                    }
                    
                }
            }
            
        }
        
    }
}

extension UITransViewController:tagCellDelegate{
    func signTag(sender: AnyObject, parent: AICellIdentityCell?) {
        let button = sender as! UIButton
        let tag = button.tag
        
        // button.tag self
        let indexPath =  self.tableView.indexPathForCell(parent!)
        let model =  dataSource![indexPath!.section ?? 0]
        
        let bol = model.colors?.filter({ (color) -> Bool in
            let co = color as AIColorFlag
            if co.intValue() == tag{
                return true
            }
            return false
         })
        
        if bol?.count > 0 {
            // 选中
            var indexTag = 0
            var selectTag = 0
            for modelsub in model.colors!  {
                if modelsub == bol?.last {
                   selectTag = indexTag
                }
                indexTag += 1
            }
            
            model.colors?.removeAtIndex(selectTag)
            
            button.setImage(UIImage(named: "scrollball_\(tag)"), forState: UIControlState.Normal)
            
        }else{
            //取消选中
            button.setImage(UIImage(named: "tags_mark_\(tag)"), forState: UIControlState.Normal)
            
            
            func getAIColorFlagValue(value: Int) -> AIColorFlag{
                if value == 1 {
                    return AIColorFlag.Red
                }
                if value == 2{
                    return  AIColorFlag.Orange
                }
                if value == 3 {
                    return  AIColorFlag.Cyan
                }
                if value == 4 {
                    return AIColorFlag.Green
                }
                if value == 5 {
                    return AIColorFlag.Blue
                }
                return AIColorFlag.Blue
            }
           
            model.colors?.append(getAIColorFlagValue(tag))
        }
        
        let arrayViews = parent?.view_Content.subviews
        
        for  subview in arrayViews! {
            if subview is AITopInfoView {

                let views =  subview as! AITopInfoView
                fillAITopInfoView(model, topView: views, indexPath: indexPath!)
            }
        } 
    }
}

// MARK: UITableViewDataSource Delegate
extension UITransViewController: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let model =  dataSource![indexPath.section]
        //  音乐类型
        if model.favoriteType == FavoriteTypeEnum.music.value() {
            if model.ctExpand == .Collapsed {
                return 75
            }else{
                return 145
            }
        }
        
        // 多媒体类型
        if model.favoriteType == FavoriteTypeEnum.image.value() || model.favoriteType == FavoriteTypeEnum.video.value() {
            // Default
            if model.ctExpand == .Collapsed {
                return 205
            }else{
                let height = self.heightForContent(model.favoriteDes)
                return 195 + 70 + height
            }

        }
        
        //   文本类型
        
        if model.favoriteType == FavoriteTypeEnum.web.value() {
            
            if model.ctExpand == .Collapsed {
                return 125
            }else{
                let height = self.heightForContent(model.favoriteDes)
                return 135 + height
            }
        }
        
        return 0
    }
    
    func configCell(cell: AICellIdentityCell, model: AITransformContentModel,indexPath: NSIndexPath){
        cell.delegate = self
        cell.signDelegate = self
        for index  in 1...5 {
            if let button = cell.view_Tags.viewWithTag(index) as? UIButton{
                button.setImage(UIImage(named: "scrollball_\(index)"), forState: UIControlState.Normal)
            }
        }
        
        if let colorssArray  =  model.colors{
            for colorss in colorssArray {
                
                if let button = cell.view_Tags.viewWithTag(colorss.intValue()) as? UIButton{
                    button.setImage(UIImage(named: "tags_mark_\(colorss.intValue())"), forState: UIControlState.Normal)
                }
                
            }
        }
        
        //  音乐类型
        if model.favoriteType == FavoriteTypeEnum.music.value() {
            
            // Default
            if model.ctExpand == .Collapsed {
                let tView =  AITopInfoView.currentView()
                fillAITopInfoView(model, topView: tView, indexPath: indexPath)
                cell.view_Content.addSubview(tView)
                
                constrain(tView){ view in
                    
                    view.width == view.superview!.width
                    view.height == 65
                    view.left == view.superview!.left
                    view.top == view.superview!.top + 10
                }
                
            }else{
                
                // Expend
                
                let tView =  AITopInfoView.currentView()
                fillAITopInfoView(model, topView: tView, indexPath: indexPath)
                cell.view_Content.addSubview(tView)
                
                let actionView = AIMenuActionView.currentView()
                cell.view_Content.addSubview(actionView)
                fillAIActionView(model, actionView: actionView, indexPath: indexPath)
                constrain(tView,actionView){ viewTop,actionView in
                    viewTop.width == viewTop.superview!.width
                    viewTop.left == viewTop.superview!.left
                    viewTop.height == 55
                    viewTop.top == viewTop.superview!.top + 10
                    
                    actionView.top == viewTop.bottom
                    actionView.width == actionView.superview!.width
                    actionView.height == 70
                    actionView.left == actionView.superview!.left
                    
                }
            }
            
        }
        
        //  多媒体类型
        if model.favoriteType == FavoriteTypeEnum.image.value() || model.favoriteType == FavoriteTypeEnum.video.value() {
            // Default
            if model.ctExpand == .Collapsed {
                let tView =  AITopInfoView.currentView()
                fillAITopInfoView(model, topView: tView, indexPath: indexPath)
                cell.view_Content.addSubview(tView)
                
                let mediaView = AIMediaView.currentView()
                fillAIMediaInfoView(model, mediaView: mediaView, indexPath: indexPath)
                cell.view_Content.addSubview(mediaView)
                
                constrain(tView,mediaView){ viewTop,viewMedia in
                    viewTop.width == viewTop.superview!.width
                    viewTop.height == 55
                    viewTop.top == viewTop.superview!.top + 10
                    viewTop.left == viewTop.superview!.left
                    
                    viewMedia.top == viewTop.bottom
                    viewMedia.width == viewMedia.superview!.width
                    viewMedia.height == 140
                    viewMedia.left == viewMedia.superview!.left
                    
                }
            }else{
                
                let tView =  AITopInfoView.currentView()
                fillAITopInfoView(model, topView: tView, indexPath: indexPath)
                cell.view_Content.addSubview(tView)
                
                let mediaView = AIMediaView.currentView()
                fillAIMediaInfoView(model, mediaView: mediaView, indexPath: indexPath)
                cell.view_Content.addSubview(mediaView)
                
                let contentView = AIContentView.currentView()
                cell.view_Content.addSubview(contentView)
                contentView.Image_Line.hidden = true
                contentView.Label_Content.text = model.favoriteDes
                contentView.Label_Content.numberOfLines = 0
                contentView.Label_Content.sizeToFit()
                
                let actionView = AIMenuActionView.currentView()
                cell.view_Content.addSubview(actionView)
                fillAIActionView(model, actionView: actionView, indexPath: indexPath)
                
                let height = self.heightForContent(model.favoriteDes)
                
                constrain(tView,mediaView,contentView){ view1,view2,view3 in
                    
                    view1.width == view1.superview!.width
                    view1.height == 55
                    view1.left == view1.superview!.left
                    view1.top == view1.superview!.top + 10
                    
                    view2.top == view1.bottom
                    view2.width == view2.superview!.width
                    view2.height == 130
                    view2.left == view2.superview!.left
                    
                    view3.top == view2.bottom
                    view3.left == view3.superview!.left
                    view3.height == height
                    view3.width == view3.superview!.width
                    
                }
                
                // Attach `view` to the top left corner of its superview
                constrain(contentView, actionView) { view3, view4 in
                    
                    view4.top == view3.bottom
                    view4.left == view4.superview!.left
                    view4.width == view4.superview!.width
                    view4.height == 70
                    
                }
                
            }
            
        }
        
        //   文本类型
        
        if model.favoriteType == FavoriteTypeEnum.web.value() {
            
            if model.ctExpand == .Collapsed {
                let tView =  AITopInfoView.currentView()
                fillAITopInfoView(model, topView: tView, indexPath: indexPath)
                cell.view_Content.addSubview(tView)
                
                let contentView = AIContentView.currentView()
                cell.view_Content.addSubview(contentView)
                contentView.Label_Content.text = model.favoriteDes
                contentView.Label_Content.sizeToFit()
                contentView.Label_Content.numberOfLines = 1
                contentView.Image_Line.hidden = false
                constrain(tView,contentView){ view1,view2 in
                    
                    view1.width == view1.superview!.width
                    view1.height == 55
                    view1.left == view1.superview!.left
                    view1.top == view1.superview!.top + 10
                    
                    view2.width == view2.superview!.width
                    view2.top == view1.bottom
                    view2.height == 60
                    view2.left == view1.left
                    
                    
                }
                
                
            }else{
                
                let tView =  AITopInfoView.currentView()
                fillAITopInfoView(model, topView: tView, indexPath: indexPath)
                cell.view_Content.addSubview(tView)
                
                
                let contentView = AIContentView.currentView()
                cell.view_Content.addSubview(contentView)
                contentView.Label_Content.text = model.favoriteDes
                contentView.Label_Content.numberOfLines = 0
                contentView.Label_Content.sizeToFit()
                contentView.Image_Line.hidden = false
                let actionView = AIMenuActionView.currentView()
                fillAIActionView(model, actionView: actionView, indexPath: indexPath)
                cell.view_Content.addSubview(actionView)
                
                let height = self.heightForContent(model.favoriteDes)
                
                constrain(tView,contentView,actionView){ view1,view2,view3 in
                    
                    
                    view1.width == view1.superview!.width
                    view1.height == 55
                    view1.left == view1.superview!.left
                    view1.top == view1.superview!.top + 10
                    
                    view2.width == view2.superview!.width
                    view2.top == view1.bottom
                    view2.height == height
                    view2.left == view1.left
                    
                    view3.top == view2.bottom
                    view3.width == view3.superview!.width
                    view3.height == 70
                    view3.left == view3.superview!.left
                    
                }
            }
        }
    }
    
    // MARK: cellForRowAtIndexPath..
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let model = dataSource![indexPath.section]
        
        let CELL_ID = "Cell_\(model.id  ?? 0)"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(CELL_ID) as? AICellIdentityCell
        if cell == nil {
            cell = AICellIdentityCell.currentCell()
            configCell(cell!, model: model, indexPath: indexPath)
        }
        
        if indexPath.section >= dataSource?.count {
            return UITableViewCell()
        }
        
        return cell!
    }
    
    private func heightForContent(content:String?) -> CGFloat{
        let size = CGSizeMake(self.view.width - 60,2000)
        let s:NSString = "\(content)"
        let contentSize = s.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin , attributes: [NSFontAttributeName:UIFont.systemFontOfSize(14)], context: nil)
        
        return contentSize.height + 10
    }
    
    // Fill Actin view ..
    private func fillAIActionView(model: AITransformContentModel,actionView:AIMenuActionView,indexPath: NSIndexPath){
        actionView.associatedName = "\(indexPath.section)"
        actionView.delegate = self
         var favoImg = "item_button_star"
        if model.isFavorite == AIFavoriteStatu.Favorite {
            favoImg = "ds_star"
        }
        
        actionView.btnFavirote.setImage(UIImage(named: favoImg), forState: UIControlState.Normal)
        
    }
    
    // Fill Top View..
    private func fillAITopInfoView(model: AITransformContentModel,topView:AITopInfoView,indexPath: NSIndexPath){
        
        topView.associatedName = "\(indexPath.section)"
        
        //处理多类型图片
        func getTypeImage(typess:Int)->String{
            if typess == FavoriteTypeEnum.music.value() {
                return "item_card_small_music"
            }else if typess == FavoriteTypeEnum.image.value() {
                return "item_card_small_picture"
            }else if typess == FavoriteTypeEnum.video.value() {
                return "item_card_small_play"
            }else if typess == FavoriteTypeEnum.web.value() {
                return "item_card_small_T"
            }
            return "item_card_small_music"
        }

        topView.Label_Title.textColor = UIColor(patternImage: UIImage(named: "sy_opacity_text")!)
        topView.Label_Title.text = model.favoriteTitle
        topView.Label_number.text = "\(indexPath.section + 1)"
        topView.Label_Type.text = model.favoriteFromWhere ?? ""
        
        /*
        let gradient = CAGradientLayer()
        gradient.frame = topView.Label_Title.frame
        gradient.colors = [topView.Label_Title.tintColor.CGColor,UIColor.clearColor().CGColor]
        topView.Label_Title.layer.insertSublayer(gradient, atIndex: 0)
        */
        
        
        let number = indexPath.section + 1
        if number < 10 {
            topView.Image_numberFirst.image = UIImage(named: "card_number_\(number)")
            topView.Image_numberSecound.image = nil
        }else{
            
            topView.Image_numberFirst.image = UIImage(named: "card_number_\(number / 10)")
            
            topView.Image_numberSecound.image = UIImage(named: "card_number_\(number % 10)")
            
        }
        
        topView.ImageView_Type.image = UIImage(named: getTypeImage(model.favoriteType ?? 0))
        
        for subview in topView.View_MarkTags.subviews{
            subview.removeFromSuperview()
        }
        
        if model.colors?.count > 0 {
            var x:CGFloat = 188
            for colorss in model.colors! {
                if let imgName = colorBallImgName(colorss) {
                    let imgView = UIImageView(image: UIImage(named: imgName))
                    imgView.frame = CGRectMake(x, 2, 10, 10)
                    topView.View_MarkTags.addSubview(imgView)
                    x -= 15
                }
            }
            
        }
        if (model.isFavorite != AIFavoriteStatu.Favorite)  {
            topView.Image_start.hidden = true
        }else{
            topView.Image_start.hidden = false
        }        
    }
    
    private func fillAIMediaInfoView(model: AITransformContentModel,mediaView:AIMediaView,indexPath: NSIndexPath){

        mediaView.associatedName = "\(model.content_url)"
        if model.favoriteAvator != nil {
            
            if model.id == 352 {
                model.favoriteAvator = "http://7xq9bx.com1.z0.glb.clouddn.com/wide64045957124.jpg"
            }
            if model.id == 354 {
                model.favoriteAvator = "http://7xq9bx.com1.z0.glb.clouddn.com/13245ythgfdskhaj.jpg"
            }
            
            mediaView.Image_Media.setURL(NSURL(string: model.favoriteAvator!), placeholderImage: smallPlace())
        }else{
            mediaView.Image_Media.image = smallPlace()
        }
        
        mediaView.Image_Media.layer.borderColor = UIColor.whiteColor().CGColor
        mediaView.Image_Media.layer.borderWidth = 1
        
        mediaView.mediaDelegate = self
        
        if model.favoriteType == FavoriteTypeEnum.video.value(){
            mediaView.Button_play.hidden = false
        }else{
            mediaView.Button_play.hidden = true
        }
 
    }
    
    //TODO: 这里是处理分界线的问题
    // get CommonCellBackgroundViewType type
    func cellPositionInTableView(positionForRowAtIndexPath: NSIndexPath) -> CommonCellBackgroundViewType{
        let numberRows = self.tableView.numberOfRowsInSection(positionForRowAtIndexPath.section)
        if numberRows == 1 {
            return CommonCellBackgroundViewType.GroupSingle
        }
        
        if positionForRowAtIndexPath.row == 0 {
            return CommonCellBackgroundViewType.GroupFirst
        }
        
        if positionForRowAtIndexPath.row == (numberRows - 1) {
            return CommonCellBackgroundViewType.GroupLast
        }
        
        return CommonCellBackgroundViewType.GroupMiddle
    }
    
  
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
//        let model =  dataSource![section]
//        if model.ctExpand == .Collapsed {
//            
//            if model.favoriteType == FavoriteTypeEnum.music.value() {
//                return 2
//            }
//            
//            if model.favoriteType == FavoriteTypeEnum.image.value() {            
//                return 3
//            }
//            
//            if model.favoriteType == FavoriteTypeEnum.video.value() {
//                return 3
//            }
//            
//            if model.favoriteType == FavoriteTypeEnum.web.value() {
//                return 3
//            }
//            
//        } else {
//            
//            if model.favoriteType == FavoriteTypeEnum.music.value() {
//                return 3
//            }
//            
//            if model.favoriteType == FavoriteTypeEnum.image.value() {
//                return 5
//            }
//            
//            if model.favoriteType == FavoriteTypeEnum.video.value() {
//                return 5
//            }
//            
//            if model.favoriteType == FavoriteTypeEnum.web.value() {
//                return 4
//            }
//        }
//        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if dataSource != nil {
            return dataSource!.count
        } else {
            return 0
        }
    } 
 
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
     
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectIndex = indexPath.section
    }
    
    /**
    ExpendCell from AIAPPliction
    */
    func expendCell(sender: AnyObject){
        let topView:AITopInfoView = sender as! AITopInfoView
        let section = topView.associatedName?.toInt()
        cellExpendOrCollapse(section ?? 0)
        //self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section ?? 0), atScrollPosition: UITableViewScrollPosition.None, animated: true)
    }
    
    private func cellExpendOrCollapse(cellIndex: Int) {
  
        
        let model =  dataSource![cellIndex]
        
        if model.ctExpand == .Collapsed {
        model.ctExpand = .Expanded
        
        if lastExpandedCell != -1  && lastExpandedCell != cellIndex {
        dataSource![lastExpandedCell].ctExpand = .Collapsed
        }
        
        lastExpandedCell = cellIndex
        } else {
        model.ctExpand = .Collapsed
        if lastExpandedCell == cellIndex {
        lastExpandedCell = -1
        }
        }
        
        dataSource![cellIndex] = model
        
        isEnable = false
        
        self.tableView.reloadData()
        
        // DISPAYTCH ASYNC.
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            //Basically maintain your logic to get the indexpath
            self.isEnable = true
        })
        
    }
    
    private func deleteContent(cellIndex: Int) {
        view.showProgressViewLoading()
        operateIndex = cellIndex
        transformManager?.deleteContent(dataSource![cellIndex].id, completion: deleteCompletion)
    }
    
    private func modifyFavoriteFlag(cellIndex: Int, favoriteFlag: AIFavoriteStatu) {
        view.showProgressViewLoading()
        operateIndex = cellIndex
        transformManager?.modifyFavoriteFlag(dataSource![cellIndex].id, favoriteFlag: favoriteFlag, completion: modifyFavoriteCompletion)
    }
    
    private func deleteCompletion(err: Error?) {
        
        view.hideProgressViewLoading()
        if err == nil && operateIndex != nil {
            dataSource?.removeAtIndex(operateIndex!)
            tableView.reloadData()
        } else {
            if err != nil {
                AIAlertView().showInfo(err!.message, subTitle: "" , closeButtonTitle: "AIAudioMessageView.close".localized, duration: 3)
            }
        }
    }
    
    private func modifyFavoriteCompletion(err: Error?) {
        view.hideProgressViewLoading()
        if err == nil && operateIndex != nil {
            
            if dataSource![operateIndex!].isFavorite! == AIFavoriteStatu.Favorite {
                dataSource![operateIndex!].isFavorite = AIFavoriteStatu.Unfavorite
            } else {
                dataSource![operateIndex!].isFavorite = AIFavoriteStatu.Favorite
            }

            
            if let oInt = operateIndex {
                self.tableView.beginUpdates()
                self.tableView.reloadSections(NSIndexSet(index: oInt), withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableView.endUpdates()
            }
            
            //tableView.reloadData()
        } else {
            if err != nil {
                AIAlertView().showError("UITransViewController.change".localized, subTitle: err!.message, closeButtonTitle: "AIAudioMessageView.close".localized, duration: 3)
            }
        }
    }
    
    private func colorBallImgName(colorFlag: AIColorFlag) -> String? {
        switch colorFlag {
        case AIColorFlag.Green:
            return "colorball_green"
        case AIColorFlag.Blue:
            return "colorball_blue"
        case AIColorFlag.Cyan:
            return "colorball_cyan"
        case AIColorFlag.Orange:
            return "colorball_orange"
        case AIColorFlag.Red:
            return "colorball_red"
        default:
            return nil
        }
    }
    
    private func colorBallImgName(colorFlag: Int) -> String? {
        switch colorFlag {
        case AIColorFlag.Green.intValue():
            return "colorball_green"
        case AIColorFlag.Blue.intValue():
            return "colorball_blue"
        case AIColorFlag.Cyan.intValue():
            return "colorball_cyan"
        case AIColorFlag.Orange.intValue():
            return "colorball_Orange"
        case AIColorFlag.Red.intValue():
            return "colorball_red"
        default:
            return nil
        }
    }
    
}

// MARK: ActionCellDelegate Delegate
extension UITransViewController: ActionCellDelegate {

    func onAction(sender: AnyObject, parent: UIActionTableViewCell?, actionType: ActionType) {
       
        if let indexPath = tableView.indexPathForCell(parent!) {
            
            let model =  dataSource![indexPath.section]
            
            switch actionType {
            case ActionType.Browse:
                let webView =  self.storyboard?.instantiateViewControllerWithIdentifier("AIWebViewController") as! AIWebViewController
                webView.currentUrl = NSURL(string: "\(model.favoriteFromWhereURL)")
                
                break
            case ActionType.Expend:
                cellExpendOrCollapse(indexPath.section)
                break
            case ActionType.Delete:
                deleteContent(indexPath.section)
                break
            case ActionType.Favorite:
                let toFavoFlag = (dataSource![indexPath.section].isFavorite!) == AIFavoriteStatu.Favorite ? AIFavoriteStatu.Unfavorite : AIFavoriteStatu.Favorite

                modifyFavoriteFlag(indexPath.section, favoriteFlag: toFavoFlag)
                break
            default:
                return
            }
        }
    }
    func onAction(section: Int, actionType: ActionType) {
        
        let model =  dataSource![section]
        
        switch actionType {
        case ActionType.Browse:
            let webView =  self.storyboard?.instantiateViewControllerWithIdentifier("AIWebViewController") as! AIWebViewController
            
            if let url = model.favoriteFromWhereURL {
                 webView.currentUrl = NSURL(string: url)
            }else{
                webView.currentUrl = NSURL(string: "http://www.asiainfo.com")
            }
            
            showViewController(webView, sender: self)
            break
        case ActionType.Expend:
            cellExpendOrCollapse(section)
            break
        case ActionType.Delete:
            deleteContent(section)
            break
        case ActionType.Favorite:
            
                let toFavoFlag = (dataSource![section].isFavorite!) == AIFavoriteStatu.Favorite ? AIFavoriteStatu.Unfavorite : AIFavoriteStatu.Favorite
            
                modifyFavoriteFlag(section, favoriteFlag: toFavoFlag)
                
                
            break
        default:
            return
        }
    }
}

// MARK: ColorIndicatorDelegate Delegate
extension UITransViewController: ColorIndicatorDelegate {
    
    func onButtonClick(sender: AnyObject, colorFlag: AIColorFlag) {
        
        selectedColor = colorFlag
        
        // MARK: Top View Animation
        if colorFlag == AIColorFlag.Favorite {
            self.transformManager?.queryCollectedContents(1, pageSize: 10, tags: nil, origin: nil, favoriteFlag: AIFavoriteStatu.Favorite, colorFlags: nil, completion: self.loadData)
        } else {
            self.transformManager?.queryCollectedContents(1, pageSize: 10, tags: nil, origin: nil, favoriteFlag: nil, colorFlags: [colorFlag], completion: self.loadData)
        }
        
        AILocalStore.setAccessMenuTag(colorFlag.intValue())
        lastExpandedCell = 0
        
    }
    
    func swipeViewVisibleChanged(isVisible: Bool) {
        if isVisible {
            swipeView.setWidth(98.0)
            swipeView.setLeft(self.tableView.width - 98.0)
            setIndexNumber()
        }else{
            swipeView.setWidth(20.0)
            swipeView.setLeft(self.tableView.width - 20.0)
        }
    }
    
    func changeMesageView(show:Bool){
        SpringAnimation.spring(0.3, animations: { () -> Void in
            
            if show {
                self.tableView.setTop(75)
                self.topMessageView.setTop(0)
            }else{
                self.tableView.setTop(0)
                self.topMessageView.setTop(-100)
            }
        })
        
        
    }
}

extension UITransViewController: topActionDelegate{
    func linkAction() {
        AIOpeningView.instance().show()
    }
    
    func captureAction() {
        AIOpeningView.instance().show()
    }
    
    func txtAction() {
        AIOpeningView.instance().show()
    }
    
    func audioAction() {
        AIOpeningView.instance().show()
    }
}


// MARK: play video
extension UITransViewController: playCellDelegate{
    
    func closePlayer(sender: AnyObject) {
        /*if let play = self.player{
            play.stop()
            self.view.viewWithTag(151)?.removeFromSuperview()
            SpringAnimation.springWithCompletion(0.7, {
                play.view.alpha = 0
                play.view.transform = CGAffineTransformMakeScale(1.5, 1.5)
                }, { (completed) -> Void in
                    play.view.removeFromSuperview()
                    
            }) 
        }*/
    }
    func playMediaSource(url: String) {
         self.presentMoviePlayerViewControllerAnimated(MPMoviePlayerViewController(contentURL: NSURL(string: "\(url)")))
    }
    // local
    func playMusic(sender: AnyObject, parent: UIMediaTableViewCell?) {

        if let indexPath = tableView.indexPathForCell(parent!) {
            
            let model =  dataSource![indexPath.section]
            
            self.presentMoviePlayerViewControllerAnimated(MPMoviePlayerViewController(contentURL: NSURL(string: "\(model.content_url!)")))
            
        }
         
    }
    
    override func dismissMoviePlayerViewControllerAnimated() {
        Async.userInitiated(after: 0.3) { () -> Void in
            self.tableView.reloadData()
        }

    }
    
    func playVideo(sender: AnyObject, parent: UIMediaTableViewCell?) {
        
        if let indexPath = tableView.indexPathForCell(parent!) {
            
            let model =  dataSource![indexPath.section]
            
            self.presentMoviePlayerViewControllerAnimated(MPMoviePlayerViewController(contentURL: NSURL(string: "\(model.content_url!)")))
            
        }
        /*
        player = Player()
        player!.delegate = self
        self.player!.view.frame =  self.view.frame
        self.player!.fillMode =  "AVLayerVideoGravityResizeAspect"
        //"AVLayerVideoGravityResizeAspectFill"// 
        self.view.addSubview(self.player!.view)
        self.player!.view.alpha = 0
        SpringAnimation.spring(0.7, {
            self.player!.view.alpha = 1
        })
        self.player?.path = "http://mvvideo2.meitudata.com/559101886d3943189.mp4"
        self.player!.playFromBeginning()
        
        let button = UIButton(frame: CGRectMake(10, 25, 55, 44))
        button.setTitle("返回", forState: UIControlState.Normal)
        button.addTarget(self, action: "closePlayer:", forControlEvents: UIControlEvents.TouchUpInside)
        button.tag = 151
        self.view.addSubview(button)
        */
        
        
        
    }
}


