//
//  AIMenuActionView.swift
//  AITrans
//
//  Created by wantsor on 7/1/15.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//


import UIKit


class AICustomerSwipeView: AIBaseSwipeView {

    @IBOutlet weak var handlerBar: UIButton!
    
    @IBOutlet weak var compServiceBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var timerBtn: UIButton!
    @IBOutlet weak var panel: UIView!
    var isFirstLayout:Bool = true
    @IBOutlet weak var label_number: UILabel!
    
    private var ballRanges: [BallMoveRange]!
    private var selectedBall: UIView?
    
    private let JTSScrollIndicator_InherentInset = UIEdgeInsetsMake(2.5, 0, 2.5, 0);
    private let JTSScrollIndicator_IndicatorWidth: CGFloat = 2.5
    private let JTSScrollIndicator_IndicatorRightMargin: CGFloat = 2.5
    private let JTSScrollIndicator_MinIndicatorHeightWhenScrolling: CGFloat = 37
    
    var delegate: CustomerIndicatorDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func buttonClick(sender: AnyObject) {
        
        scheduleAnimatedDistanceToDisapear()
        
        if delegate == nil {
            return
        }
        
        if let element = sender as? NSObject {
            var tag = AICustomerFilterFlag.Unknow
            if element == timerBtn {
                tag = .Timer
            } else if element == favoriteBtn {
                tag = .Favorite
            } else if element == compServiceBtn {
                tag = .CompService
            }
            //TODO: update delegate
            delegate?.onButtonClick(sender, filterFlag: tag)
        }
    }
    
    @IBAction func ballTouchDown(sender: AnyObject) {
        //     println("ballTouchDown")
        cancelAnimatedDistanceToDisapear()
    }
    
    //    @IBAction func ballDragEnter(sender: AnyObject) {
    //        println("ballDragEnter")
    //    }
    //
    @IBAction func ballDragExit(sender: AnyObject) {
        scheduleAnimatedDistanceToDisapear()
    }
    //
    //    @IBAction func ballDragInside(sender: AnyObject) {
    //        println("ballDragInside")
    //    }
    //
    //    @IBAction func ballBragOutside(sender: AnyObject) {
    //        println("ballBragOutside")
    //    }
    //
    //    @IBAction func ballTouchUpOutside(sender: AnyObject) {
    //        println("ballTouchUpOutside")
    //    }
    
    @IBAction func onBarClick(sender: AnyObject) {
        appear()
    }
    
    class func current() -> AICustomerSwipeView {
        return NSBundle.mainBundle().loadNibNamed("AICustomerSwipeView", owner: self, options: nil).last as! AICustomerSwipeView
        
    }
    
