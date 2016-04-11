//
//  AITaskDataModel.swift
//  AIVeris
//
//  Created by admin on 3/22/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

func == (lhs: TaskNode, rhs: TaskNode) -> Bool {
	return lhs.id == rhs.id
}

func == (lhs: DependOnService, rhs: DependOnService) -> Bool {
	return lhs.id == rhs.id
}

func == (lhs: RequirementTag, rhs: RequirementTag) -> Bool {
    return lhs.id == rhs.id
}

struct TaskNode: Equatable {
	var date: NSDate
	var desc: String
	var id: String
    var insID : String
    var arrageID : String
}

struct DependOnService: Equatable {
	var id: String
	var icon: String
	var desc: String
	var tasks: [TaskNode]
	var selected: Bool
}

struct RequirementTag: Equatable {
    var id: Int
    var selected: Bool
    var textContent: String
}

struct OriginalTagsModel {
    var tagList : [RequirementTag]?
    var requirementID : Int?
    
}