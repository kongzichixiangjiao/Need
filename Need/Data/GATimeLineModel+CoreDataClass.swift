//
//  GATimeLineModel+CoreDataClass.swift
//  Need
//
//  Created by houjianan on 2020/4/8.
//  Copyright © 2020 houjianan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(GATimeLineModel)
public class GATimeLineModel: NSManagedObject {
    
    static func empty() -> GATimeLineModel {
        return GATimeLineModel(entity: NSEntityDescription.entity(forEntityName: "GATimeLineModel", in: NSManagedObjectContext.mr_default())!, insertInto: nil)
    }
    
}
