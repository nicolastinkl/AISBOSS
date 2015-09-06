//
//  AISwipeView.swift
//  AITrans
//
//  Created by admin on 6/24/15.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//

import Foundation
import UIKit

@objc
class AISwipeView: AIBaseSwipeView {
    
   
    @IBOutlet weak var label_number: UILabel!
    
    @IBOutlet weak var redBtn: UIButton!
    @IBOutlet weak var cyanBtn: UIButton!
    @IBOutlet weak var greenBtn: UIButton!
    @IBOutlet weak var blueBtn: UIButton!
    @IBOutlet weak var favoBtn: UIButton!
    @IBOutlet weak var orangeBtn: UIButton!
    
    @IBOutlet weak var panel: UIView!
    @IBOutlet weak var handlerBar: UIButton!

//    private var scrollBar: UIView?
    var delegate: ColorIndicatorDelegate?
    private var ballRanges: [BallMoveRange]!
    private var selectedBall: UIView?
    
    private let JTSScrollIndicator_InherentInset = UIEdgeInsetsMake(2.5, 0, 2.5, 0);
    private let JTSScrollIndicator_IndicatorWidth: CGFloat = 2.5
    private let JTSScrollIndicator_IndicatorRightMargin: CGFloat = 2.5
    private let JTSScrollIndicator_MinIndicatorHeightWhenScrolling: CGFloat = 37
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func buttonClick(sender: AnyObject) {
        
        scheduleAnimatedDistanceToDisapear()
        
        if delegate == nil {
            return
        }
        
        if let element = sender as? NSObject {
            var tag = AIColorFlag.Unknow
            if element == redBtn {
                tag = .Red
            } else if element == cyanBtn {
                tag = .Cyan
            } else if element == greenBtn {
                tag = .Green
            } else if element == blueBtn {
                tag = .Blue
            } else if element == orangeBtn {
                tag = .Orange
            } else if element == favoBtn {
                tag = .Favorite
            }
            
            delegate?.onButtonClick(sender, colorFlag: tag)
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
        println("ballDragExit")
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
    
    class func current() -> AISwipeView {
        return NSBundle.mainBundle().loadNibNamed("AISwipeView", owner: self, options: nil).last as AISwipeView
        
    }

    required override init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialSizeOfInfoPanel = size
        layer.cornerRadius = 2
    }
    
    func setScrollView(scrollView: UIScrollView) {
        
        let windowFrame = scrollView.superview!.frame
        
        let x: CGFloat = windowFrame.width - frame.width - MARGIN_X
        let y: CGFloat = 0
        let selfFrame = frame
        
        self.frame = CGRect(x: x, y: y, width: selfFrame.width, height: selfFrame.height)
        
   //     scrollBar = scrollView.subviews.last as? UIView
        self.scrollView = scrollView
        scrollView.superview?.addSubview(self)
        
        setBallMoveRange()
        setBallRound()
        
        self.isVisibleOnScreen = false;
        panel.frame.origin.x = frame.width
        
        handlerBar.hidden = true
        handlerBar.alpha = BAR_NORMAL_ALPHA
        handlerBar.layer.cornerRadius = 2
        
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
            var bar: UIView = scrollView.subviews.last as UIView
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
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        cancelAnimatedDistanceToDisapear()
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        scheduleAnimatedDistanceToDisapear()
        
        if selectedBall != nil {
            buttonClick(selectedBall!)
        }
        
        for range in ballRanges {
            range.resumeToOriginPosition()
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if event.allTouches() != nil {
            for touch in event.allTouches()! {
                var touchCenter = touch.locationInView(panel)
                
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
        var longGesture = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")

        panel.addGestureRecognizer(longGesture)
        var panGuest = UIPanGestureRecognizer(target: self, action: "handlePanGuest:")
        panel.addGestureRecognizer(panGuest)
    }
    
    @objc func handleLongPress(guesture: UILongPressGestureRecognizer) {
        println("handleLongPress")
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
            var contentHeightWithoutLastFrame = contentHeightWithInsets - frameHeight;
            var percentageScrolled = (contentOffset.y+contentInset.top) / contentHeightWithoutLastFrame;
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
        var range = BallMoveRange(swipeView: self, ball: redBtn, circleOrigin: CGPointMake(label_number.frame.midX, label_number.frame.midY), leftBallFrame: orangeBtn.frame, rightBallFrame: nil, containerBounds: panel.bounds)
        ballRanges.append(range)
        
        range = BallMoveRange(swipeView: self, ball: orangeBtn, circleOrigin: CGPointMake(label_number.frame.midX, label_number.frame.midY), leftBallFrame: cyanBtn.frame, rightBallFrame: redBtn.frame, containerBounds: panel.frame)
        ballRanges.append(range)
        
        range = BallMoveRange(swipeView: self, ball: cyanBtn, circleOrigin: CGPointMake(label_number.frame.midX, label_number.frame.midY), leftBallFrame: greenBtn.frame, rightBallFrame: orangeBtn.frame, containerBounds: panel.frame)
        ballRanges.append(range)
        
        range = BallMoveRange(swipeView: self, ball: greenBtn, circleOrigin: CGPointMake(label_number.frame.midX, label_number.frame.midY), leftBallFrame: blueBtn.frame, rightBallFrame: cyanBtn.frame, containerBounds: panel.frame)
        ballRanges.append(range)
        
        range = BallMoveRange(swipeView: self, ball: blueBtn, circleOrigin: CGPointMake(label_number.frame.midX, label_number.frame.midY), leftBallFrame: favoBtn.frame, rightBallFrame: greenBtn.frame, containerBounds: panel.frame)
        ballRanges.append(range)
        
        range = BallMoveRange(swipeView: self, ball: favoBtn, circleOrigin: CGPointMake(label_number.frame.midX, label_number.frame.midY), leftBallFrame: nil, rightBallFrame: blueBtn.frame, containerBounds: panel.frame)
        ballRanges.append(range)
    }
    
    private func setBallRound() {
        redBtn.layer.cornerRadius = redBtn.width / 2
        redBtn.layer.masksToBounds = true
        
        orangeBtn.layer.cornerRadius = redBtn.width / 2
        orangeBtn.layer.masksToBounds = true
        
        blueBtn.layer.cornerRadius = redBtn.width / 2
        blueBtn.layer.masksToBounds = true
        
        greenBtn.layer.cornerRadius = redBtn.width / 2
        greenBtn.layer.masksToBounds = true
        
        cyanBtn.layer.cornerRadius = redBtn.width / 2
        cyanBtn.layer.masksToBounds = true
        
        favoBtn.layer.cornerRadius = redBtn.width / 2
        favoBtn.layer.masksToBounds = true
    }
    
    private func setBallSelected(ball: UIView) {
        ball.layer.borderWidth = 3
        ball.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    private func setBallUnselected(ball: UIView) {
        ball.layer.borderWidth = 0
    }
    
}

//split class to reuse by liux
class AIBaseSwipeView : UIView{
    
    //var delegate: ColorIndicatorDelegate?
    
    let ANIMATION_DURATION = 0.3;
    let MARGIN_X: CGFloat = 0.0
    let BAR_NORMAL_ALPHA: CGFloat = 0.3
    let BAR_HIGHTLIGHT_ALPHA: CGFloat = 1
    let PANEL_SHWO_DURATION = 3.0
    
    var isVisibleOnScreen = false
    
    var initialSizeOfInfoPanel: CGSize?
    var initialHeightOfScrollIndicator: CGFloat?
    var scrollView: UIScrollView!
    var dismissTask: Async?
    
    

}


