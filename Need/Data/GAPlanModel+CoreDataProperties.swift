//
//  GAPlanModel+CoreDataProperties.swift
//  Need
//
//  Created by houjianan on 2020/3/25.
//  Copyright © 2020 houjianan. All rights reserved.
//
//

import Foundation
import CoreData


extension GAPlanModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GAPlanModel> {
        return NSFetchRequest<GAPlanModel>(entityName: "GAPlanModel")
    }

    @NSManaged public var createTime: Date?
    @NSManaged public var date: String?
    @NSManaged public var file: [String]?
    @NSManaged public var iconName: String?
    @NSManaged public var listingName: String?
    @NSManaged public var location: String?
    @NSManaged public var note: String?
    @NSManaged public var repeatString: String?
    @NSManaged public var subtasks: NSObject? // 子任务
    @NSManaged public var name: String?
    @NSManaged public var isFinished: Bool

}
