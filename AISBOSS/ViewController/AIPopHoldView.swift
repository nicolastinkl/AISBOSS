//
//  SphereMenu.swift
//  Sphere Menu
//
//  Created by Camilo Morales on 10/21/14.
//  Copyright (c) 2014 Camilo Morales. All rights reserved.
//

import Foundation
import UIKit

protocol AIBubblesViewDelegate{
    func sphereDidSelected(index:Int)
}

/// AIPopHlodView ...
class AIPopHoldView:UIView, UICollisionBehaviorDelegate{

    let kItemInitTag:Int = 1001
    let kAngleOffset:CGFloat = CGFloat(M_PI_2) / 2.0
    let kSphereLength:CGFloat = 50//80
    let kSphereDamping:Float = 0.6
    
    var delegate:AIBubblesViewDelegate?
    var count:Int?
    
    var images:Array<AIPopPropsalModel>?      //Models
    var items:Array<UIPopView>?   //Views
    var positions:Array<NSValue>?   //Positions
    
    // animator and behaviors
    var animator:UIDynamicAnimator?
    var collision:UICollisionBehavior?
    var itemBehavior:UIDynamicItemBehavior?
    var snaps:Array<UISnapBehavior>?
    
    var tapOnStart:UITapGestureRecognizer?
    
    var bumper:UIDynamicItem?
    var expanded:Bool?
    
    required init(startPoint:CGPoint, submenuImages:Array<AIPopPropsalModel>){
        self.init()
        self.images = submenuImages
        self.count = self.images!.count
        self.center = startPoint
        
    }
    
    func randomIn(min min: Int, max: Int) -> Int {

        return Int(arc4random()) % (max - min + 1) + min
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.count = 0
        self.images = Array()
        self.init()
    }
    
    required override init(frame: CGRect) {
        self.count = 0
        self.images = Array()
        super.init(frame: frame)
    }
    
    override func didMoveToSuperview() {
        self.commonSetup()
    }
    
    func commonSetup()
    {
        self.items = Array()
        self.positions = Array()
        self.snaps = Array()

        // setup the items
        for (var i = 0; i < self.count; i++) {
            let item = UIPopView.currentView()
            //let model = self.images![i]
            //item.fillDataWithModel(model)
//            item.layer.cornerRadius = item.width/2
//            item.layer.masksToBounds = true
            //let item = UIImageView(image: self.images![i])
            
            item.tag = kItemInitTag + i;
            item.userInteractionEnabled = true;
            self.superview?.addSubview(item)
    
            let position = self.centerForSphereAtIndex(i)
            item.center = self.center;
            self.positions?.append(NSValue(CGPoint: position))
    
            //随机大小
            let randomWidth = randomIn(min: 66, max: 110)
            
            //print("\(randomWidth)")
            item.setWidth(CGFloat(randomWidth))
            item.setHeight(CGFloat(randomWidth))
            
//            let tap = UITapGestureRecognizer(target: self, action:"tapped:")
//            item.addGestureRecognizer(tap)
    
            let pan = UIPanGestureRecognizer(target: self, action: "panned:")
            item.addGestureRecognizer(pan)
            self.items?.append(item)
        }
    
        self.superview?.bringSubviewToFront(self)
        
        // setup animator and behavior
        self.animator = UIDynamicAnimator(referenceView: self.superview!)
        self.collision = UICollisionBehavior(items: self.items!)
        self.collision?.translatesReferenceBoundsIntoBoundary = true;
        self.collision?.collisionDelegate = self;
        
        for (var i = 0; i < self.count; i++) {
            let snap = UISnapBehavior(item: self.items![i], snapToPoint: self.center)
            snap.damping = CGFloat(kSphereDamping)
            self.snaps?.append(snap)
        }
    
        self.itemBehavior = UIDynamicItemBehavior(items: self.items!)
        self.itemBehavior?.allowsRotation = false;   //是否允许重复
        self.itemBehavior?.elasticity = 0.25;       //弹性;弹力
        self.itemBehavior?.density =  0.5;          //密集, 稠密
        self.itemBehavior?.angularResistance = 4;   //阻力
        self.itemBehavior?.resistance = 10;         //抵抗, 反抗, 抵抗能力
        self.itemBehavior?.elasticity = 0.8;        //弹性,弹力
        self.itemBehavior?.friction = 0.5;          //摩擦，摩擦力
    }
    
    // 图标 弧形排列
    func centerForIconAtIndex(index:Int) -> CGPoint{
        let firstAngle:CGFloat = CGFloat(M_PI) + (CGFloat(M_PI_2) - kAngleOffset) + CGFloat(index) * kAngleOffset
        let startPoint = self.center
        let x = startPoint.x + cos(firstAngle) * kSphereLength;
        let y = startPoint.y + sin(firstAngle) * kSphereLength;
        let position = CGPointMake(x, y);
        return position;
    }
    

