//
//  NotificationName+Extension.swift
//  GAFramework
//
//  Created by houjianan on 2019/9/24.
//  Copyright © 2019 houjianan. All rights reserved.
//

import Foundation

public extension Notification.Name {
    /// 使用命名空间的方式
    struct SocketTask {
        public static let connectFailure = Notification.Name(rawValue: "connectFailure")
        public static let connectSuccess = Notification.Name(rawValue: "connectSuccess")
  }
    
}
