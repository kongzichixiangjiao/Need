//
//  GAPlanAddNoteCell.swift
//  Need
//
//  Created by houjianan on 2020/3/23.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import RxSwift

class GAPlanAddNoteCell: NeedCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    var publishModel = PublishSubject<GAPlanAddModel>()
    var publishNoteString = PublishSubject<String>()
    
    var model: GAPlanAddModel! {
        didSet {
            for i in 0..<stackView.arrangedSubviews.count {
                let v = stackView.arrangedSubviews[i]
                let b = v as! UIButton
                b.tag = i
                let name = model.buttonIcons[i]
                b.setImage(UIImage(named: name), for: .normal)
                b.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
            }
            textField.text = model.editText
        }
    }
    
    @objc func action(sender: UIButton) {
        model.selectedIcon = model.buttonIcons[sender.tag]
        publishModel.onNext(model)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        publishNoteString.onNext(sender.text ?? "")
    }
       
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
