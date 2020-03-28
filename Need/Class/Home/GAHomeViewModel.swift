//
//  GAHomeViewModel.swift
//  Need
//
//  Created by houjianan on 2020/3/22.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation

import RxSwift
import RxDataSources
import RxCocoa

class GAHomeViewModel: GAViewModel {
    private let vmDatas = Variable<[([GAListingModel])]>([])
}

extension GAHomeViewModel: GAViewModelType {
    typealias Input = HomeInput
    
    typealias Output = HomeOutput
    
    
    struct HomeInput {
        
    }
    
    struct HomeOutput: OutputRefreshProtocol {
        var sections: Driver<[GAPlanSection]>
        var refreshStatus: Variable<GARefreshStatus>
        let requestCommand = PublishSubject<Bool>()
        
        init(sections: Driver<[GAPlanSection]>) {
            self.sections = sections
            refreshStatus = Variable(GARefreshStatus.none)
        }
    }
    
    func transform(input: GAHomeViewModel.HomeInput) -> GAHomeViewModel.HomeOutput {
        let sections = vmDatas.asObservable().map { (sections) -> [GAPlanSection] in
            sections.map { (models) -> GAPlanSection in
                return GAPlanSection(items: models)
            }
        }.asDriver(onErrorJustReturn: [])
        
        let out = HomeOutput(sections: sections)
        out.requestCommand.subscribe(onNext: { [weak self]
            isPull in
            guard let weakSelf = self else {
                return
            }
            
            let result = GACoreData.findAllSorted(type: GAListingModel.self)
            weakSelf.vmDatas.value = [(result)]

            out.refreshStatus.value = .endHeaderRefresh
        }).disposed(by: disposeBag)
        return out
    }
}


struct GAPlanSection {
    var items: [Item]
}

extension GAPlanSection: SectionModelType {
    
    typealias Item = GAListingModel
    
    init(original: GAPlanSection, items: [GAListingModel]) {
        self = original
        self.items = items
    }
}
