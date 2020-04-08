//
//  AppDelegate+FloatButton.swift
//  YYFramework
//
//  Created by houjianan on 2019/12/15.
//  Copyright © 2019 houjianan. All rights reserved.
//

import Foundation

extension AppDelegate {
    func _showFloatButton() {
        DispatchQueue.main.fw_after(0.5) {
            GAFloatWindow.initFloatWindow {
                
            }
        }
    }
}
