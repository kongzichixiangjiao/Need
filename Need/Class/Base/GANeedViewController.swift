//
//  GANeedViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/29.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation
import RxSwift

class NeedViewController: GAViewController {
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Need.vcBgColor
    }
}

class NeedNavViewController: GANavViewController {
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Need.vcBgColor
        self.b_navigationView.backgroundColor = Need.navBgColor
        self.b_navigationView.titleLable.textColor = Need.title1Color
        self.b_navigationView.rightButton.setTitleColor(Need.title1Color, for: UIControl.State.normal)
        self.b_navigationView.leftButton.setTitleColor(Need.title1Color, for: UIControl.State.normal)
    }
}
