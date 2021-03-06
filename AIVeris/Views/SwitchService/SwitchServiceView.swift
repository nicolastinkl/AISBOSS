//
//  SwitchServiceView.swift
//  AIVeris
//  服务开关方式展示
//  Created by Rocky on 15/9/21.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//
/*
override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

let switchView = SwitchServiceView.createSwitchServiceView()
cell.contentView.addSubview(switchView)

constrain(switchView) { switchView in
switchView.left == switchView.superview!.left
switchView.top == switchView.superview!.top
switchView.right == switchView.superview!.right
switchView.height == SwitchServiceView.HEIGHT
}


return cell
}
*/

import UIKit
import Cartography

protocol ServiceSwitchDelegate {
    func switchStateChanged(isOn: Bool, operationService: Service,fromView: UIView?)
}


class SwitchServiceView: UIView {

    static let HEIGHT: CGFloat = 100

    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceDescription: UILabel!
    @IBOutlet weak var price: UILabel!
    var switchController: SevenSwitch!
    private var operationService: Service?
    @IBOutlet weak var switchHolder: UIView!
    var switchDelegate: ServiceSwitchDelegate?
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        switchController = SevenSwitch(frame: CGRectMake(0, switchHolder.top, switchHolder.width, switchHolder.height))
        
        addSubview(switchController)
        
        constrain(switchController, switchHolder) { switchView, holderView in
            switchView.top == holderView.top
            switchView.left == holderView.left
            switchView.width == holderView.width
            switchView.height == holderView.height
        }
        
        switchController.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)
        switchController.onLabel.text = "SwitchServiceView.on".localized
        switchController.onLabel.textColor = UIColor.whiteColor()
        switchController.offLabel.text = "SwitchServiceView.off".localized
        switchController.offLabel.textColor = UIColor.whiteColor()
        switchController.onTintColor = UIColor(red:0.33, green:0.28, blue:0.58, alpha:1)
        switchController.inactiveColor =  UIColor(red:0.78, green:0.78, blue:0.8, alpha:1)
        switchController.isRounded = false
        
        // turn the switch on with animation
        switchController.setOn(false, animated: false)
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

            }
    
    func switchChanged(sender: SevenSwitch) {
        if let ser = operationService {
            switchDelegate?.switchStateChanged(sender.on, operationService: ser,fromView: self)
        }
    }
    
    static func createSwitchServiceView() -> SwitchServiceView {
        
        let nib = NSBundle.mainBundle().loadNibNamed("SwitchServiceView", owner: self, options: nil)
        
        return nib.first as! SwitchServiceView
    }
    
    func setService(service: Service) {
        operationService = service
        serviceName.text = service.service_name ?? ""
        //serviceDescription.text = service.service_intro as String
        price.text = service.service_price?.price_show ?? ""
    }
}



