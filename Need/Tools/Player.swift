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
    
    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }
    
    var playUrl: URL?
    
    lazy var player: AVAudioPlayer? = {
        do {
            guard let url = playUrl else {
                return nil
            }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            } catch {
                print(error)
            }
            try! AVAudioSession.sharedInstance().setActive(true)
            
            let player = try AVAudioPlayer.init(contentsOf: url)
            player.delegate = self
            player.prepareToPlay()
            return player
        }catch{
            print(error)
            return nil
        }
    }()
    
    lazy var streamlayer: FSAudioStream = {
        let config = FSStreamConfiguration()
        config.httpConnectionBufferSize *= 2
        config.enableTimeAndPitchConversion = true
        
        guard let s = FSAudioStream(configuration: config) else {
            return FSAudioStream()
        }
    
        s.onFailure = {
            error, message in
            print(error, message ?? "")
        }
        s.onCompletion = {
            print("播放完成")
            s.play()
        }
        s.onStateChange = {
            state in
            print(state)
        }
        s.volume = 0.5
        //设置播放速率
        s.setPlayRate(1.0)
        // 不进行检测格式 <开启检测之后，有些网络音频链接无法播放>
        s.strictContentTypeChecking = false
        s.defaultContentType = ("audio/" + kAudioType) as NSString
        return s
    }()
    
    lazy var audioController: FSAudioController = {
        let s = FSAudioController()
        s.delegate = self
        return s
    }()
    
    func play() {
        guard let url = playUrl else {
            print("ERROR ------ URL不能为nil")
            return
        }
        
//        if !(self.player?.isPlaying ?? false) {
//            print(self.player?.play())
//            print(self.player?.isPlaying)
//        }
        
//        streamlayer.play(from: URL(string: "http://q79yxbmtx.bkt.clouddn.com/1584363194818_tGBlb.mp3"))
        streamlayer.play(from: url)
        
//        audioController.url = url as NSURL
//        audioController.play()
    }
    
    func pause() {
//        if self.player?.isPlaying ?? false {
//            self.player?.pause()
//        }
        streamlayer.pause()
    }
    
    func stop() {
//        self.player?.stop()
        streamlayer.stop()
    }
    
    func updateMeters() {
        player?.updateMeters()
    }
    
    func averagePower(forChannel: Int) -> Float {
        return player?.peakPower(forChannel: forChannel) ?? 0.0
    }
    
    func totalTime() -> (FSStreamPosition, FSStreamPosition) {
        let cur = streamlayer.currentTimePlayed
        let end =  streamlayer.duration
        
        let currentTime = cur.minute * 60 + cur.second; //音频已加载播放时长
        let totalTime = end.minute * 60 + end.second //音频总时长
        print(currentTime, totalTime)
        return (cur, end)
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
