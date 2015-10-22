//
//  ViewProtocal.swift
//  AIVeris
//
//  Created by Rocky on 15/10/21.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

protocol Measureable {
    func getHeight() -> CGFloat
}

protocol DimentionChangable {
    func heightChanged(beforeHeight: CGFloat, afterHeight: CGFloat)
}

