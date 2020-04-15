//
//  GAPickerViewProtocol.swift
//  Need
//
//  Created by houjianan on 2020/4/8.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation
import GAAlertPresentation

protocol GAPickerViewProtocol {
    
}

extension GAPickerViewProtocol where Self: UIViewController {
    func pickerNormalView_show(dataSource: [[String]], isMultipleChoice: Bool = false, resultData: [String] = [], confirmHandler: @escaping ([String]) -> ()) {
        let d = YYPresentationDelegate(animationType: .sheet, isShowMaskView: true, maskViewColor: "000000".color0X(0.6))
        let vc = GAPickerViewController(nibName: "GAPickerViewController", bundle: nil, delegate: d)
        vc.isMultipleChoice = isMultipleChoice
        vc.resultData = resultData
        vc.dataSource = dataSource
        vc.clickedHandler = {
            tag, model in
            if tag == 1 {
                confirmHandler(model as! [String])
            }
        }
        self.present(vc, animated: true, completion: nil)
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

