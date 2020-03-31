//
//  GAPlanAddBasicCell.swift
//  Need
//
//  Created by houjianan on 2020/3/23.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit

class GAPlanAddBasicCell: NeedCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: GAImageView!
    @IBOutlet weak var vipImageView: UIImageView!
    
    var model: GAPlanAddModel! {
        didSet {
            if model.people.count != 0 {
                titleLabel.text = model.people.joined(separator: Other.kStringSegmentationSymbols)
            } else {
                titleLabel.text = model.isEdited ? model.editText : model.title
            }
            iconImageView.iconName = model.icon
            vipImageView.isHidden = !model.isVip
            self.selectionStyle = model.isClicked ? .default : .none
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
