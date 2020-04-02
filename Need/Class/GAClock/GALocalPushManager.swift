//
//  GALocalPushManager.swift
//  YYFramework
//
//  Created by houjianan on 2019/8/22.
//  Copyright © 2019 houjianan. All rights reserved.
//  本地推送

import Foundation

class GALocalPushManager: NSObject {
    
    static let share: GALocalPushManager = GALocalPushManager()
    
    func check(handler: @escaping (Bool) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (granted: Bool, error: Error?) in
            handler(granted)
        }
    }
    
    public func post(planModel: GAPlanItemModel) {
        
        let content = UNMutableNotificationContent()
        content.title = planModel.name
        content.subtitle = planModel.note
        content.body = ""
        content.badge = 1
        content.categoryIdentifier = planModel.planId
        if #available(iOS 12.0, *) {
            content.sound = .defaultCritical
        } else {
            content.sound = .default
        }
        
        // 黑色文字。点击会进app。
        let action = UNNotificationAction(identifier: "enterApp", title: "进入应用", options: .foreground)
        // 黑色文字。点击不会进app。
        let clearAction = UNNotificationAction(identifier: "clearaction", title: "忽略", options: .destructive)
        // 需要解锁显示，红色文字。点击不会进app。
        let categoryAuthenticationRequired = UNNotificationAction(identifier: "lookDetails", title: "查看详情", options: .authenticationRequired)
        let category = UNNotificationCategory(identifier: planModel.planId, actions: [action, clearAction, categoryAuthenticationRequired], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories(Set(arrayLiteral: category))
        
        // 60秒侯提醒 必须大于60秒repeat
        //
        
        //周日早8点
        var components = DateComponents()
        let repeatString = planModel.repeatString
        if let date = planModel.date.toDate() {
            components.year = date.year
            
            if repeatString == "每年" {
                components.month = date.month
            }
        } else {
            if let time = planModel.alertTime {
                components.year = time.year
                
                if repeatString != "每年" {
                    components.month = time.month
                }
            }
        }
        if let time = planModel.alertTime {
            if repeatString != "每年" || repeatString != "每月" || repeatString != "每天" || repeatString != "每时" {
                components.minute = time.minute
            }
            if repeatString != "每年" || repeatString != "每月" || repeatString != "每天" {
                components.hour = time.hour
            }
            if repeatString != "每年" || repeatString != "每月" {
                components.day = time.day
            }
        }
        
        
        
        // 60秒后发送
        //        let trigger1 = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        let trigger3 = UNCalendarNotificationTrigger(dateMatching: components, repeats: (planModel.repeatString ?? "") != "关闭")
        let request = UNNotificationRequest(identifier: planModel.planId ?? "", content: content, trigger: trigger3)
        //        let coordinate = CLLocationCoordinate2D(latitude: 52.10, longitude: 51.11)
        //        let region = CLCircularRegion(center: coordinate, radius: 200, identifier: "center")
        //        region.notifyOnEntry = true  //进入此范围触发
        //        region.notifyOnExit = false  //离开此范围不触发
        //        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            print(error ?? "成功")
        }
    }
    
    func removeAll() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func remove(requesIDs: [String]) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: requesIDs)
    }
}

extension GALocalPushManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("将要推送")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("发送")
        let categoryID = response.notification.request.content.categoryIdentifier
        if categoryID == "categoryIdentifier" {
            if response.actionIdentifier == "enterApp" {
                
            } else {
                
            }
        }
        completionHandler()
    }
    
}
