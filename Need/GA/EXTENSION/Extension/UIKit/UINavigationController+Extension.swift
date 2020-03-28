//
//  UINavigationController+Extension.swift
//  GAFramework
//
//  Created by houjianan on 2019/12/7.
//  Copyright © 2019 houjianan. All rights reserved.
//

import UIKit

public extension UINavigationController {
    func ga_isEnabledPop(_ b: Bool) {
        self.interactivePopGestureRecognizer?.isEnabled = b
    }
}
