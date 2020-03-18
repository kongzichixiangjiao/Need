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
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var recognitionButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioType = .play
        _initViews()
        _request()
        
//        publicModel?.on(<#T##event: Event<GARecordingModel>##Event<GARecordingModel>#>)
        
        _initPlayer()
        _playerButtonAction()
    }
    
    private func _initViews() {
        b_showNavigationView(title: "录音")
    }
    
    private func _request() {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        player.stop()
    }
}

extension GAAudioDetailsViewController {
    private func _addTimer() {
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.asyncInstance)
        timer.subscribe(onNext: {
            [weak self] timer in
            let time = self?.player.totalTime()
            self?.totalLabel.text = String(time?.0.minute ?? 0) + ":" + String(time?.0.second ?? 0)
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
            weakSelf.player.play()
            weakSelf.startSonic()
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
