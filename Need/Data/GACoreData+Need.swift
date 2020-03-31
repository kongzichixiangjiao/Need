//
//  GACoreData+Need.swift
//  Need
//
//  Created by houjianan on 2020/3/21.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation
import MagicalRecord

extension GACoreData {
    
    static func ga_save_recordingModel(resultText: String, name: String?) {
        GACoreData.saveDB(type: GARecordingModel.self, value: name ?? "", block: { (entity) in
            entity?.resultText = resultText
        }) { (models) in
            GAShowWindow.ga_show(message: "保存成功")
        }
    }
    
    static func ga_find_planModel_names() -> [String] {
        return GACoreData.findAll(type: GAListingModel.self).map { (m) -> String in
            return m.name ?? ""
        }
    }
    
    /// 查找计划
    static func ga_find_planModels(value: String) -> [GAPlanModel] {
        return GACoreData.findAll(type: GAPlanModel.self, byAttribute: "listingId",andOrderBy: "isFinished: YES,createTime: NO", value: value)
    }
    
    /// 保存计划
    static func ga_save_planModel(model: GAPlanItemModel, block: @escaping Block<GAPlanModel>) {
        let planId = String.ga_randomNums(count: 18)
        GACoreData.saveDB(type: GAPlanModel.self, key: "planId", value: planId, block: { (empty) in
            empty?.planId = planId
            empty?.listingId = model.listingId
            empty?.createTime = GADate.currentDate
            empty?.date = model.date.ga_checkEmpty(s: Other.kAddPlan_default_dateString)
            empty?.note = model.note
            empty?.name = model.name
            empty?.iconName = (model.iconName.isEmpty) ? Other.kAddPlanImgName_not : model.iconName
            empty?.listingName = model.listingName
            empty?.repeatString = model.repeatString.ga_checkEmpty(s: Other.kAddPlan_default_repeatString)
            empty?.location = model.location
            empty?.subtasks = model.subtasks
            empty?.people = model.people
            empty?.file = model.file
        }) { (result) in
            let objects = GACoreData.findAll(type: GAPlanModel.self, key: "listingId", value: model.listingId)            
            GACoreData.saveDB(type: GAListingModel.self, key: "listingId", value: model.listingId, block: { (empty) in
                empty?.planCount = Int16(objects.count)
            }) { (result) in
                GAShowWindow.ga_show(message: "保存成功")
            }
        }
    }
    
    /// 更新计划：是否完成
    static func ga_save_planModel(name: String, isFinished: Bool, completion: @escaping CompletionHandler<GAPlanModel>) {
        GACoreData.saveDB(type: GAPlanModel.self, value: name, block: { (entity) in
            entity?.isFinished = isFinished
        }) { (models) in
            DispatchQueue.main.async {
                completion(models)
            }
        }
    }
    
    /// 删除计划
    static func ga_delete_planModel(name: String, finished: @escaping FinishedHanlder) {
        GACoreData.delete(type: GAPlanModel.self, name: name) { result in
            finished()
        }
    }
    
}
