
//
//  LXFNibloadable.swift
//  GARxSwift
//
//  Created by houjianan on 2020/3/11.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit

protocol GANibloadable {
    
}

extension GANibloadable {
    static func loadFromNib() -> Self {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as! Self
    }
}
