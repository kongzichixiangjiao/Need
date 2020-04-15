//
//  GATimeLineModel+CoreDataProperties.swift
//  Need
//
//  Created by houjianan on 2020/4/11.
//  Copyright © 2020 houjianan. All rights reserved.
//
//

import Foundation
import CoreData


extension GATimeLineModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GATimeLineModel> {
        return NSFetchRequest<GATimeLineModel>(entityName: "GATimeLineModel")
    }

    @NSManaged public var createTime: Date?
    @NSManaged public var describe: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var name: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var timeLineId: String?
    @NSManaged public var nature: String?

}
