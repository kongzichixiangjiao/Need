//
//  GAShowWindowProtocol.swift
//  Need
//
//  Created by houjianan on 2020/4/9.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit

public protocol GAShowWindowProtocol {
    
}

extension GAShowWindowProtocol where Self: UIViewController {
    internal func b_showLoading(isAllScreen: Bool = false) {
        if isAllScreen {
            GAShowWindow.ga_showLoading()
        } else {
            let w: CGFloat = 90.0
            let h: CGFloat = 90.0
            let screenW: CGFloat =  UIScreen.main.bounds.width
            let screenH: CGFloat =  UIScreen.main.bounds.height
            GAShowWindow.ga_showLoading(windowFrame: CGRect(x: (screenW - w) / 2, y: (screenH - h) / 2, width: w, height: h))
        }
    }
    
    internal func b_hideLoading() {
        GAShowWindow.ga_hideLoading()
    }
    
}

extension GAShowWindowProtocol where Self: UIView {
    public func b_showLoadingAllScreen() {
        GAShowWindow.ga_showLoading()
    }
    
    public func b_hideLoading() {
        GAShowWindow.ga_hideLoading()
    }
}
