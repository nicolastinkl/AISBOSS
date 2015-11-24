//
//  ProposalEnum.swift
//  AIVeris
//
//  Created by Rocky on 15/10/28.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation

enum ServiceOrderState: String {
    case Completed = "Completed"
    case CompletedAndChecked = "CompletedAndChecked"
}

enum ProposalServiceViewTemplate : Int {
    case PlaneTicket = 1
    case Taxi
    case Hotel
    case Shopping
    case Coverage
    case HomeCleaning
    case Prenatal
}