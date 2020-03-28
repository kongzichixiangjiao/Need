//
//  NotificationCenter+Rx.swift
//  GARxSwift
//
//  Created by houjianan on 2020/3/12.
//  Copyright © 2020 houjianan. All rights reserved.
//

//NotificationCenter.default.rx.notification(custom: "key".ga_notificationName).subscribe(onNext: { (value) in
//    print(value)
//}).disposed(by: disposeBag)
//
//NotificationCenter.ga_post(customeNotification: "key".ga_notificationName)

import Foundation
import RxSwift

extension Reactive where Base: NotificationCenter {
    func ga_notification(custom name: Notification.Name, object: AnyObject? = nil) -> Observable<Notification> {
        return notification(name, object: object)
    }
}


