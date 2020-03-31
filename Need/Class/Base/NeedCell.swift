//
//  NeedCell.swift
//  Need
//
//  Created by houjianan on 2020/3/29.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit

class NeedCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = Need.cellBgColor
    }
}

class NeedCollectionCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = Need.cellBgColor
    }
}
