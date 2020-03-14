//
//  Recording.swift
//  Need
//
//  Created by houjianan on 2020/3/14.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import AVFoundation

extension GAFilePathManager {
    public func saveAudioPath(name: String, typeString: String = "wav") -> String {
        let audioFile = filePath(name: Recording.kAudioFileName)
        let file = audioFile +  "/" + name + "." + typeString
        return file
    }
}

class Recording: NSObject {
    
    static let kAudioFileName: String = "录音保存文件"
    
    typealias FinishedHandler = (_ b: Bool, _ message: String) -> ()
    var finishedHandler: FinishedHandler?
    
    var isRecording: Bool {
        return audioRecord?.isRecording ?? false
    }
    lazy var player: AVAudioPlayer? = {
        do {
            let m = GAFilePathManager()
            let file = m.catchFilePath() + "demo.wav"
            guard let url = URL(string: file) else {
                return nil
            }
            let player = try AVAudioPlayer.init(contentsOf: url)
            player.prepareToPlay()
            return player
        }catch{
            print(error)
            return nil
        }
    }()
    
    func directoryURL() -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent("sound.caf")
        return soundURL
    }
    
    lazy var audioRecord: AVAudioRecorder? = {
        let m = GAFilePathManager()

        let file = m.catchFilePath() + "memo.caf"
        let url = URL(fileURLWithPath: file)
        
        let configDic: [String: AnyObject] = [
            // 编码格式
            AVFormatIDKey: NSNumber(value: Int32(kAudioFormatAppleIMA4)),
            // 采样率
            AVSampleRateKey: NSNumber(value: 11025.0),
            // 通道数
            AVNumberOfChannelsKey: NSNumber(value: 2),
            // 位深
            AVEncoderBitDepthHintKey: NSNumber(value: 6),
            // 录音质量
            AVEncoderAudioQualityKey: NSNumber(value: Int32(AVAudioQuality.min.rawValue))
        ]
        do {
            let recorder = try AVAudioRecorder(url: url, settings: configDic)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            // 准备录音(系统会给我们分配一些资源)
            recorder.prepareToRecord()
            print(recorder.record())
            print(recorder.stop())
            return recorder
        } catch {
            print(error)
            return nil
        }
    }()
    
    func prepare() {
        audioRecord?.prepareToRecord()
    }
    // 开始录音
    func start() {
        audioRecord?.record()
    }
    
    func pause() {
        audioRecord?.pause()
    }
    
    func stop(handler: @escaping FinishedHandler) {
        finishedHandler = handler
        audioRecord?.stop()
    }
    
    func play() {
        self.player?.play()
    }
    
    func save(fileName: String) -> Bool {
        let m = GAFilePathManager()
        let file = m.saveAudioPath(name: fileName)
        let to = URL(fileURLWithPath: file)

        guard let at = audioRecord?.url else {
            return false
        }
        if m.copy(at: at, to: to) {
            audioRecord?.prepareToRecord()
            return true
        }
        return false
    }
    
    func formattedCurrentTime() -> String {
        guard let time = self.audioRecord?.currentTime else { return "00:00:00" }
        let h = Int(time) / 3600
        let m = Int(time / 60) % 60
        let s = Int(time) % 60
        let timeString = String(format: "%.2d, %.2d, %.2d", h, m, s)
        
        return timeString
    }
    
}

extension Recording: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            finishedHandler?(flag, "录音成功")
        } else {
            finishedHandler?(flag, "录音失败")
        }
    }
    
    /* if an error occurs while encoding it will be reported to the delegate. */
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print(error ?? "")
    }

    
    /* AVAudioRecorder INTERRUPTION NOTIFICATIONS ARE DEPRECATED - Use AVAudioSession instead. */
    
    /* audioRecorderBeginInterruption: is called when the audio session has been interrupted while the recorder was recording. The recorded file will be closed. */
    func audioRecorderBeginInterruption(_ recorder: AVAudioRecorder) {
        
    }

    
    /* audioRecorderEndInterruption:withOptions: is called when the audio session interruption has ended and this recorder had been interrupted while recording. */
    /* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
    func audioRecorderEndInterruption(_ recorder: AVAudioRecorder, withOptions flags: Int) {
        
    }
}
