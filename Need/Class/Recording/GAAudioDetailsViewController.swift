//
//  GAAudioDetailsViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/15.
//  Copyright © 2020 houjianan. All rights reserved.
//  语音播放

import UIKit
import RxSwift
import Then

class GAAudioDetailsViewController: GARecordingBaseViewController {
    
    var model: GARecordingModel!
    var publishModel: PublishSubject<GARecordingModel>?
    @IBOutlet weak var recognitionButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var slider: YYPlayerSlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var resultTextLabel: UILabel!
    private var _isEndTimer: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioType = .play
        _initViews()
        _request()
        
        _initPlayer()
        _playerButtonAction()
        _addTimer()
        _recognitionButtonAction()
        
    }
    
    private func _initViews() {
        b_showNavigationView(title: "播放/识别")
        slider.delegate = self
        
        resultTextLabel.text = model.resultText ?? ""
    }
    
    private func _request() {
        
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        player.stop()
    }
}

extension GAAudioDetailsViewController: YYPlayerSliderDelegate {
    func playerSliderBegan(progress: CGFloat) {
        _isEndTimer = true
    }
    
    func playerSliderChanged(progress: CGFloat) {
        
    }
    
    func playerSliderEnd(progress: CGFloat) {
        player.setSeek(progress: Float(progress))
        _isEndTimer = false
    }
}

extension GAAudioDetailsViewController {
    private func _addTimer() {
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.asyncInstance)
        timer.subscribe(onNext: {
            [weak self] timer in
            if let weakSelf = self {
                if weakSelf._isEndTimer {
                    return
                }
            }
            guard let total = self?.player.totalTime() else {
                return
            }
            self?.totalTimeLabel.text = String.ga_formate(time: Int(total))
            guard let current = self?.player.currentTime() else {
                return
            }
            self?.currentTimeLabel.text = String.ga_formate(time: Int(current))
            if total != 0 {
                let progress = CGFloat(current) / CGFloat(total)
                self?.slider.setupProgress(progress)
            }
        }).disposed(by: disposeBag)
    }
    
    private func _initPlayer() {
        let m = GAFilePathManager()
        let path = m.saveAudioPath(name: self.model.name ?? "")
        let url = URL(fileURLWithPath: path)
        
        self.player.playUrl = url
    }
    
    private func _playerButtonAction() {
        self.playButton.rx.tap.subscribe {
            [weak self] event in
            guard let weakSelf = self else {
                return
            }
//            if weakSelf.player.isPlaying {
//                weakSelf.player.pause()
//            } else {
                weakSelf.player.play()
            print("------------")
//            }
//            weakSelf.startSonic()
        }.disposed(by: disposeBag)
        
    }
    
    private func _recognitionButtonAction() {
        self.recognitionButton.rx.tap.subscribe {
            [weak self] event in
            guard let weakSelf = self else {
                return
            }
            let vc = weakSelf.ga_storyboardVC(type: GASpeechRecognitionViewController.self, storyboardName: RecordingStoryboard.name)
            vc.model = weakSelf.model
            weakSelf.ga_push(vc: vc)
        }.disposed(by: disposeBag)
        
    }
}
