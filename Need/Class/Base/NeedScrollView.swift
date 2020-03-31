//
//  NeedTableView.swift
//  Need
//
//  Created by houjianan on 2020/3/29.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit

class NeedTableView: UITableView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = Need.vcBgColor
    }
}
class NeedCollectionView: UICollectionView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = Need.vcBgColor
    }
}
