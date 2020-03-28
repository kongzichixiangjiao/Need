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
import RxCocoa
import NSObject_Rx

class GAAudioDetailsViewController: GARecordingBaseViewController {
    
    var model: GARecordingModel!
    var publishModel: PublishSubject<GARecordingModel>?
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var slider: YYPlayerSlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var resultTextView: GANormalizeTextView!
    @IBOutlet weak var saveButton: GAIconButton!
    
    private var _isEndTimer: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioType = .play
        _initViews()
        _request()
        
        _initPlayer()
        _playerButtonAction()
        _addTimer()
        
    }
    
    private func _initViews() {
        b_showNavigationView(title: "播放/识别")
        
        let buttonTitle: String = (model.resultText?.isEmpty ?? true) ? "识别语音" : "重新识别"
        b_showNavigationRightButton(title: buttonTitle) {
            [unowned self] title in
            self.pushSpeechRecognition()
        }
        
        slider.delegate = self
        resultTextView.mDelegate = self
        resultTextView.text = model.resultText ?? ""
        
        saveButton.addEndAction {
            [unowned self] _, _ in
            if self.resultTextView.text == self.model.resultText {
                GAShowWindow.ga_show(message: "别乱点...")
            } else {
                GACoreData.ga_save_recordingModel(resultText: self.resultTextView.text, name: self.model.name)
            }
        }
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
        let timer = Observable<Int>.interval(0.5, scheduler: MainScheduler.asyncInstance)
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
            guard let current = self?.player.currentTime() else {
                return
            }
            self?.totalTimeLabel.text = String.ga_formate(time: Int(total))
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
            weakSelf.player.play()
            weakSelf.playButton.isSelected = !weakSelf.playButton.isSelected
        }.disposed(by: disposeBag)
        
    }
    private func pushSpeechRecognition() {
        let vc = self.ga_storyboardVC(type: GASpeechRecognitionViewController.self, storyboardName: RecordingStoryboard.name)
        vc.model = model
        ga_push(vc: vc)
    }
}

extension GAAudioDetailsViewController: GANormalizeTextViewDelegate {
    func normalizeTextViewClickedReturn(textView: GANormalizeTextView) {
        print(textView)
    }
    
    func normalizeTextViewContentOffset(textView: GANormalizeTextView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 2, bottom: 0, right: 0)
    }
    
    func normalizeTextViewPlaceholdView(textView: GANormalizeTextView) -> UIView {
        let v = UIButton().then {
            $0.frame = CGRect(x: 0, y: textView.height / 2 - 15, width: kScreenWidth, height: 15)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 24)
            $0.titleLabel?.textColor = kFont_2_9_LevelColor
            $0.setTitle("点击识别语音", for: .normal)
        }
        
        v.rx.tap.subscribe {
            [weak self] event in
            guard let weakSelf = self else {
                return
            }
            weakSelf.pushSpeechRecognition()
        }.disposed(by: disposeBag)
        return v
    }
}
