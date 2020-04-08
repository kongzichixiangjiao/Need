//
//  GAPlanModel+CoreDataProperties.swift
//  Need
//
//  Created by houjianan on 2020/4/4.
//  Copyright © 2020 houjianan. All rights reserved.
//
//

import Foundation
import CoreData


extension GAPlanModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GAPlanModel> {
        return NSFetchRequest<GAPlanModel>(entityName: "GAPlanModel")
    }

    @NSManaged public var alertTime: Date?
    @NSManaged public var color: String?
    @NSManaged public var createTime: Date?
    @NSManaged public var date: String?
    @NSManaged public var file: [String]?
    @NSManaged public var iconName: String?
    @NSManaged public var isFinished: Bool
    @NSManaged public var listingId: String?
    @NSManaged public var listingName: String?
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var people: [String]?
    @NSManaged public var planId: String?
    @NSManaged public var repeatString: String?
    @NSManaged public var subtasks: NSObject?
    @NSManaged public var weeks: [String]?
    @NSManaged public var alertTimeString: String?
    @NSManaged public var alertDate: Date?
    @NSManaged public var alertDateString: String?

}
