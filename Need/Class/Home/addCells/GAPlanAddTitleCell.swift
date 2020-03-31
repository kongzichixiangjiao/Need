//
//  GAPlanAddTitleCell.swift
//  Need
//
//  Created by houjianan on 2020/3/23.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import RxSwift

class GAPlanAddTitleCell: NeedCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var iconButton: UIButton!
    
    var publishModel = PublishSubject<String>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        publishModel.onNext(sender.text ?? "")
    }
}
