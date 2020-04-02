//
//  GAListingModel+CoreDataProperties.swift
//  Need
//
//  Created by houjianan on 2020/3/31.
//  Copyright © 2020 houjianan. All rights reserved.
//
//

import Foundation
import CoreData


extension GAListingModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GAListingModel> {
        return NSFetchRequest<GAListingModel>(entityName: "GAListingModel")
    }

    @NSManaged public var color: String?
    @NSManaged public var coverImage: Data?
    @NSManaged public var createTime: Date?
    @NSManaged public var describe: String?
    @NSManaged public var iconName: String?
    @NSManaged public var isFinished: Bool
    @NSManaged public var isPlanning: Bool
    @NSManaged public var isRepeat: Bool
    @NSManaged public var listingId: String?
    @NSManaged public var name: String?
    @NSManaged public var nameNote: String?
    @NSManaged public var planCount: Int16
    @NSManaged public var state: Int16

}
