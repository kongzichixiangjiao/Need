//
//  GAListingSettingCell.swift
//  Need
//
//  Created by houjianan on 2020/3/22.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import SnapKit

class GAListingSettingCell: GACustomCellView {
    
    @IBInspectable var iconName: String = ""
    @IBInspectable var title: String = ""
    
    var iconImageView: UIImageView!
    var titleLabel: UILabel!
    var onePxView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImageView = UIImageView()
        iconImageView.image = UIImage(named: self.iconName)
        self.addSubview(iconImageView)
        
        titleLabel = UILabel()
        titleLabel.text = self.title
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(titleLabel)
        
        onePxView = UIView()
        onePxView.backgroundColor = kSeptalLine_1_LevelColor
        self.addSubview(onePxView)
        
        makeConstraints()
    }
    
    private func makeConstraints() {

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        onePxView.translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.centerY.equalTo(self.snp_centerYWithinMargins)
            make.width.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImageView.snp_rightMargin).offset(20)
            make.centerY.equalTo(self.snp_centerYWithinMargins)
        }
        
        onePxView.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel.snp_leftMargin).offset(0)
            make.bottom.right.equalTo(0)
            make.height.equalTo(1.0 / UIScreen.main.scale)
        }
    }

    
}
