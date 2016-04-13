//
//  UICellMultiStyle.swift
//  AITrans
//
//  Created by tinkl on 23/6/2015.
//  Copyright (c) 2015 __ASIAINFO__. All rights reserved.
//

import Foundation
import UIKit
import Cartography 
import Spring

/*!
*  @author tinkl, 15-06-24 10:06:25
*
*  =============     main cell class    ================
*/

protocol tagCellDelegate:class {
    func signTag(sender: AnyObject, parent: AICellIdentityCell?)
}


class AICellIdentityCell:SwipeableCell {

    @IBOutlet weak var view_Tags: SpringView!

    @IBOutlet weak var view_Content: SpringView!
    
    weak var signDelegate: tagCellDelegate?
    
    class func currentCell() -> AICellIdentityCell {
         return NSBundle.mainBundle().loadNibNamed("AICellIdentityCell", owner: self, options: nil).first  as! AICellIdentityCell
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let imageView = self.view_Content.viewWithTag(2) as! UIImageView
        let imageViewLeft = self.view_Content.viewWithTag(3) as! UIImageView
        let imageViewRight = self.view_Content.viewWithTag(4) as! UIImageView
        if selected {
            imageView.image = UIImage(named: "card_select")
            imageViewLeft.image = UIImage(named: "left_bulge_shadow_select")
            imageViewRight.image = UIImage(named: "right_bulge_shadow_select")
            
            if let infoView = self.view_Content.viewWithTag(View_Tag.View_TOP.rawValue) as! AITopInfoView? {
                infoView.Label_Title.textColor = UIColor.blackColor()
                infoView.Label_Type.textColor = UIColor.blackColor()
                
            }
            
            if let contentView = self.view_Content.viewWithTag(View_Tag.View_CONTENT.rawValue) as! AIContentView? {
                contentView.Label_Content.textColor = UIColor.blackColor()
            }
        }else{
            imageView.image = UIImage(named: "item_card_bg")
            imageViewLeft.image = UIImage(named: "left_bulge_shadow")
            imageViewRight.image = UIImage(named: "right_bulge_shadow")
            
            
            if let infoView = self.view_Content.viewWithTag(View_Tag.View_TOP.rawValue) as! AITopInfoView? {
                infoView.Label_Title.textColor = UIColor.whiteColor()
                infoView.Label_Type.textColor = UIColor.whiteColor()
            }
            
            if let contentView = self.view_Content.viewWithTag(View_Tag.View_CONTENT.rawValue) as! AIContentView? {
                contentView.Label_Content.textColor = UIColor.whiteColor()
            }
            
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        let imageView = self.view_Content.viewWithTag(2) as! UIImageView
        let imageViewLeft = self.view_Content.viewWithTag(3) as! UIImageView
        let imageViewRight = self.view_Content.viewWithTag(4) as! UIImageView
        
        if highlighted {
           // imageView.image = UIImage(named: "card_select")
            imageViewLeft.image = UIImage(named: "left_bulge_shadow_select")
            imageViewRight.image = UIImage(named: "right_bulge_shadow_select")
            
            if let infoView = self.view_Content.viewWithTag(View_Tag.View_TOP.rawValue) as! AITopInfoView? {
                infoView.Label_Title.textColor = UIColor.blackColor()
                infoView.Label_Type.textColor = UIColor.blackColor()
                
            }
            
            if let contentView = self.view_Content.viewWithTag(View_Tag.View_CONTENT.rawValue) as! AIContentView? {
                contentView.Label_Content.textColor = UIColor.blackColor()
            }
            
        }else{
            imageView.image = UIImage(named: "item_card_bg")
            imageViewLeft.image = UIImage(named: "left_bulge_shadow")
            imageViewRight.image = UIImage(named: "right_bulge_shadow")
            
            if let infoView = self.view_Content.viewWithTag(View_Tag.View_TOP.rawValue) as! AITopInfoView? {
                infoView.Label_Title.textColor = UIColor.whiteColor()
                infoView.Label_Type.textColor = UIColor.whiteColor()
            }
            
            if let contentView = self.view_Content.viewWithTag(View_Tag.View_CONTENT.rawValue) as! AIContentView? {
                contentView.Label_Content.textColor = UIColor.whiteColor()
            }
        }
        
        // Settings text color to black or white
        
    }
    
    func layoutMask(){
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 8)
        let maskLayer = CAShapeLayer()
        
        //maskLayer.fillColor = UIColor.blackColor().CGColor
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.CGPath
        self.layer.mask = maskLayer
        
    }
    
