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

extension GAPlanModel {
    static func createModel() -> GAPlanModel {
//        let context = NSManagedObjectContext.mr_default()
//        let entity = NSEntityDescription.entity(forEntityName: "GAPlanModel", in: context)!
//        let model = GAPlanModel(entity: entity, insertInto: context)
        let model = GAPlanModel.mr_createEntity()
        return model!
    }
}

class GAPlanItemModel {
    var createTime: Date?
    var date: String = ""
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
        return model
    }
    
    func getPlanModel() -> GAPlanModel {
        let model = GAPlanModel()
        model.createTime = self.createTime
        model.date = self.date
        model.file = self.file
        model.iconName = self.iconName
        model.listingName = self.listingName
        model.location = self.location
        model.note = self.note
        model.repeatString = self.repeatString
        model.subtasks = self.subtasks
        model.name = self.name
        model.isFinished = self.isFinished
        model.people = self.people
        return model 
    }
}
