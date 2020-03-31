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
    
    typealias CompletionHandler<T: NSManagedObject> = (_ models: [T]) -> ()
    typealias Block<T: NSManagedObject> = (_ entity: T?) -> ()
    typealias BlockArray<T: NSManagedObject> = (_ entities: [T]) -> ()
    typealias FinishedHanlder = () -> ()
    
    static func saveDB<T: NSManagedObject>(type: T.Type, key: String = "name", value: String, block: @escaping Block<T>, completion: @escaping CompletionHandler<T>) {
        MagicalRecord.save({ (context) in
            let predicate = NSPredicate(format: key + "==%@", value)
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
    
    static func count<T: NSManagedObject>(type: T.Type) -> Int {
        return Int(type.mr_countOfEntities())
    }
    
    static func findAll<T: NSManagedObject>(type: T.Type) -> [T] {
        return type.mr_findAll() as! [T]
    }
    
    static func findAll<T: NSManagedObject>(type: T.Type, key: String, value: String) -> [T] {
        return type.mr_find(byAttribute: key, withValue: value) as! [T]
    }
    
    static func findAll<T: NSManagedObject>(type: T.Type, byAttribute: String = "name", andOrderBy: String = "createTime", value: String) -> [T] {
        return type.mr_find(byAttribute: byAttribute, withValue: value, andOrderBy: andOrderBy, ascending: true) as! [T]
    }
    
    static func findAllSorted<T: NSManagedObject>(type: T.Type, by: String = "date", ascending: Bool = true) -> [T] {
        return type.mr_findAllSorted(by: "createTime", ascending: ascending) as! [T]
    }
    
    static func delete<T: NSManagedObject>(type: T.Type, key: String, value: String, completion: @escaping CompletionHandler<T>) {
        MagicalRecord.save({ (context) in
            let predicate = NSPredicate(format: key + "==%@", value)
            guard let array = type.mr_findAll(with: predicate) else {
                return
            }
            if array.count != 0 {
                for model in array {
                    model.mr_deleteEntity(in: context)
                }
            }
        }) { (finished, error) in
            let result = type.mr_findAll() as! [T]
            completion(result)
            GAShowWindow.ga_show(message: "删除成功")
        }
    }
    
    static func change<T: NSManagedObject>(type: T.Type, name: String, blockArray: @escaping BlockArray<NSManagedObject>, completion: @escaping CompletionHandler<T>) {
        MagicalRecord.save({ (context) in
            let _ = NSPredicate(format: "name==%@", name)
            let array = type.mr_find(byAttribute: "name", withValue: name, in: context)
            
            blockArray(array ?? [])
        }) { (finished, error) in
            let result = type.mr_findAll() as! [T]
            completion(result)
            GAShowWindow.ga_show(message: "删除成功")
        }
    }
    
}
