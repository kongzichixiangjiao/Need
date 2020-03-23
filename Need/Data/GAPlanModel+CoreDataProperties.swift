//
//  GAPlanModel+CoreDataProperties.swift
//  Need
//
//  Created by houjianan on 2020/3/22.
//  Copyright © 2020 houjianan. All rights reserved.
//
//

import Foundation
import CoreData


extension GAPlanModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GAPlanModel> {
        return NSFetchRequest<GAPlanModel>(entityName: "GAPlanModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var createTime: Date?
    @NSManaged public var describe: String?
    @NSManaged public var isFinished: Bool
    @NSManaged public var isPlanning: Bool
    @NSManaged public var state: Int16
    @NSManaged public var isRepeat: Bool
    @NSManaged public var iconName: String?

}
