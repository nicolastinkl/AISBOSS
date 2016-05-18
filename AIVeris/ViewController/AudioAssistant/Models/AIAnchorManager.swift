//
//  AIAnchorManager.swift
//  AIVeris
//
//  Created by 王坜 on 16/5/16.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

struct AITopViewController {
    
    var controller : AnchorProcess?
    var className : String?
}


protocol AnchorProcess {
    func aaaa()
}

class AIAnchorManager: NSObject {

    //MARK: Public Properties
    static let defaultManager = AIAnchorManager()
    
    //MARK: private Properties
    private var anchors : [AIAnchor] = [AIAnchor]()
    private var topViewController : AnchorProcess?
    
    func handleAnchor(anchor : AIAnchor) {
        anchors.append(anchor)

        
    }
    
    
    
    func setTopViewController(vc : UIViewController) {
       
    }
    
    

    
}
