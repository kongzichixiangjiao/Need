//
//  Player.swift
//  Need
//
//  Created by houjianan on 2020/3/15.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import AVFoundation

class Player: NSObject {
    
    typealias FinishedHandler = (_ b: Bool, _ message: String) -> ()
    var finishedHandler: FinishedHandler?
    
    var isPause: Bool = false
    
    var isPlaying: Bool {
        return audioController.isPlaying()
    }
    
    var playUrl: URL? {
        didSet {
            audioController.url = playUrl! as NSURL
        }
    }
    
    lazy var audioController: FSAudioController = {
        let s = FSAudioController()
        s.delegate = self
        return s
    }()
    
    func play() {
        if audioController.isPlaying() {
            pause()
        } else {
            if isPause {
                audioController.pause()
                isPause = false
            } else {
                audioController.play()
            }
        }
    }
    
    
    func pause() {
        audioController.pause()
        isPause = true
    }
    
    func rePlay() {
        audioController.play()
    }
    
    func stop() {
        audioController.stop()
    }

    func totalTime() -> Int {
        if audioController.activeStream == nil {
            return 0
        }
        let total = audioController.activeStream.duration
        let totalTime = total.minute * 60 + total.second //音频总时长
        print("totalTime", totalTime)
        return Int(totalTime)
    }
    
    func currentTime() -> Int {
        if audioController.activeStream == nil {
            return 0
        }
        let cur = audioController.activeStream.currentTimePlayed
        let currentTime = cur.minute * 60 + cur.second; //音频已加载播放时长
        print("currentTime", currentTime)
        return Int(currentTime)
    }
    
    func progress() -> CGFloat {
        if totalTime() == 0 {
            return 0.0
        }
        
        return CGFloat(currentTime()) / CGFloat(totalTime())
    }
    
    func setSeek(progress: Float) {
        if audioController.activeStream == nil {
            return
        }
        let currentTime = Int(Float(totalTime()) * progress)
        let m = currentTime / 60
        let s = currentTime % 60
        print(m)
        print(s)
        var p = FSStreamPosition(minute: UInt32(m), second: UInt32(s), playbackTimeInSeconds: 0, position: progress)
        p.position = progress
        audioController.activeStream.seek(to: p)

    }
}

extension Player: FSAudioControllerDelegate {
    func audioController(_ audioController: FSAudioController!, preloadStartedFor stream: FSAudioStream!) {
        
    }
    
    func audioController(_ audioController: FSAudioController!, allowPreloadingFor stream: FSAudioStream!) -> Bool {
        
        return true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
}

extension Player: AVAudioPlayerDelegate {
    
}
