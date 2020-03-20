//
//  GARecordingModel+CoreDataProperties.swift
//  Need
//
//  Created by houjianan on 2020/3/20.
//  Copyright © 2020 houjianan. All rights reserved.
//
//

import Foundation
import CoreData


extension GARecordingModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GARecordingModel> {
        return NSFetchRequest<GARecordingModel>(entityName: "GARecordingModel")
    }

    @NSManaged public var data: Data?
    @NSManaged public var dateString: String?
    @NSManaged public var name: String?
    @NSManaged public var path: String?
    @NSManaged public var totalTime: Double
    @NSManaged public var resultText: String?

}
