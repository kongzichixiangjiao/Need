//
//  GACoreData.swift
//  Need
//
//  Created by houjianan on 2020/3/15.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation
import MagicalRecord

class GACoreData: MagicalRecord {
    
    static func create(obj: NSManagedObject) {
        
    }
    
    static func saveDB<T: NSManagedObject>(type: T.Type, name: String, block: @escaping (_ entity: T?) -> (), completion: @escaping (_ models: [T]) -> ()) {
        MagicalRecord.save({ (context) in
            let predicate = NSPredicate(format: "name==%@", name)
            let count = type.mr_countOfEntities(with: predicate)
            var entity: T?
            if count == 0 {
                entity = type.mr_createEntity(in: context)
            } else {
                entity = type.mr_findAll(with: predicate, in: context)?.first as? T
            }
            block(entity)
        }) { (finished, error) in
            let result = type.mr_findAll() as! [T]
            completion(result)
            GAShowWindow.ga_show(message: "保存成功")
        }
    }
    static func findAll<T: NSManagedObject>(type: T.Type) -> [T] {
        return type.mr_findAll() as! [T]
    }
    
    
    
}
