//
//  AssignServiceView.swift
//  MyWholeDemos
//
//  Created by 刘先 on 16/3/9.
//  Copyright © 2016年 wantsor. All rights reserved.
//

import UIKit

class AIAssignServiceView: UIView {

    @IBOutlet weak var curServiceLabel: UILabel!
    @IBOutlet weak var nextServiceLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var limitButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var limitIcon1: UIImageView!
    @IBOutlet weak var limitIcon2: UIImageView!
    @IBOutlet weak var limitIcon3: UIImageView!
    @IBOutlet weak var limitIcon4: UIImageView!
    
    @IBOutlet weak var curServiceTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextServiceTopConstraint: NSLayoutConstraint!
    
    var models : [AssignServiceInstModel]?
    var curModelNum : Int!
    var nextModelNum : Int!
    var beginTime : CFTimeInterval!
    var delegate : AIAssignServiceViewDelegate?
    var isRunAnimation = true
    var repeatTimer : NSTimer?
    var starRateView : CWStarRateView!
    
    class func currentView()->AIAssignServiceView{
        let selfview =  NSBundle.mainBundle().loadNibNamed("AIAssignServiceView", owner: self, options: nil).first  as! AIAssignServiceView
        
        selfview.curModelNum = 0
        selfview.nextModelNum = 1
        selfview.nextServiceLabel.alpha = 0
        return selfview
    }
    
    @IBAction func filterButtonAction(sender: UIButton) {
        
        if let delegate = delegate{
            delegate.filterButtonAction(self, serviceInstModel : models![curModelNum])
        }
    }
    
    @IBAction func contactButtonAction(sender: UIButton) {
        
        if let delegate = delegate{
            delegate.contactButtonAction(self, serviceInstModel : models![curModelNum])
        }
    }
    
    
    @IBAction func limitButtonAction(sender: UIButton) {
        if let delegate = delegate{
            //TODO 这里应该传当前轮播到的那个服务的limit列表，并且这里应该停止滚动动画
            switchAnimationState(false)
            delegate.limitButtonAction(self, limitsModel : (models?[curModelNum].limits)!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    func initView(){
        initRatingView()
    }
    
    func initRatingView(){
        starRateView = CWStarRateView(frame: ratingView.bounds, numberOfStars: 5)
        starRateView?.allowIncompleteStar = true
        ratingView.addSubview(starRateView!)
    }
    
    
    
    func loadData(models : [AssignServiceInstModel]){
        self.models = models
        //limitListView.frame.size.height = 0
        //多于1个选中服务实例，才启动滚动动画
        if models.count > 1{
            let timer = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: "startAnimation", userInfo: nil, repeats: true)
            repeatTimer = timer
        }
        //加载rating数据
        if let ratingLevel =  models[curModelNum].ratingLevel {
            starRateView!.scorePercent = CGFloat(ratingLevel) / 10
        }
        //初始化轮播
        curModelNum = 0
        nextModelNum = 1
    }
    
    //TODO
    func loadServiceInstWith(model : AssignServiceInstModel){
        if let ratingLevel =  model.ratingLevel {
            starRateView!.scorePercent = CGFloat(ratingLevel) / 10
        }
    }
}

//MARK: - 轮播动画
extension AIAssignServiceView{
    
    func startAnimation(){
        if !isRunAnimation{
            return
        }
        
        let labelMoveHeightCur = curServiceLabel.frame.height / 2
        let labelMoveHeightNext = nextServiceLabel.frame.height / 2
        
        nextServiceLabel.text = models![nextModelNum].serviceName
        nextServiceLabel.alpha = 0
        nextServiceLabel.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0,0.1),CGAffineTransformMakeTranslation(1.0,labelMoveHeightNext))

        curServiceLabel.alpha = 1
        curServiceLabel.transform = CGAffineTransformIdentity
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.curServiceLabel.alpha = 0
            let rotateTransform1 = CGAffineTransformMakeScale(1.0, 0.5)
            let positionTransform1 = CGAffineTransformMakeTranslation(1.0, -labelMoveHeightCur)
            self.curServiceLabel.transform = CGAffineTransformConcat(rotateTransform1, positionTransform1)
            
            self.nextServiceLabel.alpha = 1
            self.nextServiceLabel.transform = CGAffineTransformIdentity
        },completion : { (finished) -> Void in
            //触发事件
            if let delegate = self.delegate{
                delegate.serviceDidRotate!(self, curServiceInst: self.models![self.curModelNum])
            }
            self.loadServiceInstWith(self.models![self.curModelNum])
            if self.nextModelNum == (self.models?.count)! - 1{
                self.curModelNum = self.nextModelNum
                self.nextModelNum = 0
            }
            else if self.curModelNum == (self.models?.count)! - 1 {
                self.curModelNum = 0
                self.nextModelNum = 1
            }
            else{
                self.curModelNum = self.curModelNum + 1
                self.nextModelNum = self.nextModelNum + 1
            }
            self.curServiceLabel.text = self.models![self.curModelNum].serviceName
            
            
        })
    }
    
    func switchAnimationState(isRunAnimation : Bool){
        //isRunAnimation = !isRunAnimation
        if isRunAnimation{
            let timer = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: "startAnimation", userInfo: nil, repeats: true)
            repeatTimer = timer
        }
        else{
            repeatTimer?.invalidate()
            repeatTimer = nil
        }
    }
    
}

@objc
protocol AIAssignServiceViewDelegate {
    func limitButtonAction(view : AIAssignServiceView , limitsModel : [AILimitModel])
    //TODO 这里要确认下到底是过滤当前服务实例还是所有的
    
    func filterButtonAction(view : AIAssignServiceView , serviceInstModel : AssignServiceInstModel)
    func contactButtonAction(view : AIAssignServiceView , serviceInstModel : AssignServiceInstModel)
    
    optional func serviceDidRotate(view : AIAssignServiceView , curServiceInst : AssignServiceInstModel)
}
