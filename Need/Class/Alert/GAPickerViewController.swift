//
//  GAPickerViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/19.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import GAAlertPresentation

class GAPickerViewController: YYPresentationBaseViewController {

    @IBOutlet weak var bgViewBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    
    var dataSource: [[String]] = []
    var kPickerViewHeight: CGFloat = 40 * 5
    var isMultipleChoice: Bool = false
    var resultData: [String] = []
    
    let topViewHeight: CGFloat = 35
    
    lazy var pickerView: GAPickerView = {
        let v = GAPickerView(frame: CGRect(x: 0, y: self.topViewHeight, width: kScreenWidth, height: kPickerViewHeight), dataSource: self.dataSource, isMultipleChoice: self.isMultipleChoice, resultData: self.resultData, configModel: nil)
        v.tag = 20200318
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        show(dataSource: dataSource)
        isTapBack = true 
    }

    @IBAction func confirmA(_ sender: Any) {
        clickedHandler?(1, pickerView.resultData)
        dismiss()
    }
    
    func show(dataSource: [[String]]) {
        self.dataSource = dataSource
        self.bgView.addSubview(pickerView)
        self.bgViewBottomSpace.constant = 0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hide() {
        self.bgViewBottomSpace.constant = -300
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    func safeBottomHeight() -> CGFloat {
        if #available(iOS 11.0, *) {
            guard let safeAreaInsets = UIApplication.shared.delegate?.window??.safeAreaInsets else {
                return 0
            }
            return safeAreaInsets.bottom
        } else {
            return 0
        }
    }
}
