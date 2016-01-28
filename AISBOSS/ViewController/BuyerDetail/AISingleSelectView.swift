//
//  AISingleSelectView.swift
//  AIVeris
//
//  Created by tinkl on 1/26/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring
import Cartography

/// 界面容器
class AISingleSelectView: UIView {
    
    var dataSource:[AIPickerViewModel] = {
        
        var option1 = AIOptionModel()
        option1.desc = "2 bedrooms"
        option1.identifier = "4322345678"
        option1.isSelected = true
        option1.displayColor = "#534F5D"
        
        var option2 = AIOptionModel()
        option2.desc = "bedrooms False"
        option2.identifier = "213456"
        option2.isSelected = false
        option2.displayColor = "#534F5D"
        
        let n = AIPickerViewModel()
        n.options = [option1,option2]
        n.identifierPick = "1234"
        return [n]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initControls()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initControls(){

        var heigth:CGFloat = 10
        
        for item in dataSource {
            
            let selectedItems = item.options.filter({ (optionalItem) -> Bool in
                
                if let ita = optionalItem as? AIOptionModel {
                   return ita.isSelected
                }
                return false
            })
            
            let button = DesignableButton()
            button.backgroundColor = UIColor.clearColor()
            button.setTitle(selectedItems.first?.desc ?? "", forState: UIControlState.Normal)
            button.borderWidth = 1
            button.associatedName = item.identifierPick ?? ""
            button.borderColor =  UIColor.whiteColor()
            button.cornerRadius = 2
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            self.addSubview(button)
            button.addTarget(self, action: "singleAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            constrain(button, self, block: { (buttonLayoutProxy, SuperLayoutProxy) -> () in
                buttonLayoutProxy.left == SuperLayoutProxy.left + 30
                buttonLayoutProxy.right == SuperLayoutProxy.right - 30
                buttonLayoutProxy.top == SuperLayoutProxy.top + heigth
                buttonLayoutProxy.height == 35                
            })
            
            heigth += 50
        }
        
        self.setHeight(heigth)
        
    }   
    
    func singleAction(sender: AnyObject){
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pickView:", name: AIApplication.Notification.AISinglePickerViewNotificationName, object: nil)
        let pickView = AISinglePickerView.currentView()
        pickView.superViewID = (sender as! UIButton).associatedName ?? ""
        pickView.show()
    }
    
    func pickView(notify: NSNotification){
        if let obj = notify.object as? [String:AnyObject]{
            let model = obj["model"] as? AIOptionModel
            let id = obj["ID"] as! String
            _ = self.subviews.filter { (viewsubs) -> Bool in
                if let associatedtag = viewsubs.associatedName {
                    if associatedtag == id {
                        (viewsubs as! UIButton).setTitle(model?.desc, forState: UIControlState.Normal)
                        (viewsubs as! UIButton).setTitleColor(UIColor(hex: model?.displayColor ?? ""), forState: UIControlState.Normal)
                    }
                 
                }
                return false
            }
        }
        
    }
    
}