//
//  GATimeAddViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/14.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation
import Then

class GATimeAddViewController: GARecordingBaseViewController, GAPickerViewProtocol {
    
    @IBOutlet weak var titleTextField: GANormalizeTextField!
    @IBOutlet weak var contentTextView: GANormalizeTextView!
    @IBOutlet weak var pickerBgView: UIView!
    
    lazy var microphoneView: GAMicrophoneKeyboardView = {
        let v = GAMicrophoneKeyboardView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 50))
        self.view.addSubview(v)

        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _request()
    }
    
    private func _initViews() {
        b_showNavigationView(title: "加一条")
        titleTextField.mDelegate = self
        contentTextView.mDelegate = self
        
//        var arrH = [String]()
//        var arrM = [String]()
//        for i in 0...60 {
//            if i <= 36 {
//                arrH.append(i.toString())
//            }
//            arrM.append(i.toString())
//        }
//
//        pickerNormalView_show(dataSource: [arrH, ["小时"], arrM, ["分钟"]]) { (result) in
//            print(result)
//        }
        

        microphoneView.observer(beginTapHandler: {
            self.speech.start()
            self.onceString = self.contentTextView.text
        }, endTapHandler: {
            self.speech.stop()
            self.contentTextView.text = self.onceString + self.newString
        }) { (h) in
            print(h)
        }
    }
    
    private func _request() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    var onceString: String = ""
    var newString: String = ""
    override func b_speechRecognition(text: String) {
        self.contentTextView.text = self.onceString + text
        newString = text
        microphoneView.setupContent(s: text)
    }
    
    deinit {
        print("12312")
        microphoneView.removeObserver()
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

//protocol GAPickerViewProtocol {
//    var kPickerViewHeight: CGFloat { get } // 40.0 * 5
//    var topView: UIView { get }
//}
//
//extension GAPickerViewProtocol where Self: UIViewController {
//    func pickerView_init(dataSource:  [[String]]) {
//        guard let pickerView = self.view.viewWithTag(20200318) else {
//            let v = GAPickerView(frame: CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: kPickerViewHeight), dataSource: dataSource, configModel: nil)
//            v.tag = 20200318
//            self.view.addSubview(v)
//            return
//        }
//        self.view.addSubview(pickerView)
//    }
//
//    func pickerView_show() {
//        let pickerView = self.view.viewWithTag(20200318)
//
//        UIView.animate(withDuration: 0.25) {
//            pickerView?.frame = CGRect(x: 0, y: self.view.frame.size.height - self.kPickerViewHeight - safeBottomHeight(), width: self.view.frame.size.width, height: self.kPickerViewHeight)
//        }
//
//        func safeBottomHeight() -> CGFloat {
//            if #available(iOS 11.0, *) {
//                guard let safeAreaInsets = UIApplication.shared.delegate?.window??.safeAreaInsets else {
//                    return 0
//                }
//                return safeAreaInsets.bottom
//            } else {
//                return 0
//            }
//        }
//    }
//
//    func pickerView_show(topView: UIView) {
//        guard let pickerView = self.view.viewWithTag(20200318) else {
//            return
//        }
//
//        UIView.animate(withDuration: 0.25) {
//            pickerView.frame = CGRect(x: 0, y: self.view.frame.size.height - self.kPickerViewHeight - safeBottomHeight(), width: self.view.frame.size.width, height: self.kPickerViewHeight)
//            topView.frame =  CGRect(x: 0, y: pickerView.y - topView.height, width: pickerView.width, height: topView.height)
//        }
//
//        func safeBottomHeight() -> CGFloat {
//            if #available(iOS 11.0, *) {
//                guard let safeAreaInsets = UIApplication.shared.delegate?.window??.safeAreaInsets else {
//                    return 0
//                }
//                return safeAreaInsets.bottom
//            } else {
//                return 0
//            }
//        }
//    }
//
//    func pickerView_hide() {
//        let pickerView = self.view.viewWithTag(20200318)
//        UIView.animate(withDuration: 0.25) {
//            pickerView?.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: self.kPickerViewHeight)
//        }
//    }
//
//    func pickerView_resultData() -> [String] {
//        let pickerView = self.view.viewWithTag(20200318) as! GAPickerView
//        return pickerView.resultData
//    }
//}

