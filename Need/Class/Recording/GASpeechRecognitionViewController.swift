//
//  GASpeechrecognitionViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/17.
//  Copyright © 2020 houjianan. All rights reserved.
//  语音识别

import UIKit

enum GASpeechRecognitionFromType: Int {
    case audioDetails = 1, speech = 2
}

class GASpeechRecognitionViewController: GARecordingBaseViewController {
    
    @IBOutlet weak var speechButton: UIButton!
    @IBOutlet weak var textView: GANormalizeTextView!
    
    var model: GARecordingModel!
    var fromType: GASpeechRecognitionFromType = .audioDetails
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _speechButtonAction()
    }
    
    private func _initViews() {
        b_showNavigationView(title: "语音识别")
        textView.mDelegate = self
    }
    
    override func b_speechRecognition(text: String) {
        textView.text = text
    }
}

extension GASpeechRecognitionViewController {
    fileprivate func _speechButtonAction() {
        self.speechButton.rx.tap.subscribe {
            [unowned self] e in
            
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
            self.speechButton.isSelected = !self.speechButton.isSelected
        }.disposed(by: disposeBag)
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
            $0.frame = CGRect(x: 0, y: textView.height / 2 - 15, width: 100, height: 15)
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 24)
            $0.textColor = kFont_2_9_LevelColor
            $0.text = "录语音识别或者手动输入"
        }
        return l
    }
}
