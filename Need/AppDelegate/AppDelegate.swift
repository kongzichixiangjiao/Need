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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    var paws: MonkeyPaws?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(NSHomeDirectory())
        mrCoreData_init()
        
        // monkey()
        
        return true
    }
    
    func monkey() {
        paws = MonkeyPaws(view: window!)
    }
}

extension AppDelegate {
    
}
