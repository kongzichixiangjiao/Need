//
//  GARecordingBaseViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/15.
//  Copyright © 2020 houjianan. All rights reserved.
//  录音、语音播放、语音识别的基类

import Foundation
import RxSwift

enum GAAudioType: Int {
    case play = 0, recording = 1
}

class GARecordingBaseViewController: GARxSwiftNavViewController, GARecordingProtocol {
    
    var isAllowed: Bool = false
    
    // MARK: 录音声波
    var audioType: GAAudioType = .play
    // MARK: 录音音波
    // 录音框
    var chatHUD: MCRecordHUD!
    // HUD类型
    var hudType: HUDType = .bar
    // 波形更新间隔
    let updateFequency = 0.05
    // 声音数据数组
    var soundMeters: [Float] = []
    // 声音数据数组容量
    let soundMeterCount = Int(VolumeViewWidth / 6) // = 33
    // 录音时间
    var recordTime = 0.00
    
    @objc func updateMeters() {
        if audioType == .play {
        } else {
            recording.updateMeters()
            addSoundMeter(item: recording.averagePower(forChannel: 0))
        }
        recordTime += updateFequency

//        // MARK: TODO
//        if recordTime >= 60.0 {
//            endRecordVoice()
//        }
    }
    
    func addSoundMeter(item: Float) {
        if soundMeters.count < soundMeterCount {
            soundMeters.append(item)
        } else {
            for (index, _) in soundMeters.enumerated() {
                if index < soundMeterCount - 1 {
                    soundMeters[index] = soundMeters[index + 1]
                }
            }
            // 插入新数据
            soundMeters[soundMeterCount - 1] = item
            
            chatHUD.updateView(soundMeters: soundMeters)
        }
    }
    
    func endRecordVoice() -> Double {
        recording.stop { (b, s) in
            
        }
        
        chatHUD.stopCounting()
        soundMeters.removeAll()
        
        return recordTime
    }
    
    func startSonic() {
        self.chatHUD.isHidden = false
        self.chatHUD.startCounting()
        soundMeters = Array(repeating: -120.0, count: 34)
        
        let timer = Observable<Int>.interval(self.updateFequency, scheduler: MainScheduler.asyncInstance)
        timer.subscribe(onNext: {
            [weak self] timer in
            if let weakSelf = self {
                if weakSelf.recording.isRecording {
                    weakSelf.updateMeters()
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func stopSonic() -> Double  {
        self.chatHUD.isHidden = true
        self.chatHUD.stopCounting()
        self.soundMeters.removeAll()
        
        return recordTime
    }
    
    // MARK: 语音识别
    lazy var speech: GASpeech = {
        let s = GASpeech()
        s.delegate = self
        return s
    }()
    
    // MARK: 录音
    lazy var recording: Recording = {
        let r = Recording()
        return r
    }()
    
    lazy var player: Player = {
        let p = Player()
        return p
    }()
    
    func b_speechRecognition(text: String) {
        
    }
    
    func b_speechRecognizer(available: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestRecordPermission()
        
        _initChatHUD()
    }
    
    private func _initChatHUD() {
        chatHUD = MCRecordHUD(type: hudType)
        chatHUD.isHidden = true
        self.view.addSubview(chatHUD)
    }
    
    deinit {
        print("base deinit")
    }
}

extension GARecordingBaseViewController: GASpeechDelegate {
    
    func ga_speechRecognizer(available: Bool) {
        b_speechRecognizer(available: available)
    }
    
    func ga_speechRecognition(text: String) {
        b_speechRecognition(text: text)
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
