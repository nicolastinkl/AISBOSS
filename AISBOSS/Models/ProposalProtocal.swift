//
//  ProposalProtocal.swift
//  AIVeris
//
//  Created by Rocky on 15/10/28.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

protocol ServiceOrderStateProtocal {
    func orderStateChanged(changedOrder: ServiceOrderModel, oldState: ServiceOrderState)
}
