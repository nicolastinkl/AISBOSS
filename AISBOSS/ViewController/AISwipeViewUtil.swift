//
//  AIMenuActionView.swift
//  AITrans
//
//  Created by wantsor on 7/20/15.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//
import Foundation
import UIKit

class BallMoveRange {
    let MAX_MOVE_RANGE: CGFloat = 16
    let CONTAINER_PADDING: CGFloat = 30
    var ball: UIView!
    var originFrame: CGRect!
    var circleOrigin: CGPoint!
    var leftBallFrame: CGRect?
    var rightBallFrame: CGRect?
    var containerBounds: CGRect!
    var originDistanceToCircleOrigin: CGFloat!
    var leftLine: Line!
    var rightLine: Line!
    var minDistanchToCircleOrigin: CGFloat!
    var maxDistanchToCircleOrigin: CGFloat!
    var hasIn = false
    var swipeView: AIBaseSwipeView
    
    init(swipeView: AIBaseSwipeView, ball: UIView, circleOrigin: CGPoint, leftBallFrame: CGRect?, rightBallFrame: CGRect?, containerBounds: CGRect) {
        self.swipeView = swipeView
        self.ball = ball
        self.circleOrigin = circleOrigin
        self.leftBallFrame = leftBallFrame
        self.rightBallFrame = rightBallFrame
        //      self.containerBounds = containerBounds
        self.containerBounds = CGRectMake(containerBounds.origin.x - CONTAINER_PADDING, containerBounds.origin.y - CONTAINER_PADDING, containerBounds.width + 2 * CONTAINER_PADDING * 2, containerBounds.height + CONTAINER_PADDING * 2)
        
        originFrame = ball.frame
        
        if leftBallFrame != nil {
            var midPoint1 = midPoint(CGPointMake(ball.frame.midX, ball.frame.midY), point2: CGPointMake(leftBallFrame!.midX, leftBallFrame!.midY))
            
            leftLine = Line(point1: circleOrigin, point2: midPoint1)
        } else {
            leftLine = Line(point1: CGPointMake(containerBounds.width, containerBounds.midY), point2: CGPointMake(containerBounds.width, containerBounds.height))
        }
        
        if rightBallFrame != nil {
            var midPoint2 = midPoint(CGPointMake(ball.frame.midX, ball.frame.midY), point2: CGPointMake(rightBallFrame!.midX, rightBallFrame!.midY))
            
            rightLine = Line(point1: circleOrigin, point2: midPoint2)
        } else {
            rightLine = Line(point1: CGPointMake(containerBounds.width, containerBounds.midY), point2: CGPointMake(containerBounds.width, 0))
        }
        
        minDistanchToCircleOrigin = distanceToCircleOrigin;
        originDistanceToCircleOrigin = distanceToCircleOrigin
        maxDistanchToCircleOrigin = distance(CGPointMake(0, 0), point2: circleOrigin) + CONTAINER_PADDING
    }
    
    
    var distanceToCircleOrigin: CGFloat {
        get {
            return distance(CGPointMake(ball.frame.midX, ball.frame.midY), point2: circleOrigin)
        }
    }
    
    func isIn(touchPoint: CGPoint) -> Bool {
        var tempIsIn = true
        
        if !swipeView.isVisibleOnScreen {
            tempIsIn = false
        }
        
        let disToCircle = distance(touchPoint, point2: circleOrigin)
        
        if disToCircle < minDistanchToCircleOrigin || disToCircle > maxDistanchToCircleOrigin {
            tempIsIn = false
        }
        
        var leftDis = leftLine.distanceToLine(touchPoint)
        var rightDis = rightLine.distanceToLine(touchPoint)
        
        var leftEdgePoint: CGPoint?
        var rightEdgePoint: CGPoint?
        
        if leftBallFrame != nil {
            leftEdgePoint = CGPointMake((originFrame.midX + leftBallFrame!.midX) / 2, (originFrame.midY + leftBallFrame!.midY) / 2)
        } else {
            leftEdgePoint = CGPointMake(containerBounds.width, containerBounds.midY + containerBounds.midY / 2)
        }
        
        if rightBallFrame != nil {
            rightEdgePoint = CGPointMake((originFrame.midX + rightBallFrame!.midX) / 2, (originFrame.midY + rightBallFrame!.midY) / 2)
        } else {
            rightEdgePoint = CGPointMake(containerBounds.width, containerBounds.midY - containerBounds.midY / 2)
        }
        
        
        let leftDegree = degreeReverse(leftEdgePoint!)
        let rightDegree = degreeReverse(rightEdgePoint!)
        let touchDegree = degreeReverse(touchPoint)
        
        if leftDegree > 0 && rightDegree > 0 {
            if touchDegree > leftDegree || touchDegree < rightDegree {
                tempIsIn = false
            }
        } else if rightDegree > 0 {
            if touchDegree > 0 {
                if touchDegree < rightDegree {
                    tempIsIn = false
                }
            } else {
                if touchDegree > leftDegree {
                    tempIsIn = false
                }
            }
        } else {
            if touchDegree > leftDegree || touchDegree < rightDegree {
                tempIsIn = false
            }
        }
        
        if !tempIsIn {
            if hasIn {
                moveTo(CGPointMake(originFrame.midX, originFrame.midY))
                hasIn = false
            }
        } else {
            hasIn = true
        }
        
        return tempIsIn
    }
    
