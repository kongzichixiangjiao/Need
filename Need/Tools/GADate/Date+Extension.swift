//
//  Date+Extension.swift
//  Need
//
//  Created by houjianan on 2020/4/4.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation

extension Date {
    /// 获取当前 秒级 时间戳 - 10位
    var ga_timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    /// 获取当前 毫秒级 时间戳 - 13位
    var ga_milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
}
