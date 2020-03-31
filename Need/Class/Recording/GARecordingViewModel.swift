//
//  GARecordingViewModel.swift
//  Need
//
//  Created by houjianan on 2020/3/15.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa

class GARecordingViewModel: GAViewModel {
    private let vmDatas = Variable<[([GARecordingModel])]>([])
}

extension GARecordingViewModel: GAViewModelType {
    
    typealias Input = GARecordingInput
    
    typealias Output = GARecordingOutput
    
    struct GARecordingInput {
        
    }
    
    struct GARecordingOutput: OutputRefreshProtocol {
        var sections: Driver<[GARecordingSection]>
        var refreshStatus: Variable<GARefreshStatus>
        let requestCommand = PublishSubject<Bool>()
        
        init(sections: Driver<[GARecordingSection]>) {
            self.sections = sections
            refreshStatus = Variable(GARefreshStatus.none)
        }
    }
    
    func transform(input: GARecordingViewModel.GARecordingInput) -> GARecordingViewModel.GARecordingOutput {
        let sections = vmDatas.asObservable().map { (sections) -> [GARecordingSection] in
            sections.map { (models) -> GARecordingSection in
                return GARecordingSection(items: models)
            }
        }.asDriver(onErrorJustReturn: [])

        let out = GARecordingOutput(sections: sections)
        out.requestCommand.subscribe(onNext: { [weak self]
            isPull in
            guard let weakSelf = self else {
                return
            }
            
            let result = GACoreData.findAll(type: GARecordingModel.self)
            weakSelf.vmDatas.value = [(result)]

            out.refreshStatus.value = .endHeaderRefresh
        }).disposed(by: disposeBag)
        return out
    }
    
    func delete(row: Int, tag: Int) {
        let result = GACoreData.findAll(type: GARecordingModel.self)
        
        GACoreData.delete(type: GARecordingModel.self, key: "name", value: result[row].name ?? "") {
            [weak self] result in
            if let weakSelf = self {
                weakSelf.vmDatas.value = [(result)]
            }
        }
        
    }
}


struct GARecordingSection {
    var items: [Item]
}

extension GARecordingSection: SectionModelType {
    
    typealias Item = GARecordingModel
    
    init(original: GARecordingSection, items: [GARecordingModel]) {
        self = original
        self.items = items
    }
}
