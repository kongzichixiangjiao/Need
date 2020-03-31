//
//  NeedOnePixView.swift
//  Need
//
//  Created by houjianan on 2020/3/29.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit

class NeedOnePixView: YYOnePixView {
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.backgroundColor = Need.segmentationLineColor
    }
}
