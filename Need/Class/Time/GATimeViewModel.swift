//
//  GATimeViewModel.swift
//  Need
//
//  Created by houjianan on 2020/3/14.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa

struct GATimeViewModel: GAViewModelType {
    private let vmDatas = Variable<[([GATimeModel])]>([])
}

extension GATimeViewModel {
    typealias Input = TimeInput
    
    typealias Output = TimeOutput
    
    
    struct TimeInput {
        
    }
    
    struct TimeOutput {
        var sections: Driver<[TimeSection]>
        var refreshStatus: Variable<GARefreshStatus>
        let requestCommand = PublishSubject<Bool>()
        
        init(sections: Driver<[TimeSection]>) {
            self.sections = sections
            refreshStatus = Variable(GARefreshStatus.none)
        }
    }
    
    func transform(input: GATimeViewModel.TimeInput) -> GATimeViewModel.TimeOutput {
        let sections = vmDatas.asObservable().map { (sections) -> [TimeSection] in
            sections.map { (models) -> TimeSection in
                return TimeSection(items: models)
            }
        }.asDriver(onErrorJustReturn: [])
        
        
        let out = TimeOutput(sections: sections)
        
        return out
    }
}


struct TimeSection {
    var items: [Item]
}

extension TimeSection: SectionModelType {
    
    typealias Item = GATimeModel
    
    init(original: TimeSection, items: [GATimeModel]) {
        self = original
        self.items = items
    }
}