    required  init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialSizeOfInfoPanel = size
        layer.cornerRadius = 2
        
    }
    
    func setSspScrollView(scrollView: UIScrollView) {
        
        
        let windowFrame = scrollView.superview!.frame
        
        let x: CGFloat = windowFrame.width - frame.width - MARGIN_X
        let y: CGFloat = 0
        let selfFrame = frame
        
        frame = CGRect(x: x, y: y, width: selfFrame.width, height: selfFrame.height)
        
        //     scrollBar = scrollView.subviews.last as? UIView
        self.scrollView = scrollView
        scrollView.superview?.addSubview(self)
        
        setBallMoveRange()
        setBallRound()
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        if isFirstLayout {
            panel.frame.origin.x = frame.width
            handlerBar.hidden = isFirstLayout
            isFirstLayout = !isFirstLayout
        }
        panel.frame.origin.x = self.isVisibleOnScreen ? 0 : frame.width
        //handlerBar.alpha = BAR_NORMAL_ALPHA
        handlerBar.layer.cornerRadius = 2
        //println("\(panel.frame)---\(self.frame)")
    
        
    }
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        // when end scroll show the bar
        handlerBar.alpha = BAR_HIGHTLIGHT_ALPHA
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        handlerBar.hidden = false
        
        var barpoint: CGPoint!
        
        let superHeight = scrollView.superview!.height
        let scrollViewHeight = scrollView.contentSize.height
        if scrollViewHeight < superHeight / 2.0 {
            barpoint = CGPointMake(0, scrollView.superview!.frame.midY)
        } else {
            let bar: UIView = scrollView.subviews.last!
            barpoint = CGPointMake(CGRectGetMidX(bar.frame), CGRectGetMidY(bar.frame))
            barpoint = scrollView.convertPoint(barpoint, toView: scrollView.superview)
        }
        setCenterY(barpoint.y)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //       scheduleAnimatedDistanceToDissapear()
        //       removeFromSuperview()
        

    }
    
    // MARK: Touch event
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        cancelAnimatedDistanceToDisapear()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)  {
        scheduleAnimatedDistanceToDisapear()
        
        if selectedBall != nil {
            buttonClick(selectedBall!)
        }
        
        for range in ballRanges {
            range.resumeToOriginPosition()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)  {
        
        if let eventArray = event!.allTouches(){
            for touch in eventArray{
                let touchCenter = touch.locationInView(panel)
                
                selectedBall = nil
                
                for range in ballRanges {
                    if range.isIn(touchCenter) {
                        setBallSelected(range.ball)
                        
                        range.moveTo(range.calculateBallPosition(touchCenter))
                        
                        selectedBall = range.ball
                    } else {
                        setBallUnselected(range.ball)
                    }
                }
                
                break
            }
            
        }
    }
    
    // MARK: Color balls Handle
    
    private func scheduleAnimatedDistanceToDisapear() {
        dismissTask = Async.main(after: PANEL_SHWO_DURATION, block: disappear)
    }
    
    private func cancelAnimatedDistanceToDisapear() {
        dismissTask?.cancel()
    }
    
    private func appear() {
        if (isVisibleOnScreen) {
            return;
        }
        
        layer.removeAllAnimations()
        
        
        UIView.animateWithDuration(ANIMATION_DURATION, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.panel.frame.origin.x = 0
            }, completion: {(Bool) -> Void in
                self.isVisibleOnScreen = true
                self.scheduleAnimatedDistanceToDisapear()
        })
        
        //handlerBar.alpha = BAR_HIGHTLIGHT_ALPHA
        delegate?.swipeViewVisibleChanged(true)
        
    }
    
    private func disappear() {
        if (!self.isVisibleOnScreen) {
            return;
        }
        layer.removeAllAnimations()
        
        UIView.animateWithDuration(ANIMATION_DURATION, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.isVisibleOnScreen = false;
            self.panel.frame.origin.x = self.frame.width
            }, completion: {(Bool) -> Void in
                self.isVisibleOnScreen = false
        })
        
        handlerBar.alpha = BAR_NORMAL_ALPHA
        delegate?.swipeViewVisibleChanged(false)
    }
    
    private func setupEvent() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        
        panel.addGestureRecognizer(longGesture)
        let panGuest = UIPanGestureRecognizer(target: self, action: "handlePanGuest:")
        panel.addGestureRecognizer(panGuest)
    }
    
    @objc func handleLongPress(guesture: UILongPressGestureRecognizer) {
    }
    
    func handlePanGuest(guest: UIPanGestureRecognizer) {
        //       println("handlePanGuest")
    }
    
    class func underlyingIndicatorRectForScrollView(scrollView: UIScrollView) -> CGRect {
        
        let JTSScrollIndicator_InherentInset = UIEdgeInsetsMake(2.5, 0, 2.5, 0);
        let JTSScrollIndicator_IndicatorWidth: CGFloat = 2.5
        let JTSScrollIndicator_IndicatorRightMargin: CGFloat = 2.5
        let JTSScrollIndicator_MinIndicatorHeightWhenScrolling: CGFloat = 37
        
        var underlyingRect = CGRectZero
        let contentHeight = scrollView.contentSize.height;
        let indicatorInsets = scrollView.scrollIndicatorInsets
        let frameHeight = scrollView.frame.size.height
        let contentInset = scrollView.contentInset
        let contentOffset = scrollView.contentOffset
        let contentHeightWithInsets = contentHeight + contentInset.top + contentInset.bottom
        let frameHeightWithoutScrollIndicatorInsets = (frameHeight - indicatorInsets.top - indicatorInsets.bottom - JTSScrollIndicator_InherentInset.top)
        
        underlyingRect.size.width = JTSScrollIndicator_IndicatorWidth
        underlyingRect.origin.x = scrollView.frame.size.width - JTSScrollIndicator_IndicatorWidth - JTSScrollIndicator_IndicatorRightMargin;
        
        let ratio = (contentHeightWithInsets != 0) ? frameHeightWithoutScrollIndicatorInsets / contentHeightWithInsets : 1.0
        
        underlyingRect.size.height = frameHeight * ratio
        underlyingRect.origin.y = contentOffset.y + ((contentOffset.y + contentInset.top) * ratio) + indicatorInsets.top
        
        if (underlyingRect.size.height < JTSScrollIndicator_MinIndicatorHeightWhenScrolling) {
            let contentHeightWithoutLastFrame = contentHeightWithInsets - frameHeight;
            let percentageScrolled = (contentOffset.y+contentInset.top) / contentHeightWithoutLastFrame;
            underlyingRect.origin.y -= (JTSScrollIndicator_MinIndicatorHeightWhenScrolling - underlyingRect.size.height) * percentageScrolled;
            underlyingRect.size.height = JTSScrollIndicator_MinIndicatorHeightWhenScrolling;
        }
        
        underlyingRect.size.height -= JTSScrollIndicator_InherentInset.top;
        underlyingRect.origin.y += JTSScrollIndicator_InherentInset.top;
        
        return underlyingRect;
        
    }
    
    private func adjustFrame(underlyingRect: CGRect) {
        
        
        //     let toRect: CGRect = scrollBar!.convertRect(underlyingRect, toView: scrollView)
        //      frame.origin.y = toRect.origin.y + toRect.height / 2 - frame.size.height / 2
        
        //      frame.origin.y = underlyingRect.origin.y + underlyingRect.height / 2 - frame.size.height / 2
    }
    
    private func floatEqual(src: CGFloat, des: CGFloat) -> Bool {
        let delta: CGFloat = 0.0001
        return (src < (des + delta)) && (src > (des - delta))
    }
    
    private func setBallMoveRange() {
        ballRanges = [BallMoveRange]()
        var range = BallMoveRange(swipeView: self, ball: timerBtn, circleOrigin: CGPointMake(label_number.frame.midX, label_number.frame.midY), leftBallFrame: favoriteBtn.frame, rightBallFrame: nil, containerBounds: panel.bounds)
        ballRanges.append(range)
        
        range = BallMoveRange(swipeView: self, ball: favoriteBtn, circleOrigin: CGPointMake(label_number.frame.midX, label_number.frame.midY), leftBallFrame: timerBtn.frame, rightBallFrame: compServiceBtn.frame, containerBounds: panel.frame)
        ballRanges.append(range)
        
        range = BallMoveRange(swipeView: self, ball: compServiceBtn, circleOrigin: CGPointMake(label_number.frame.midX, label_number.frame.midY), leftBallFrame: favoriteBtn.frame, rightBallFrame: nil, containerBounds: panel.frame)
        ballRanges.append(range)
        
    }
    
    private func setBallRound() {
        timerBtn.layer.cornerRadius = timerBtn.width / 2
        timerBtn.layer.masksToBounds = true
        
        favoriteBtn.layer.cornerRadius = favoriteBtn.width / 2
        favoriteBtn.layer.masksToBounds = true
        
        compServiceBtn.layer.cornerRadius = compServiceBtn.width / 2
        compServiceBtn.layer.masksToBounds = true
        
    }
    
    private func setBallSelected(ball: UIView) {
        ball.layer.borderWidth = 3
        ball.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    private func setBallUnselected(ball: UIView) {
        ball.layer.borderWidth = 0
    }
}

// MARK: ColorIndicatorDelegate
protocol CustomerIndicatorDelegate {
    func onButtonClick(sender: AnyObject, filterFlag: AICustomerFilterFlag)
    func swipeViewVisibleChanged(isVisible: Bool)
    
}
