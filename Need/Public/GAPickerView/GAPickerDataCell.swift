//
//  GAPickerDataCell.swift
//  YYFramework
//
//  Created by houjianan on 2020/1/10.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit

class GAPickerDataCell: UITableViewCell {
    
    @IBOutlet weak var l: UILabel!
    
//    var isMultipleChoice: Bool = false {
//        didSet {
//            selectedImageView.isHidden = !isMultipleChoice
//        }
//    }
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
