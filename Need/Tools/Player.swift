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
        let s = FSAudioStream()
        s.onFailure = {
            error, message in
            print(error, message)
        }
        s.onCompletion = {
            s.volume = 0.5
        }
        // 不进行检测格式 <开启检测之后，有些网络音频链接无法播放>
//        s.strictContentTypeChecking = false
//        s.defaultContentType = ("audio/" + kAudioType) as NSString
        return s
    }()
    
    lazy var controllerPlayer: FSAudioController = {
        let s = FSAudioController()
        s.delegate = self
        return s
    }()
    
    func play() {
        guard let url = playUrl else {
            print("ERROR ------ URL不能为nil")
            return
        }
        print(url)
//        /var/mobile/Containers/Data/Application/D2FAEB2B-8B38-4E10-BD0F-5968A1F54204/Documents/audio_yy/1584326314295_ftGTd.mp3
//        /var/mobile/Containers/Data/Application/D2FAEB2B-8B38-4E10-BD0F-5968A1F54204/Documents/audio_yy/1584326314295_ftGTd.mp3
//        if !(self.player?.isPlaying ?? false) {
//            print(self.player?.play())
//            print(self.player?.isPlaying)
//        }
        
//        streamlayer.play(from: url)
        let url1 = Bundle.main.url(forResource: "ghsy", withExtension: "mp3")
        controllerPlayer.url = url as NSURL
        controllerPlayer.play()

    }
    
    func pause() {
        if self.player?.isPlaying ?? false {
            self.player?.pause()
        }
    }
    
    func stop() {
        self.player?.stop()
    }
    
    func updateMeters() {
        player?.updateMeters()
    }
    
    func averagePower(forChannel: Int) -> Float {
        return player?.peakPower(forChannel: forChannel) ?? 0.0
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
