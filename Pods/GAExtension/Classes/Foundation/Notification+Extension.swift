//
//  NotificationName+Extension.swift
//  YE
//
//  Created by 侯佳男 on 2017/12/21.
//  Copyright © 2017年 侯佳男. All rights reserved.
//

import Foundation

public extension Notification.Name {
    struct Tast {
        public static let Name1 = Notification.Name(rawValue: "org.alamofire.notification.name.task.didResume")
        public static let Name2 = Notification.Name(rawValue: "Name2")
        public static let Name3 = Notification.Name(rawValue: "Name3")
        public static let Name4 = Notification.Name(rawValue: "Name4")
    }
}

public extension Notification {
    struct Key {
        public static let task = Notification.Name(rawValue: "org.alamofire.notification.key.task")
    }
}
