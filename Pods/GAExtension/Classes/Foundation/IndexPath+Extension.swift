//
//  IndexPath+Extension.swift
//  GAFramework
//
//  Created by houjianan on 2019/11/30.
//  Copyright © 2019 houjianan. All rights reserved.
//

import Foundation

public extension IndexPath {
    /// Reload the "+" operator
    static func + (left: IndexPath, right: Int) -> IndexPath {
        return IndexPath.init(row: left.row + right, section: left.section)
    }
    
    /// Reload the "-" operator
    static func - (left: IndexPath, right: Int) -> IndexPath {
        return IndexPath.init(row: left.row - right, section: left.section)
    }
}
