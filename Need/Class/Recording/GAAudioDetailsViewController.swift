//
//  GAAudioDetailsViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/15.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import RxSwift
import Then

class GAAudioDetailsViewController: GARecordingBaseViewController {
    
    var model: GARecordingModel!
    var publishModel: PublishSubject<GARecordingModel>?
    
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioType = .play
        _initViews()
        _request()
        
        //        publicModel?.on(<#T##event: Event<GARecordingModel>##Event<GARecordingModel>#>)
        
        _initPlayer()
        _playerButtonAction()
        
//        chatHUD = MCRecordHUD(type: hudType)
    }
    
    private func _initViews() {
        
    }
    
    private func _request() {
        
    }
}

extension GAAudioDetailsViewController {
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
//            weakSelf.startSonic()
        }.disposed(by: disposeBag)
    }
}
