//
//  GAEditAlertViewController.swift
//  Need
//
//  Created by houjianan on 2020/4/15.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import GAAlertPresentation

class GAEditAlertViewController: YYPresentationBaseViewController {
    @IBOutlet weak var textField: GANormalizeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func confirm(_ sender: UIButton) {
        clickedHandler?(1, textField.text ?? "")
        dismiss()
    }
    
}
