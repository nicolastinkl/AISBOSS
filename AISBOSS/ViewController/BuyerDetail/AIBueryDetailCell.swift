//
// AIBueryDetailCell.swift
// AIVeris
//
// Created by tinkl on 3/12/2015.
// Base on Tof Templates
// Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import AISpring

// protocol
protocol AIBueryDetailCellDetegate: class {
	func removeCellFromSuperView(cell: AIBueryDetailCell, model: AIProposalServiceModel?)
}

// MARK: -
// MARK: AIBueryDetailCell
// MARK: -
internal class AIBueryDetailCell : AISuperSwipeableCell {//
 
    // MARK: -
    // MARK: Internal access (aka public for current module)
    // MARK: -
    
    internal var cellHeight: CGFloat=0
    
    // MARK: -> Internal enums
    internal var isNormal:Bool = true  //true: 正常  false :移除状态
    
    internal var isCanSwipeDelate:Bool = true
    
    internal var currentIndexPath:NSIndexPath?
    
    @IBOutlet weak var buttonView: SpringView!
    
    internal var recordPosition:CGPoint?
    
    internal var currentModel:AIProposalServiceModel?{
        didSet{
            //TODO: Here is a holdPlace to show some value init.
            
            guard let modelInit = self.currentModel else {
                return
            }
            
            let simpleServiceView = self.contentHoldView.subviews.last as? SimpleServiceViewContainer
            //Even if a delete property.
            if modelInit.service_del_flag == 1 {
                // Set the content view to 'delete' MODE.
                simpleServiceView?.displayDeleteMode = true
            }else{
                // Set the content view to 'normal' MODE.
                simpleServiceView?.displayDeleteMode = false
                
            } 
            
        }
    }
    
    internal weak var removeDelegate:AIBueryDetailCellDetegate?
    
    // MARK: -> Internal structs
    
    @IBOutlet weak var contentHoldView: UIView!
    
    
    @IBOutlet weak var contentMaskView: UILabel!
    
    // MARK: -> Internal class
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    class func currentView()->AIBueryDetailCell{
        
        let selfview =  NSBundle.mainBundle().loadNibNamed("AIBueryDetailCell", owner: self, options: nil).first  as! AIBueryDetailCell 
        
        return selfview
    }
    
    // MARK: -
    // MARK: Private access
    // MARK: -
    
    
    // MARK: -> Private methods

    ///Delete Action for delegate
    @IBAction func removeAction(sender: AnyObject) {
        removeDelegate?.removeCellFromSuperView(self, model: self.currentModel)
    }
}
