//
//  GAAlertProtocol.swift
//  Need
//
//  Created by houjianan on 2020/4/8.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation
import GAAlertPresentation

protocol GAAlertProtocol {
    
}

extension GAAlertProtocol where Self: UIViewController {
    func alertNormal_show(title: String, message: String, confirmHandler: @escaping (Bool) -> ()) {
        let d = YYPresentationDelegate(animationType: .alert, isShowMaskView: true, maskViewColor: "000000".color0X(0.6))
        let vc = GANormalViewController(nibName: "GANormalViewController", bundle: nil, delegate: d)
        vc.mTitle = title
        vc.message = message
        vc.clickedHandler = {
            tag, model in
            if tag == 1 {
                confirmHandler(true)
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
}

extension GAAlertProtocol where Self: UIViewController {
    func alertEdit_show(confirmHandler: @escaping (String) -> ()) {
        let d = YYPresentationDelegate(animationType: .alert, isShowMaskView: true, maskViewColor: "000000".color0X(0.6))
        let vc = GAEditAlertViewController(nibName: "GAEditAlertViewController", bundle: nil, delegate: d)
        vc.clickedHandler = {
            tag, model in
            guard let text = model as? String else {
                return
            }
            if tag == 1 && !text.isEmpty {
                confirmHandler(text)
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
}