    func centerForSphereAtIndex(index:Int) -> CGPoint{
        let firstAngle:CGFloat = CGFloat(M_PI) + (CGFloat(M_PI_2) - kAngleOffset) + CGFloat(index) * kAngleOffset
        let startPoint = self.center
        let x = startPoint.x + cos(firstAngle) * kSphereLength;
        let y = startPoint.y + sin(firstAngle) * kSphereLength;
        let position = CGPointMake(x, y);
        return position;
    }
    
    func startExpend(){
        self.animator?.removeBehavior(self.collision!)
        self.animator?.removeBehavior(self.itemBehavior!)
        
        //[self removeSnapBehaviors];
        
        if (self.expanded == true) {
            self.shrinkSubmenu()
        } else {
            self.expandSubmenu()
        }
    }
    
    func startTapped(gesture:UITapGestureRecognizer){
        self.animator?.removeBehavior(self.collision!)
        self.animator?.removeBehavior(self.itemBehavior!)
        
        //[self removeSnapBehaviors];
        
        if (self.expanded == true) {
            self.shrinkSubmenu()
        } else {
            self.expandSubmenu()
        }
    }

    func tapped(gesture:UITapGestureRecognizer)
    {
        var tag = gesture.view?.tag
        tag? -= Int(kItemInitTag)
        self.delegate?.sphereDidSelected(tag!)
        self.shrinkSubmenu()
    }

    func panned(gesture:UIPanGestureRecognizer)
    {
        let touchedView = gesture.view
        if (gesture.state == UIGestureRecognizerState.Began) {
            self.animator?.removeBehavior(self.itemBehavior!)
            self.animator?.removeBehavior(self.collision!)
            self.removeSnapBehaviors()
        } else if (gesture.state == UIGestureRecognizerState.Changed) {
            touchedView?.center = gesture.locationInView(self.superview)
        } else if (gesture.state == UIGestureRecognizerState.Ended) {
            self.bumper = touchedView;
            self.animator?.addBehavior(self.collision!)
            let index = self.indexOfItemInArray(self.items!, item: touchedView!)
            if (index >= 0) {
                self.snapToPostionsWithIndex(index)
            }

        }
    }
    
    func fixPosition(){
        self.animator?.addBehavior(self.collision!)
        let lastView = self.items?.last
        let index = self.indexOfItemInArray(self.items!, item: lastView!)
        if (index >= 0) {
            self.snapToPostionsWithIndex(index)
        }
    }
    
    func indexOfItemInArray(dataArray:Array<UIPopView>, item:AnyObject) -> Int{
        var index = -1
        for (var i = 0; i < dataArray.count; i++){
            if (dataArray[i] === item){
                index = i
                break
            }
        }
        return index
    }
    
    func shrinkSubmenu(){
        self.animator?.removeBehavior(self.collision!)
        
        for (var i = 0; i < self.count; i++) {
           self.snapToStartWithIndex(i)
        }
        self.expanded = false;
    }
    
    func expandSubmenu(){
        for (var i = 0; i < self.count; i++) {
           self.snapToPostionsWithIndex(i)
        }
        self.expanded = true;
    
    }
    
    func snapToStartWithIndex(index:Int)
    {
        let snap = UISnapBehavior(item: self.items![index], snapToPoint: self.center)
        snap.damping = CGFloat(kSphereDamping)
        let snapToRemove = self.snaps![index];
        self.snaps![index] = snap;
        self.animator?.removeBehavior(snapToRemove)
        self.animator?.addBehavior(snap)
    }
    
    func snapToPostionsWithIndex(index:Int)
    {
        let positionValue:AnyObject = self.positions![index];
        let position = positionValue.CGPointValue
        let snap = UISnapBehavior(item: self.items![index], snapToPoint: position)
        snap.damping = CGFloat(kSphereDamping)
        let snapToRemove = self.snaps![index];
        self.snaps![index] = snap;
        self.animator?.removeBehavior(snapToRemove)
        self.animator?.addBehavior(snap)
    }

    func removeSnapBehaviors()
    {
        for (var i = 0; i < self.snaps?.count; i++){
            self.animator?.removeBehavior((self.snaps?[i])!)
        }
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem) {
        self.animator?.addBehavior(self.itemBehavior!)

        if (item1 !== self.bumper){
            let index = self.indexOfItemInArray(self.items!, item: item1)
            if (index >= 0) {
                self.snapToPostionsWithIndex(index)
            }
        }
        
        if (item2 !== self.bumper){
            let index = self.indexOfItemInArray(self.items!, item: item2)
            if (index >= 0) {
                self.snapToPostionsWithIndex(index)
            }
        }
    }

}

