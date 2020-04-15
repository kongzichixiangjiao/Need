//
//  GAPickerDateViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/24.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import GAAlertPresentation

class GAPickerDateViewController: YYPresentationBaseViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dateModel: UIDatePicker.Mode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = dateModel

    }
    @IBAction func cancle(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func confirm(_ sender: Any) {
        dismiss()
        clickedHandler?(1, datePicker.date)
    }
}
