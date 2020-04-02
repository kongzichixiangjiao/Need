//
//  GAPlanModel+CoreDataClass.swift
//  Need
//
//  Created by houjianan on 2020/3/25.
//  Copyright © 2020 houjianan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(GAPlanModel)
public class GAPlanModel: NSManagedObject {
  
}

class GAPlanItemModel {
    var createTime: Date?
    var date: String = ""
    var alertTime: Date?
    var file: [String] = []
    var iconName: String = ""
    var listingName: String = ""
    var location: String = ""
    var note: String = ""
    var repeatString: String = ""
    var subtasks: NSObject?  // 子任务
    var name: String = ""
    var isFinished: Bool = false
    var people: [String] = []
    var listingId: String = ""
    var planId: String = ""
    
    static func getItem(planModel: GAPlanModel) -> GAPlanItemModel {
        let model = GAPlanItemModel()
        model.createTime = planModel.createTime
        model.date = planModel.date ?? ""
        model.file = planModel.file ?? []
        model.iconName = planModel.iconName ?? ""
        model.listingName = planModel.listingName ?? ""
        model.location = planModel.location ?? ""
        model.note = planModel.note ?? ""
        model.repeatString = planModel.repeatString ?? ""
        model.subtasks = planModel.subtasks
        model.name = planModel.name ?? ""
        model.isFinished = planModel.isFinished
        model.people = planModel.people ?? []
        model.planId = planModel.planId ?? ""
        model.alertTime = planModel.alertTime
        return model
    }
}
