//
//  GARxSwiftViewController.swift
//  YYFramework
//
//  Created by houjianan on 2020/2/27.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation
import RxSwift

#if os(iOS)
    import UIKit
    typealias OSViewController = GANavViewController
#elseif os(macOS)
    import Cocoa
    typealias OSViewController = NSViewController
#endif

class GARxSwiftViewController: OSViewController {
    var disposeBag = DisposeBag()
}

class GARxSwiftNavViewController: GANavViewController {
    var disposeBag = DisposeBag()
}
