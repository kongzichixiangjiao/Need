//
//  View.swift
//  Need
//
//  Created by houjianan on 2020/4/6.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import RxSwift

class GARxTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
     
    //单元格重用时调用
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}

