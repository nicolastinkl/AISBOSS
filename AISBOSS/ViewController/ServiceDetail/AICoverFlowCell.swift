//
//  AICoverFlowCell.swift
//  AIVeris
//
//  Created by admin on 15/10/13.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation


class CoverFlowCell: UITableViewCell ,iCarouselDataSource, iCarouselDelegate {
    
    class func currentView()-> CoverFlowCell {
        let selfView = NSBundle.mainBundle().loadNibNamed("AICoverFlowCell", owner: self, options: nil).first  as! CoverFlowCell
        return selfView
    }
    
    @IBOutlet weak var carousel: iCarousel!
    
    @IBOutlet weak var title: UILabel!
    
    var delegate : AISchemeProtocol?
    
    var dataSource:[Service]?
    
    private var oldChoosedItem: Service?
    
    func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
        if let daSource = dataSource {
            return daSource.count
        }
        return 0
    }
    
    func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, var reusingView view: UIView!) -> UIView! {
        //create new view if no view is available for recycling
        if (view == nil) {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            let coverView = UICoverFlowView.currentView()
            
            
            if let data = dataSource {
                
                let comt:Service = data[index] as Service
                coverView.fillDataWithModel(comt)
                view = coverView
            }
            
        }
        /*
        //ONE:
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOffset = CGSizeMake(0, 0)
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 4
        // Settings shadow.
        
        //TWO:
        let path = UIBezierPath()
        
        let width:CGFloat = view.bounds.size.width
        let height:CGFloat = view.bounds.size.height
        let x:CGFloat = view.bounds.origin.x
        let y:CGFloat = view.bounds.origin.y
        let addWH:CGFloat = 10
        
        
        let topLeft      = view.bounds.origin
        let topMiddle = CGPointMake(x+(width/2),y-addWH)
        let topRight     = CGPointMake(x+width,y)
        let rightMiddle = CGPointMake(x + width + addWH,y + (height/2))
        
        let bottomRight  = CGPointMake(x+width,y+height)
        let bottomMiddle = CGPointMake(x+(width/2),y+height+addWH)
        let bottomLeft   = CGPointMake(x,y+height)
        let leftMiddle = CGPointMake(x - addWH,y + (height/2))
        
        path.moveToPoint(topLeft)
        
        //添加2个二元曲线
        path.addQuadCurveToPoint(topRight, controlPoint: topMiddle)
        path.addQuadCurveToPoint(bottomRight, controlPoint: rightMiddle)
        path.addQuadCurveToPoint(bottomLeft, controlPoint: bottomMiddle)
        path.addQuadCurveToPoint(topLeft, controlPoint: leftMiddle)
        
        //设置阴影路径
        view.layer.shadowPath = path.CGPath
        */
        return view
    }
    
    func carousel(carousel: iCarousel!, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat{
        if (option == .Spacing){
            return value * 0.65
        }
        
        if (option == .Wrap){
            return CGFloat(true)
        }
        return value
    }
    
    /*!
    选中当前Coverflow时的价格处理
    */
    func carouselCurrentItemIndexDidChange(carousel: iCarousel!) {
        if let dataSour = dataSource {
            let ser:Service = dataSour[carousel.currentItemIndex]
            delegate?.chooseItem(ser, cancelItem: oldChoosedItem)
            
            oldChoosedItem = ser
        }
    }
}