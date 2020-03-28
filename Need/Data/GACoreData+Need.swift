//
//  GACoreData+Need.swift
//  Need
//
//  Created by houjianan on 2020/3/21.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation

extension GACoreData {
    
    static func ga_save_recordingModel(resultText: String, name: String?) {
        GACoreData.saveDB(type: GARecordingModel.self, name: name ?? "", block: { (entity) in
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
    
    static func ga_save_planModel(model: GAPlanItemModel, listingName: String) {
        GACoreData.saveDB(type: GAPlanModel.self, name: model.name, block: { (empty) in
            empty?.createTime = GADate.currentDate
            empty?.date = model.date.ga_checkEmpty(s: Other.kAddPlan_default_dateString)
            empty?.note = model.note
            empty?.name = model.name
            empty?.iconName = model.iconName.isEmpty ? Other.kAddPlanImgName_not : model.iconName
            let listingName = model.listingName.isEmpty ? listingName : model.listingName
            empty?.listingName = listingName
            empty?.repeatString = model.repeatString.ga_checkEmpty(s: Other.kAddPlan_default_repeatString)
            empty?.location = model.location
            empty?.subtasks = model.subtasks
            empty?.file = model.file
        }) { (result) in
            GAShowWindow.ga_show(message: "保存成功")
        }
    }
    
    static func ga_find_planModels(value: String) -> [GAPlanModel] {
        return GACoreData.findAll(type: GAPlanModel.self, byAttribute: "listingName",andOrderBy: "isFinished: YES,createTime: NO", value: value)
    }
    
    static func ga_save_planModel(name: String, isFinished: Bool, completion: @escaping CompletionHandler<GAPlanModel>) {
        GACoreData.saveDB(type: GAPlanModel.self, name: name, block: { (entity) in
            entity?.isFinished = isFinished
        }) { (models) in
            DispatchQueue.main.async {
                completion(models)
            }
        }
    }
    
}
