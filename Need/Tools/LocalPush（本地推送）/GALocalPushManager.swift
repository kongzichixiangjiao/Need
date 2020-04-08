//
//  GALocalPushManager.swift
//  YYFramework
//
//  Created by houjianan on 2019/8/22.
//  Copyright © 2019 houjianan. All rights reserved.
//  本地推送

import Foundation
import AVKit


enum AlarmSoundNames: String {
    case
        firstAlarmSound = "firstSound.mp3",
        secondAlarmSound = "secondSound.mp3",
        scaryAlarmSound = "scarySound.mp3"
}


class GALocalPushManager: NSObject {
    
    var _player: AVAudioPlayer!
    
    static let share: GALocalPushManager = GALocalPushManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    public func check(handler: @escaping (Bool) -> ()) {
        notificationCenter.requestAuthorization(options: [.alert,.badge,.sound]) { (granted: Bool, error: Error?) in
            handler(granted)
            self.notificationCenter.delegate = self
            self.setupActionsAndCategories()
        }
    }
    
    func setupActionsAndCategories() {
        // 黑色文字。点击会进app。
        let action = UNNotificationAction(identifier: "enterApp", title: "进入应用", options: .foreground)
        // 黑色文字。点击不会进app。
        let clearAction = UNNotificationAction(identifier: "clearaction", title: "忽略", options: .destructive)
        // 需要解锁显示，红色文字。点击不会进app。
        let categoryAuthenticationRequired = UNNotificationAction(identifier: "lookDetails", title: "查看详情", options: .authenticationRequired)
        let category = UNNotificationCategory(identifier: "need.com", actions: [action, clearAction, categoryAuthenticationRequired], intentIdentifiers: [], options: [])
        notificationCenter.setNotificationCategories(Set(arrayLiteral: category))
    }
    
    func setComponents(planModel: GAPlanModel, content: UNMutableNotificationContent) -> UNNotificationRequest? {
        //        var timeTrigger: UNTimeIntervalNotificationTrigger!
        var calendarTrigger: UNCalendarNotificationTrigger!
        var request: UNNotificationRequest?
        switch planModel.repeatString {
        case "每分":
            var components = DateComponents()
            components.second = 0
            calendarTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            request = UNNotificationRequest(identifier: planModel.planId ?? "", content: content, trigger: calendarTrigger)
            break
        case "每时":
            var components = DateComponents()
            components.minute = planModel.alertTime?.minute
            components.second = 0
            calendarTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            request = UNNotificationRequest(identifier: planModel.planId ?? "", content: content, trigger: calendarTrigger)
            break
        case "每天":
            var components = DateComponents()
            for week in planModel.weeks ?? [] {
                if let time = planModel.alertTime {
                    let timeRegion = GASwiftDate.dateRegion(date: time)
                    #if DEBUG
                    print(timeRegion.hour, "点", timeRegion.minute, "分")
                    #endif
                    components.weekday = week.weekInt
                    components.hour = timeRegion.hour
                    components.minute = timeRegion.minute
                    components.second = 0
                    calendarTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                    request = UNNotificationRequest(identifier: (planModel.planId ?? "") + String(week.weekInt), content: content, trigger: calendarTrigger)
                } else {
                    let content = UNMutableNotificationContent()
                    content.title = "Need"
                    content.subtitle = ""
                    content.body = "新增的计划还没有设置提醒日期，设置一个提醒吧？"
                    content.badge = 1
                    content.categoryIdentifier = ""
                    request = UNNotificationRequest(identifier: planModel.planId ?? "", content: content, trigger: nil)
                }
            }
            break
        case "每周":
            var components = DateComponents()
            components.weekday = 4
            components.hour = planModel.alertTime?.hour
            components.minute = planModel.alertTime?.minute
            calendarTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            request = UNNotificationRequest(identifier: planModel.planId ?? "", content: content, trigger: calendarTrigger)
            break
        case "每月":
            var components = DateComponents()
            components.day = planModel.alertTime?.day
            components.hour = planModel.alertTime?.hour
            components.minute = planModel.alertTime?.minute
            calendarTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            request = UNNotificationRequest(identifier: planModel.planId ?? "", content: content, trigger: calendarTrigger)
            break
        case "每年":
            var components = DateComponents()
            components.month = planModel.alertTime?.month
            components.day = planModel.alertTime?.day
            components.hour = planModel.alertTime?.hour
            components.minute = planModel.alertTime?.minute
            calendarTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            request = UNNotificationRequest(identifier: planModel.planId ?? "", content: content, trigger: calendarTrigger)
            break
        case "指定时间":
            if let date = planModel.alertDate, let time = planModel.alertTime {
                let dateRegion = GASwiftDate.dateRegion(date: date)
                let timeRegion = GASwiftDate.dateRegion(date: time)
                var components = DateComponents()
                #if DEBUG
                print(dateRegion.year, "年", dateRegion.month, "月", dateRegion.day, "日",
                      dateRegion.hour, "点", dateRegion.minute, "分")
                #endif
                components.year = dateRegion.year
                components.month = dateRegion.month
                components.day = dateRegion.day
                components.hour = timeRegion.hour
                components.minute = timeRegion.minute
                components.second = 0
                calendarTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                request = UNNotificationRequest(identifier: planModel.planId ?? "", content: content, trigger: calendarTrigger)
            } else {
                let content = UNMutableNotificationContent()
                content.title = "Need"
                content.subtitle = ""
                content.body = "新增的计划还没有设置提醒日期，设置一个提醒吧？"
                content.badge = 1
                content.categoryIdentifier = ""
                request = UNNotificationRequest(identifier: planModel.planId ?? "", content: content, trigger: nil)
            }
            break
        default:
            break
        }
        return request
    }
    
