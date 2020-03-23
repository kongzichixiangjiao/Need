//
//  GACoreData+Need.swift
//  Need
//
//  Created by houjianan on 2020/3/21.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation

extension GACoreData {
    static func ga_save(resultText: String, name: String?) {
        GACoreData.saveDB(type: GARecordingModel.self, name: name ?? "", block: { (entity) in
            entity?.resultText = resultText
        }) { (models) in
            GAShowWindow.ga_show(message: "保存成功")
        }
    }
    
}
