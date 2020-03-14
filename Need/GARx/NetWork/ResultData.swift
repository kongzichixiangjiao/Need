//
//  ResultData.swift
//  GARxSwift
//
//  Created by houjianan on 2020/3/9.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation

protocol ResultDataProtocol {
    var message: String? { get set }
    var returnCode: String? { get set }
    var token: String? { get set }
}

protocol DataProtocol {
    var curPage: Int? { get }
    var isNextPage: Bool? { get }
    var pageSize: Int? { get }
    var total: Int? { get }
}