    @IBAction func tagAction(sender: AnyObject) {
        _ = sender as! UIButton
        signDelegate?.signTag(sender, parent: self)
    }
    
    /*
    override func drawRect(rect: CGRect) {
        //super.drawRect(rect)
    
    }
    */
}

class UICellMultiStyle: UITableViewCell {
    
    override func awakeFromNib(){
        
         super.awakeFromNib()
    }
    
    func setCellBackgroundByPosition(cellStyleForRowAtIndexPath cellDisplayType:CommonCellBackgroundViewType,row:Int){
        
        //var newFrame = CGRectMake(10, 0, frame.width-20, frame.height)
        if cellDisplayType ==  CommonCellBackgroundViewType.GroupLast{
            //newFrame =  CGRectMake(10, 0, frame.width-20, 10)
        }
        //let bgView = AIEffectView(frame: newFrame, type: cellDisplayType,row:row)
        
        //self.backgroundView = bgView
        
        /*
            ／／ 重力效果
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -50
        horizontalMotionEffect.maximumRelativeValue = 50
        
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -50
        verticalMotionEffect.maximumRelativeValue = 50
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        imageView.addMotionEffect(motionEffectGroup)
        
        */
        
    }
    
    func showTagsCells(){
        logInfo("")
    }
    
    override func layoutSubviews() {
        
        if let subView = self.backgroundView{
            
            let newFrame = CGRectMake(10, 0, self.contentView.frame.width-20, self.contentView.frame.height)
            subView.frame = newFrame
            
        }
    }
    
}

/*!
*  @author tinkl, 15-06-23 20:06:38
*
*  Top Cell
*/
class UITopTableViewCell: UICellMultiStyle {
    
    @IBOutlet weak var ImageView_CardNumber: UIImageView!
    @IBOutlet weak var Label_Title: UILabel!
    @IBOutlet weak var ImageView_Type: UIImageView!
    @IBOutlet weak var Label_Type: UILabel!
    
    @IBOutlet weak var Image_start: UIImageView!
    @IBOutlet weak var View_MarkTags: UIView!
    @IBOutlet weak var color1: UIImageView!
    
    @IBOutlet weak var Label_number: UILabel!
}

/*!
*  @author tinkl, 15-06-23 20:06:51
*
*  Media Cell
*/
class UIMediaTableViewCell: UICellMultiStyle {

    var mediaDelegate:playCellDelegate?
    
    @IBOutlet weak var Image_Media: AIImageView!

    @IBOutlet weak var Button_play: UIButton!
    
    @IBAction func playAction(sender: AnyObject) {
        mediaDelegate?.playVideo(sender, parent: self)
    }
}

/*!
*  @author tinkl, 15-06-23 20:06:02
*
*  Content Cell
*/
class UIContentTableViewCell: UICellMultiStyle {
    
    @IBOutlet weak var Label_Content: UILabel!
}

/*!
*  @author tinkl, 15-06-23 20:06:14
*
*  Action Cell
*/
class UIActionTableViewCell: UICellMultiStyle {
    var delegate: ActionCellDelegate?
    
    @IBOutlet weak var btnExpend: UIButton!
    @IBOutlet weak var btnBrowse: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnFavirote: UIButton!     
    
    @IBAction func buttonClick(sender: AnyObject) {
        if delegate != nil {
            var type = ActionType.Unkonw
            let element = sender as! NSObject
            if element == btnExpend {
                type = .Expend
            } else if element == btnDelete {
                type = .Delete
            } else if element == btnFavirote {
                type = .Favorite
            } else if element == btnBrowse {
                type = .Browse
            }
            
            delegate!.onAction(sender, parent: self, actionType: type)
        }
        
    }
}

enum ActionType: Int {
    case Unkonw = 0, Expend, Delete, Favorite, Browse
}

//enum ExpandState {
//    case Expanded
//    case Collapsed
//}

protocol ActionCellDelegate {
    func onAction(sender: AnyObject, parent: UIActionTableViewCell?, actionType: ActionType)
    
    func onAction(section:Int, actionType: ActionType)
}

protocol playCellDelegate {
    func playVideo(sender: AnyObject, parent: UIMediaTableViewCell?)
    func playMusic(sender: AnyObject, parent: UIMediaTableViewCell?)
    func playMediaSource(url:String)
}

/**
*  @author tinkl, 15-06-25 15:06:43
*
*  <#Description#>
*
*  @since <#version number#>
*/
class UIMainSpaceHloderCell: UICellMultiStyle {
    
}



class UISigntureTagsCell: UITableViewCell{
    
}
