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

class AISingleSelectView: UIView {
    
    var dataSource:[AIPickerViewModel] = {
        let n = AIPickerViewModel()
        
        return [n,n,n,n]
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
        
        for _ in dataSource {
            
            let button = DesignableButton()
            button.backgroundColor = UIColor.clearColor()
            button.setTitle("Single Seclect 1", forState: UIControlState.Normal)
            button.borderWidth = 1
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
        pickView.show()
    }
    
    func pickView(notify: NSNotification){
        
    }
    
}