    // 将小球移动到一个点,这点是小球的中心点所在位置
    func moveTo(point: CGPoint) {
        ball.frame.origin.x = point.x - ball.width / 2
        ball.frame.origin.y = point.y - ball.height / 2
    }
    
    func resumeToOriginPosition() {
        moveTo(CGPointMake(originFrame.midX, originFrame.midY))
    }
    
    // 两点之间的距离
    private func distance(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let xDist = (point1.x - point2.x)
        let yDist = (point1.y - point2.y)
        return sqrt((xDist * xDist) + (yDist * yDist))
    }
    
    // 两点的中心点
    private func midPoint(point1: CGPoint, point2: CGPoint) -> CGPoint {
        return CGPointMake((point1.x + point2.x) / 2, (point1.y + point2.y) / 2)
    }
    
    // 求某点以圆心为原点，与x轴的角度。point的坐标系是panel的坐标系, 并且交换point的x和y值
    private func degreeReverse(point: CGPoint) -> Float {
        let newX = point.x - circleOrigin.x
        let newY = point.y - circleOrigin.y
        
        return atan2f(Float(newX), Float(newY))
    }
    
    
    // 求某点以圆心为原点，与x轴的角度。point的坐标系是panel的坐标系
    private func degree(point: CGPoint) -> Float {
        let newX = point.x - circleOrigin.x
        let newY = point.y - circleOrigin.y
        
        let d = atan2(Float(newY), Float(newX))
        
        return atan2f(Float(newY), Float(newX))
    }
    
    
    // 根据点击点计算小球的位置,这点是小球的中心点所在位置
    func calculateBallPosition(touchPoint: CGPoint) -> CGPoint {
        // 触摸点到圆心的距离
        var disT = distance(touchPoint, point2: circleOrigin)
        let disB = originDistanceToCircleOrigin
        let K: CGFloat = 0.3
        // 新的小球中心到圆心的距离
        let disBC = K * (disT - disB) + disB
        let degree1: CGFloat = CGFloat(degree(touchPoint))
        //     let newX = disBC * cos(degree1) + originFrame.midX
        //     let newY = disBC * sin(degree1) + originFrame.midY
        let newX = disBC * cos(degree1) + circleOrigin.x
        let newY = disBC * sin(degree1) + circleOrigin.y
        
        return CGPointMake(newX, newY)
    }
    
}

class Line {
    // 直线方程一般式 Ax + By + C = 0;
    var A: CGFloat!
    var B: CGFloat!
    var C: CGFloat!
    
    var point1: CGPoint!
    var point2: CGPoint!
    init(point1: CGPoint, point2: CGPoint) {
        self.point1 = point1
        self.point2 = point2
        
        A = point2.y - point1.y
        
        B = point1.x - point2.x
        
        C = (point2.x - point1.x) * point1.y - (point2.y - point1.y) * point1.x
    }
    
    // 斜率
    var tan: CGFloat? {
        get {
            if B < 0.0001 || B > -0.0001 {
                return nil
            } else {
                return (-A / B)
            }
        }
    }
    
    // 点到线段的最短距离
    func distance(point: CGPoint) -> CGFloat {
        
        let x1 = point1.x
        let y1 = point1.y
        let x2 = point2.x
        let y2 = point2.y
        let x = point.x
        let y = point.y
        
        var cross: CGFloat = (x2 - x1) * (x - x1) + (y2 - y1) * (y - y1)
        if cross <= 0 {
            return sqrt((x - x1) * (x - x1) + (y - y1) * (y - y1))
        }
        
        var d2: CGFloat = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)
        if cross >= d2 {
            return sqrt((x - x2) * (x - x2) + (y - y2) * (y - y2))
        }
        
        var r: CGFloat = cross / d2
        var px: CGFloat = x1 + (x2 - x1) * r
        var py: CGFloat = y1 + (y2 - y1) * r
        
        return sqrt((x - px) * (x - px) + (py - y1) * (py - y1))
    }
    
    // 点到线段的最短距离
    func distanceToLine(point: CGPoint) -> CGFloat {
        return abs(A * (point.x) + B * (point.y) + C) / sqrt(pow(A,2) + pow(B,2))
    }
}

// MARK: ColorIndicatorDelegate
protocol ColorIndicatorDelegate {
    func onButtonClick(sender: AnyObject, colorFlag: AIColorFlag)
    func swipeViewVisibleChanged(isVisible: Bool)
    
}