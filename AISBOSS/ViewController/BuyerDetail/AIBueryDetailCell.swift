//
//  AIBueryDetailCell.swift
//  AIVeris
//
//  Created by tinkl on 3/12/2015.
//  Base on Tof Templates
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

//protocol
protocol AIBueryDetailCellDetegate:class{
    func removeCellFromSuperView(model:AIProposalServiceModel?)
}

// MARK: -
// MARK: AIBueryDetailCell
// MARK: -
internal class AIBueryDetailCell : AISuperSwipeableCell {//
    // MARK: -
    // MARK: Internal access (aka public for current module)
    // MARK: -
    
    // MARK: -> Internal enums
    internal var isNormal:Bool = true  //true: 正常  false :移除状态
    
    internal var isCanSwipeDelate:Bool = true
    
    internal var currentIndexPath:NSIndexPath?
    
    internal var recordPosition:CGPoint?
    
    internal var currentModel:AIProposalServiceModel?
    
    internal weak var delegatedd:AIBueryDetailCellDetegate?
    
    // MARK: -> Internal structs
    
    @IBOutlet weak var contentHoldView: UIView!
    
    // MARK: -> Internal class
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    class func currentView()->AIBueryDetailCell{
        return NSBundle.mainBundle().loadNibNamed("AIBueryDetailCell", owner: self, options: nil).first  as! AIBueryDetailCell
    
    }
    
    // MARK: -
    // MARK: Private access
    // MARK: -
    
    
    // MARK: -> Private methods

    ///Delete Action for delegate
    @IBAction func removeAction(sender: AnyObject) {
        delegatedd?.removeCellFromSuperView(self.currentModel)
    }
}
