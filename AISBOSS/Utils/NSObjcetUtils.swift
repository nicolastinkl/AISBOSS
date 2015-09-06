//
//  NSObjcetUtils.swift
//  AI2020OS
//
//  Created by tinkl on 30/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation


extension NSObject{
    /*!
    the local coding scope.
    */
    func localCode(closeure:()->()){
        closeure()
    }
}