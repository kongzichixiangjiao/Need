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
    static func ga_save_planModel(model: GAPlanItemModel, isAdd: Bool = true, block: @escaping Block<GAPlanModel>) {
        if isAdd {
            let count = GACoreData.findAll(type: GAPlanModel.self, key: "name", value: model.name.ga_checkEmpty(s: DefaultText.name)).count
            if count > 0 {
                GAShowWindow.ga_show(message: "已经存在", duration: 0.5)
                return
            }
        }
        let planId = model.planId.isEmpty ? String.ga_randomNums(count: 18) : model.planId
        GACoreData.saveDB(type: GAPlanModel.self, key: "planId", value: planId, block: { (empty) in
            empty?.planId = planId
            empty?.listingId = model.listingId
            empty?.createTime = GADate.currentDate
            empty?.alertTime = model.alertTime
            empty?.alertTimeString = model.alertTimeString
            empty?.alertDate = model.alertDate
            empty?.alertDateString = model.alertDateString
            empty?.date = model.date.ga_checkEmpty(s: DefaultText.addPlan_dateString)
            empty?.note = model.note.ga_checkEmpty(s: DefaultText.note)
            empty?.name = model.name.ga_checkEmpty(s: DefaultText.name)
            empty?.iconName = (model.iconName.isEmpty) ? Other.kAddPlanImgName_not : model.iconName
            empty?.listingName = model.listingName
            empty?.repeatString = model.repeatString.ga_checkEmpty(s: DefaultText.addPlan_repeatString)
            empty?.location = model.location
            empty?.subtasks = model.subtasks
            empty?.color = Need.kListingDefaultColor
            empty?.people = model.people.count == 0 ?DefaultText.people : model.people
            empty?.file = model.file
            empty?.isFinished = false 
            if GARepeatStringType(rawValue: empty?.repeatString ?? "") == .day {
                let weeks = model.weeks
                for week in weeks {
                    empty?.weeks = [week]
                    GALocalPushManager.share.post(planModel: empty!)
                }
            } else {
                GALocalPushManager.share.post(planModel: empty!)
            }
            empty?.weeks = model.weeks
            block(empty)
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
    static func ga_save_planModel(model: GAPlanItemModel, isFinished: Bool, completion: @escaping CompletionHandler<GAPlanModel>) {
        GACoreData.saveDB(type: GAPlanModel.self, key: "planId", value: model.planId, block: { (entity) in
            entity?.isFinished = isFinished
            if !isFinished {
                if GARepeatStringType(rawValue: entity?.repeatString ?? "") == .day {
                    let weeks = model.weeks
                    for week in weeks {
                        entity?.weeks = [week]
                        GALocalPushManager.share.post(planModel: entity!)
                    }
                } else {
                    GALocalPushManager.share.post(planModel: entity!)
                }
            }
        }) { (models) in
            DispatchQueue.main.async {
                completion(models)
            }
        }
    }
    
    /// 删除计划
    static func ga_delete_planModel(planId: String, finished: @escaping FinishedHanlder) {
        GACoreData.delete(type: GAPlanModel.self, key: "planId", value: planId) { result in
            finished()
        }
    }
    
    static func ga_delete_listingModel(listingId: String, finished: @escaping FinishedHanlder) {
        GACoreData.delete(type: GAListingModel.self, key: "listingId", value: listingId) { result in
            finished()
        }
    }
    
    static func ga_save_timeLineModel(model: GATimeLineModel, timeLineId: String, finished: @escaping FinishedHanlder) {
        GACoreData.saveDB(type: GATimeLineModel.self, key: "timeLineId", value: timeLineId, block: { (entity) in
            entity?.startDate = model.startDate
            entity?.endDate = model.endDate
            entity?.describe = model.describe
            entity?.name = model.name
            entity?.nature = model.nature
            entity?.createTime = Date()
            entity?.timeLineId = String.ga_random(18)
        }) { (result) in
            GAShowWindow.ga_show(message: "保存成功")
        }
    }
    static func ga_delete_timeLineModel(timeLineId: String, finished: @escaping FinishedHanlder) {
        GACoreData.delete(type: GATimeLineModel.self, key: "timeLineId", value: timeLineId) { (result) in
            GAShowWindow.ga_show(message: "删除成功")
        }
    }
}