    public func post(planModel: GAPlanModel) {
        
        let content = UNMutableNotificationContent()
        content.title = planModel.name ?? ""
        content.subtitle = planModel.note ?? ""
        content.body = planModel.note ?? ""
        content.badge = 1
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: AlarmSoundNames.firstAlarmSound.rawValue))
        content.categoryIdentifier = planModel.planId ?? ""
        
        if let request = setComponents(planModel: planModel, content: content) {
            notificationCenter.add(request)
            print("------------发送-----------")
        }
    }
    
    func removeAll() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func remove(requesIDs: [String]) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: requesIDs)
    }
    
    private func _playAudio(fileName: String, type: String = "caf") {
        if let url = Bundle.main.url(forResource: "dx07" + "." + type, withExtension: nil) {
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(.playback)
            try! session.setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
            
//            //vibrate phone first
//            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//            //set vibrate callback
//            AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate), nil, nil, { (_:SystemSoundID, _:UnsafeMutableRawPointer?) -> Void in
//                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//
//            }, nil)
            
            _player = try! AVAudioPlayer(contentsOf: url)
            _player.numberOfLoops = 1
            _player.volume = 4
            _player.prepareToPlay()
            _player.play()
        } else {
            AudioServicesPlaySystemSound(1008)
        }
    }
    
}

extension GALocalPushManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        GAShowWindow.ga_show(message: "将要推送")
        let options: UNNotificationPresentationOptions = [.alert, .badge, .sound]
//        _playAudio(fileName: "dx07")
        completionHandler(options)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let categoryID = response.notification.request.content.categoryIdentifier
        if categoryID == "categoryIdentifier" {
            if response.actionIdentifier == "enterApp" {
                
            } else {
                
            }
        }
        completionHandler()
    }
    
}

extension String {
    var weekInt: Int {
        let weekDic = ["星期日" : 1,
                       "星期一" : 2,
                       "星期二" : 3,
                       "星期三" : 4,
                       "星期四" : 5,
                       "星期五" : 6,
                       "星期六" : 7,
        ]
        return weekDic[self] ?? -1
    }
}
