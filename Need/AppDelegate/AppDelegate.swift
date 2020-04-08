//
//  AppDelegate.swift
//  Need
//
//  Created by houjianan on 2020/3/14.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import CoreData
import SwiftMonkeyPaws
import AVFoundation 

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var _player: AVAudioPlayer!
    var _isPlayed: Bool = false
    var _bgTaskId: UIBackgroundTaskIdentifier?
    
    var _locationManager: CLLocationManager!
    
    let center = UNUserNotificationCenter.current()
    
    var paws: MonkeyPaws?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(NSHomeDirectory())
        mrCoreData_init()
        
        // monkey()
        always_initPlayMusic()
        always_initLocationManager()
        GALocalPushManager.share.check { (b) in
            print(b)
        }
        _showFloatButton()
        
        return true
    }
    
    func _monkey() {
        paws = MonkeyPaws(view: window!)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    // 退到后台
    func applicationWillResignActive(_ application: UIApplication) {
        always_applicationWillResignActive(application)
    }
    
    // 进入前台
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    // 退到后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func always_initLocationManager() {
        //1.创建定位管理对象
        _locationManager = CLLocationManager()
        
        //2.设置属性 distanceFilter、desiredAccuracy
        _locationManager.distanceFilter = kCLDistanceFilterNone //实时更新定位位置
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest  //定位精确度
        _locationManager.requestAlwaysAuthorization()
        
        //该模式是抵抗程序在后台被杀，申明不能够被暂停
        _locationManager.pausesLocationUpdatesAutomatically = false
        _locationManager.allowsBackgroundLocationUpdates = true
        //3.设置代理
        _locationManager.delegate = self
        //4.开始定位
        _locationManager.startUpdatingLocation()
        //5.获取朝向
        _locationManager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch (status) {
        case .authorizedWhenInUse: break
        case .authorizedAlways:
            _locationManager.startUpdatingLocation()
            break;
        case .denied:
            // 用户拒绝使用定位，可在此引导用户开启
            break;
        case .restricted:
            // 权限受限，可引导用户开启
            break;
        case .notDetermined:
            // 未选择，在代理方法里，一般不会有这个状态，如果有m，再次发起申请
            break;
        default:
            break;
        }
    }
    
    @available(iOS 13.0, *)
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        
    }
    
    func checkLocationState() {
        // 先判断是否可使用定位服务
        if (!CLLocationManager.locationServicesEnabled()) {
                return
        }
        // 获取当前授权状态
        let status = CLLocationManager.authorizationStatus()
           
        switch (status) {
        case .authorizedWhenInUse: break
        case .authorizedAlways:
            _locationManager.startUpdatingLocation()
            break;
        case .denied:
            // 用户拒绝使用定位，可在此引导用户开启
            break;
        case .restricted:
            // 权限受限，可引导用户开启
            break;
        case .notDetermined:
            // 未选择，在代理方法里，一般不会有这个状态，如果有m，再次发起申请
            break;
        default:
            break;
        }
    }
    
}

extension AppDelegate {
    /*
     var _player: AVAudioPlayer!
     var _isPlayed: Bool = false
     var _bgTaskId: UIBackgroundTaskIdentifier?
     */
    func always_initPlayMusic() {
        //先注册响应后台控制
        UIApplication.shared.beginReceivingRemoteControlEvents()
        //处理中断事件的通知
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterreption(sender:)), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
        
        //设置并激活音频会话类别
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playback)
        try! session.setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
        
        //播放背景音乐
        if let url = Bundle.main.url(forResource: "ghsy.mp3", withExtension: nil) {
            // 创建播放器
            _player = try! AVAudioPlayer.init(contentsOf: url)
            _player.prepareToPlay()
            _player.volume = 0;
            _player.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
            _player.play()
        }
    }
    
    @objc func handleInterreption(sender: Notification) {
        if(_isPlayed){
            _player.pause()
            _isPlayed = false
        }else{
            _player.play()
            _isPlayed = true
        }
    }
    
    //实现一下backgroundPlayerID:这个方法:
    static func backgroundPlayerID(backTaskId: UIBackgroundTaskIdentifier?) -> UIBackgroundTaskIdentifier {
        //允许应用程序接收远程控制
        UIApplication.shared.beginReceivingRemoteControlEvents()
        //设置后台任务ID
        var newTaskId = UIBackgroundTaskIdentifier.invalid
        newTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        if(newTaskId != UIBackgroundTaskIdentifier.invalid && backTaskId != UIBackgroundTaskIdentifier.invalid) {
            if let backTaskId = backTaskId {
                UIApplication.shared.endBackgroundTask(backTaskId)
            } else {
                return newTaskId
            }
        }
        return newTaskId
    }
    
    func always_applicationWillResignActive(_ application: UIApplication) {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playback)
        try! session.setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
        //若需要持续播放网络歌曲，还需要申请后台任务id，具体做法是：
        //其中的_bgTaskId是后台任务UIBackgroundTaskIdentifier _bgTaskId;
        
        let bgTaskId = AppDelegate.backgroundPlayerID(backTaskId: _bgTaskId)
        _bgTaskId = bgTaskId
    }
}
