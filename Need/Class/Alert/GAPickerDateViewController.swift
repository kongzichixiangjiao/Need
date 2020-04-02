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

extension GAPickerViewProtocol where Self: UIViewController {
    
    func pickerDateView_show(dateModel: UIDatePicker.Mode = .date, confirmHandler: @escaping (Date) -> ()) {
        let d = YYPresentationDelegate(animationType: .sheet, isShowMaskView: true, maskViewColor: "000000".color0X(0.6))
        let vc = GAPickerDateViewController(nibName: "GAPickerDateViewController", bundle: nil, delegate: d)
        vc.dateModel = dateModel
        vc.clickedHandler = {
            tag, model in
            if tag == 1 {
                confirmHandler(model as! Date)
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
}
