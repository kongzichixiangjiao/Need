//
//  GANormalViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/28.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import GAAlertPresentation

class GANormalViewController: YYPresentationBaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var describeLabel: UILabel!
    
    var mTitle: String = "标题"
    var message: String = "一段深情的描述"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isTapBack = false
        
        titleLabel.text = mTitle
        describeLabel.text = message
        
    }
    
    @IBAction func cancle(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func confirm(_ sender: Any) {
        dismiss()
        clickedHandler?(1, true)
    }
}
