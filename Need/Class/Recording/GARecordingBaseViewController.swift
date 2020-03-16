//
//  GARecordingBaseViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/15.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation

enum GAAudioType: Int {
    case play = 0, recording = 1
}

class GARecordingBaseViewController: GARxSwiftNavViewController {
    // MARK:
    var audioType: GAAudioType = .play
    // MARK: 录音音波
    // 录音框
    var chatHUD: MCRecordHUD!
    // HUD类型
    var hudType: HUDType = .bar
    // 录音计时器
    var timer: Timer?
    // 波形更新间隔
    let updateFequency = 0.05
    // 声音数据数组
    var soundMeters: [Float] = []
    // 声音数据数组容量
    let soundMeterCount = Int(VolumeViewWidth / 6)
    // 录音时间
    var recordTime = 0.00
    
    @objc func updateMeters() {
        if audioType == .play {
            player.updateMeters()
            addSoundMeter(item: player.averagePower(forChannel: 0))
        } else {
            recording.updateMeters()
            addSoundMeter(item: recording.averagePower(forChannel: 0))
        }
        recordTime += updateFequency

        // MARK: TODO
        if recordTime >= 60.0 {
            endRecordVoice()
        }
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
        print(soundMeters)
    }
    
    func endRecordVoice() {
        recording.stop { (b, s) in
            
        }
        
        timer?.invalidate()
        chatHUD.removeFromSuperview()
//        view.isUserInteractionEnabled = true  //录音完了才能点击其他地方
        chatHUD.stopCounting()
        soundMeters.removeAll()
    }
    
    func startSonic() {
        self.view.addSubview(self.chatHUD)
//        self.view.isUserInteractionEnabled = false  //录音时候禁止点击其他地方
        self.chatHUD.startCounting()
        self.soundMeters = [Float]()
        self.timer = Timer.scheduledTimer(timeInterval: self.updateFequency, target: self, selector: #selector(self.updateMeters), userInfo: nil, repeats: true)
    }
    
    func stopSonic() {
        self.timer?.invalidate()
        self.chatHUD.removeFromSuperview()
//        self.view.isUserInteractionEnabled = true  //录音完了才能点击其他地方
        self.chatHUD.stopCounting()
        self.soundMeters.removeAll()
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("base deinit")
        timer?.invalidate()
    }
}

extension GARecordingBaseViewController: GASpeechDelegate {
    
    func ga_speechRecognizer(available: Bool) {
        
    }
    
    func ga_speechRecognition(text: String) {
        b_speechRecognition(text: text)
    }
}
