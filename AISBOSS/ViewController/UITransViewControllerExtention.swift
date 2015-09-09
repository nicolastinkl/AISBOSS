//
//  UITransViewController.swift
//  AITrans
//
//  Created by wantsor on 23/6/2015.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//

import Foundation
import UIKit
import AISpring
import Cartography


extension UITransViewController{
    typealias AnimationComplete = (Void) -> Void
 
    // MARK: - liuxian
    func setupLayer(){
        gradientLayer.frame = bottomView.bounds
        gradientLayer.colors = [cgColorForRed(0.0, green: 0.0, blue: 0.0,alpha:0),cgColorForRed(0.0, green: 0.0, blue: 0.0,alpha:0.9)]
        gradientLayer.locations = [0,1.0]
        //渐变的起点，0-1，影响渐变的左右方向
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        //渐变的终点，0-1，影响渐变的左右方向跟起点相反
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.zPosition = -100
    }
    
    func cgColorForRed(red: CGFloat, green: CGFloat, blue: CGFloat,alpha:CGFloat) -> AnyObject {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha).CGColor as AnyObject
    }
    
    func loadData1(result: (model: [AITransformContentModel], err: Error?)) {
        if result.err == nil {
            dataSource = result.model
            tableView.reloadData()
            view.hideProgressViewLoading()
        }
    }
    
    func setupAnimation(showIt:Bool,animationComplete : AnimationComplete?){
        
//        var alphaY:CGFloat = 0
//        var animateY:CGFloat = 0
//        if self.topMessageView.height == 0 {
//            // hide
//            alphaY = 0
//            animateY = -60
//        }else{
//            //show
//            alphaY = 1
//            animateY = 0
//        }


//        UIView.animateWithDuration(0.5, animations: { () -> Void in
//            self.topMessageView.alpha = alphaY
//            self.topMessageView.setTop(animateY)
//        })
        
        
        spring(0.7, animations: {
            if showIt {
                // show
                self.topMessageView.alpha = 1
                self.topMessageView.setTop(0)
                self.tableView.setTop( self.topMessageView.bottom - 15 )
                
            }
            else {
                // hidden
                self.topMessageView.alpha = 0
                self.topMessageView.setTop(-self.topMessageView.height)
                self.tableView.setTop(0)
                
            }
            })
        
    }
    
    //更新label的数据，主要是筛选出的记录数量和条件标记
    func updateLabelData(resultCnt:Int,colorId:Int){
        let str = NSLocalizedString("you_have_selected",comment:"")
        topMessageLabel.text = "\(str) \(String(resultCnt))"
        topMessageUnitLabel.text = NSLocalizedString("entries",comment:"")
        if let selectColorIcon = AIColorFlag(rawValue: colorId){
            switch selectColorIcon{
            case .Red:
                filterImage.image = UIImage(named: "colorball_red")
            case .Orange:
                filterImage.image = UIImage(named: "colorball_orange")
            case .Cyan:
                filterImage.image = UIImage(named: "colorball_cyan")
            case .Green:
                filterImage.image = UIImage(named: "colorball_green")
            case .Blue:
                filterImage.image = UIImage(named: "colorball_blue")
            case .Favorite:
                filterImage.image = UIImage(named: "item_bigstar")
            default:
                filterImage.image = UIImage(named: "colorball_red")

            }
        }
    }
    
    //add by liux
    func handleTopMenu(scrollView: UIScrollView,isEnable : Bool){
        if !isEnable {
            return
        }
        
        let showDistance = topMenuDiyView.height / 3
        let offsetY = scrollView.contentOffset.y
        let curHeight = scrollView.frame.height + offsetY - scrollView.contentSize.height
        let isAtBottom = curHeight > 0 ? true : false
        let isAtTop = offsetY < 0 ? true : false
        
        let distance = offsetY - lastScrollPosition
        let curScrollDirection:String = distance > 0 ? "up" : "down"
        //println("isReverseScroll : \(isReverseScroll)" )
        if (isReverseScroll || (topMenuDiyView.alpha != 0 && topMenuDiyView.alpha != 1)) && !isAtBottom && !isAtTop {
            
            if abs(distance) < showDistance {
                if distance > 0 {
                    topMenuDiyView.alpha = ((showDistance-distance) / showDistance)
                    
                }
                else {
                    topMenuDiyView.alpha = ( -distance / showDistance)
                }
            }
//            else{
//                topMenuDiyView.alpha = (distance > 0) ? 0 : 1
//            }
            //println("cal alpha: \(topMenuDiyView.alpha)" )
        }
        
        if !isAtTop && !isAtBottom {
            
            
            if (offsetY - lastScrollPosition) >= showDistance{
                
                lastScrollPosition = offsetY
                lastScrollDirection = curScrollDirection
                topMenuDiyView.alpha = 0
                spring(0.3,animations: {
                    //self.tableView.setTop(0)
                   self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0)
                })
                //println("update status when up scroll")
            }
            else if (lastScrollPosition - offsetY) >= showDistance{
                lastScrollPosition = offsetY
                lastScrollDirection = curScrollDirection
                topMenuDiyView.alpha = 1
                //println("update status when down scroll")
                spring(0.3,animations: {
                    //self.tableView.setTop(20)
                    
                    self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 150, 0)
                })
            }
            isReverseScroll = (lastScrollDirection == curScrollDirection) ? false :true
        }
    }

    
}