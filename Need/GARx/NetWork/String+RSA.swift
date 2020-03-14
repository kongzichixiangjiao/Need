//
//  String + RSA.swift
//  GARxSwift
//
//  Created by houjianan on 2020/3/8.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation
import SwiftyRSA

// MARK: rsa 加密
public func rsa_pem(message: String) -> String {
    let publicKey = try! PublicKey(pemNamed: "rsa_public_key")
    let clear = try! ClearMessage(string: message, using: .utf8)
    let encrypted = try! clear.encrypted(with: publicKey, padding: .PKCS1)
    
    let _ = encrypted.data
    let base64String = encrypted.base64String
    
    return base64String
}
//Multiple commands produce '/Users/houjianan/Library/Developer/Xcode/DerivedData/Need-gowjdprgggfnmqgieapyjyecyfaw/Build/Products/Debug-iphonesimulator/Need.app/YYBaseXibTabBarView.nib':
//1) Target 'Need' (project 'Need') has compile command with input '/Users/houjianan/Documents/GitHub/iOS/Need/Need/GA/Base/view/YYTabBar/YYBaseXibTabBarView.xib'
//2) Target 'Need' (project 'Need') has compile command with input '/Users/houjianan/Documents/GitHub/iOS/Need/Need/GA/BaseView/TabbarView/YYTabBar/YYBaseXibTabBarView.xib'
