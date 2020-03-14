//
//  GARecordingAddViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/14.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import SwiftDate
import RxSwift

class GARecordingAddViewController: GARxSwiftNavViewController, GARecordingProtocol {
    var isAllowed: Bool = false 
    
    @IBOutlet weak var speechButton: UIButton!
    @IBOutlet weak var textView: GANormalizeTextView!
    @IBOutlet weak var recordingButton: UIButton!
    
    lazy var speech: GASpeech = {
        let s = GASpeech()
        s.delegate = self
        return s
    }()
    
    lazy var recording: Recording = {
        let r = Recording()
        return r
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _addTimer()
        requestRecordPermission()
        
        _speechButtonAction()
        _recordingButtonAction()
    }
    
    private func _initViews() {
        b_showNavigationView(title: "增加一段录音记录")
        textView.mDelegate = self
    }
    
    private func _addTimer() {
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.asyncInstance)
        timer.subscribe(onNext: {
            [weak self] time in
            if self?.recording.isRecording ?? false {
                print(self?.recording.formattedCurrentTime() ?? "")
            }
        }).disposed(by: disposeBag)
    }
    
    deinit {
        print("---")
    }
}

extension GARecordingAddViewController {
    fileprivate func _speechButtonAction() {
        
        self.speechButton.rx.tap.subscribe {
            [unowned self] e in
            if !self.isAllowed {
                self.requestRecordPermission()
                return
            }
            if self.speechButton.isSelected   {
                self.speech.stop()
            } else {
                self.speech.start()
            }
            self.speechButton.isSelected = !self.speechButton.isSelected
        }.disposed(by: disposeBag)
    }
    
    fileprivate func _recordingButtonAction() {
        self.recordingButton.rx.tap.subscribe {
            [unowned self] e in
            if !self.isAllowed {
                self.requestRecordPermission()
                return
            }
            if self.recordingButton.isSelected   {
                self.recording.stop {
                    [unowned self] b, message in
                    if b {
                        if self.recording.save(fileName:self._fileName()) {
                            GAShowWindow.ga_show(message: "保存成功")
                        } else {
                            GAShowWindow.ga_show(message: "保存失败")
                        }
                    } else {
                        GAShowWindow.ga_show(message: message)
                    }
                }
            } else {
                self.recording.start()
            }
            self.recordingButton.isSelected = !self.recordingButton.isSelected
        }.disposed(by: disposeBag)
    }
    
    fileprivate func _fileName() -> String {
        return Date().ga_milliStamp + "_" + String.ga_random(5, true)
    }
}

extension GARecordingAddViewController: GASpeechDelegate {
    
    func ga_speechRecognizer(available: Bool) {
        
    }
    
    func ga_speechRecognition(text: String) {
        textView.text = text 
    }
    
}
extension GARecordingAddViewController: GANormalizeTextViewDelegate {
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


protocol GARecordingProtocol {
    var isAllowed: Bool { set get }
    
}

import AVFoundation

extension GARecordingProtocol where Self: UIViewController {
    func requestRecordPermission() {
        //首先要判断是否允许访问麦克风
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] (allowed) in
            if !allowed{
                let alert = UIAlertController(title: "无法访问您的麦克风",
                                              message: "请到设置 -> 隐私 -> 麦克风 ，打开访问权限",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "好的", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                self?.isAllowed = false
            }else{
                self?.isAllowed = true
            }
        }
    }
}
