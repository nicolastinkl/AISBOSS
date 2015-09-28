//
//  UICoverFlowViewDataSoureAndDelegate.swift
//  AIVeris
//
//  Created by tinkl on 16/9/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

// MARK: Protocol

/*!
*  @author tinkl, 15-09-16 17:09:36
*
*  DataSource
*/
@objc
protocol UICoverFlowViewDataSource{
    optional var service_name:String{ get }
    optional var service_intro:String{ get }
    optional var service_price:String{ get }
    optional var service_img:String{ get }
    optional var provider_icon:String{ get }
    optional var provider_name:String{ get }
    optional var service_rating:CGFloat{ get }
}

/*!
*  @author tinkl, 15-09-16 17:09:45
*
*  Delegate
*/
protocol UICoverFlowViewDelegate{
    func refreshAction()
}

// MARK: ViewModel
/*struct UICoverFlowModel: UICoverFlowViewDataSource{

}*/

