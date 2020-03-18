//
//  GATimeAddViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/14.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation
import Then

class GATimeAddViewController: GARxSwiftNavViewController {
    @IBOutlet weak var titleTextField: GANormalizeTextField!
    @IBOutlet weak var contentTextView: GANormalizeTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _request()
    }
    
    private func _initViews() {
        b_showNavigationView(title: "加一条")
        titleTextField.mDelegate = self
        contentTextView.mDelegate = self
    }
    
    private func _request() {
        
    }
}

extension GATimeAddViewController: GANormalizeTextFieldDelegate {
    
}

extension GATimeAddViewController: GANormalizeTextViewDelegate {
    
    func normalizeTextViewClickedReturn(textView: GANormalizeTextView) {
        print(textView)
    }
    
    func normalizeTextViewContentOffset(textView: GANormalizeTextView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 2, bottom: 0, right: 0)
    }
    
    func normalizeTextViewPlaceholdView(textView: GANormalizeTextView) -> UIView {
        let l = UILabel().then {
            $0.frame = CGRect(x: 0, y: textView.height / 2 - 15, width: 100, height: 15)
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 24)
            $0.textColor = kFont_2_9_LevelColor
            $0.text = "请输入描述的内容"
        }
        return l
    }
    
}

