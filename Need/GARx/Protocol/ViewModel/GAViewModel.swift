//
//  File.swift
//  GARxSwift
//
//  Created by houjianan on 2020/3/11.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation
import RxSwift

protocol GAViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class GAViewModel {
    
    var disposeBag = DisposeBag()
    var currentPage: Int = 1
}
