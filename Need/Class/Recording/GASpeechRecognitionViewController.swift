//
//  GASpeechrecognitionViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/17.
//  Copyright © 2020 houjianan. All rights reserved.
//  语音识别

import UIKit
import SCLAlertView
import GAExtension

enum GASpeechRecognitionFromType: Int {
    case audioDetails = 1, speech = 2
}

class GASpeechRecognitionViewController: GARecordingBaseViewController {
    
    @IBOutlet weak var speechButton: GAIconButton!
    @IBOutlet weak var textView: GANormalizeTextView!
    
    var model: GARecordingModel!
    var fromType: GASpeechRecognitionFromType = .audioDetails
    
    var GAShowWindowFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _speechButtonAction()
        
        if fromType == .audioDetails {
            _sppechLocalAudio()
            
            GAShowWindowFrame = self.view.bounds.ga_yChangTo(b_navigationViewMaxY).ga_heightChang(-b_navigationViewMaxY)
            GAShowWindow.ga_showLoading(windowFrame: GAShowWindowFrame)
            
            self.speechButton.ga_changeIsSelected(!self.speechButton.isSelected)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        GAShowWindow.ga_hideLoading()
    }
    
    private func _initViews() {
        b_showNavigationView(title: "语音识别")
        textView.mDelegate = self
        if fromType == .audioDetails {
            speechButton.normalTitle = "重新识别"
            speechButton.selectedTitle = "正在识别..."
        }
    }
    
    override func b_speechRecognition(text: String) {
        GAShowWindow.ga_show(windowFrame: GAShowWindowFrame, message: text, isHideBefore: true)
        textView.text = text
    }
    
    override func b_speechRecognizer(available: Bool) {
        GAShowWindow.ga_hideAll()
        
        self.speechButton.ga_changeIsSelected(!self.speechButton.isSelected)
        
        let appearance = SCLAlertView.SCLAppearance(
            kWindowWidth: kScreenWidth - 40, showCloseButton: false, circleBackgroundColor: UIColor.white
        )
        
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("确定", backgroundColor: kMainButtonDefaultColor) {
            GACoreData.ga_save_recordingModel(resultText: self.textView.text, name: self.model.name)
        }
        alert.addButton("取消", backgroundColor: kMainButtonDefaultColor) {
            
        }
        
        alert.showInfo("保存", subTitle: "是否保存识别结果？")
    }
}

extension GASpeechRecognitionViewController {
    fileprivate func _speechButtonAction() {
        speechButton.addEndAction {
            [unowned self] _, _ in
            if !self.isAllowed {
                self.requestRecordPermission()
                return
            }

            if self.fromType == .audioDetails {
                self._sppechLocalAudio()
            } else {
                if self.speechButton.isSelected   {
                    self.speech.stop()
                } else {
                    self.speech.start()
                }
            }
            self.speechButton.ga_changeIsSelected(!self.speechButton.isSelected)
        }
    }
    
    private func _sppechLocalAudio() {
        let m = GAFilePathManager()
        let path = m.saveAudioPath(name: self.model.name ?? "")
        let url = URL(fileURLWithPath: path)
        self.speech.startUrlRecording(url: url)
    }
}

extension GASpeechRecognitionViewController: GANormalizeTextViewDelegate {
    func normalizeTextViewClickedReturn(textView: GANormalizeTextView) {
        print(textView)
    }
    
    func normalizeTextViewContentOffset(textView: GANormalizeTextView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 2, bottom: 0, right: 0)
    }
    
    func normalizeTextViewPlaceholdView(textView: GANormalizeTextView) -> UIView {
        let l = UILabel().then {
            $0.frame = CGRect(x: 0, y: textView.height / 2 - 15, width: kScreenWidth, height: 15)
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 24)
            $0.textColor = kFont_2_9_LevelColor
            if fromType != .audioDetails {
                $0.text = "录语音识别或者手动输入"
            }
        }
        return l
    }
}

