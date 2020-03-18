//
//  Recording.swift
//  Need
//
//  Created by houjianan on 2020/3/14.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import AVFoundation
enum audioTyp: String {
    case kAudioFormatLinearPCM               = "lpcm",
    kAudioFormatAC3                     = "ac-3",
    kAudioFormat60958AC3                = "cac3",
    kAudioFormatAppleIMA4               = "ima4",
    kAudioFormatMPEG4AAC                = "aac ",
    kAudioFormatMPEG4CELP               = "celp",
    kAudioFormatMPEG4HVXC               = "hvxc",
    kAudioFormatMPEG4TwinVQ             = "twvq",
    kAudioFormatMACE3                   = "MAC3",
    kAudioFormatMACE6                   = "MAC6",
    kAudioFormatULaw                    = "ulaw",
    kAudioFormatALaw                    = "alaw",
    kAudioFormatQDesign                 = "QDMC",
    kAudioFormatQDesign2                = "QDM2",
    kAudioFormatQUALCOMM                = "Qclp",
    kAudioFormatMPEGLayer1              = ".mp1",
    kAudioFormatMPEGLayer2              = ".mp2",
    kAudioFormatMPEGLayer3              = ".mp3",
    kAudioFormatTimeCode                = "time",
    kAudioFormatMIDIStream              = "midi",
    kAudioFormatParameterValueStream    = "apvs",
    kAudioFormatAppleLossless           = "alac",
    kAudioFormatMPEG4AAC_HE             = "aach",
    kAudioFormatMPEG4AAC_LD             = "aacl",
    kAudioFormatMPEG4AAC_ELD            = "aace",
    kAudioFormatMPEG4AAC_ELD_SBR        = "aacf",
    kAudioFormatMPEG4AAC_ELD_V2         = "aacg",
    kAudioFormatMPEG4AAC_HE_V2          = "aacp",
    kAudioFormatMPEG4AAC_Spatial        = "aacs",
    kAudioFormatAMR                     = "samr",
    kAudioFormatAMR_WB                  = "sawb",
    kAudioFormatAudible                 = "AUDB",
    kAudioFormatiLBC                    = "ilbc",
    kAudioFormatDVIIntelIMA             = "0x6D730011",
    kAudioFormatMicrosoftGSM            = "0x6D730031",
    kAudioFormatAES3                    = "aes3",
    kAudioFormatEnhancedAC3             = "ec-3"
}

let kAudioType: String = "mp3"

extension GAFilePathManager {
    public func saveAudioPath(name: String) -> String {
        let audioFile = filePath(name: Recording.kAudioFileName)
        let file = audioFile +  "/" + name + "." + kAudioType
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
    
    func directoryURL() -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent("sound" + kAudioType)
        return soundURL
    }
    
    lazy var audioRecord: AVAudioRecorder? = {
        let m = GAFilePathManager()

        let file = m.catchFilePath() + "memo" + kAudioType
        let  url = URL(fileURLWithPath: file)
        
        let configDic: [String: AnyObject] = [
            // 编码格式
            AVFormatIDKey: NSNumber(value: Int32(kAudioFormatMPEG4AAC)),
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
            recorder.peakPower(forChannel: 0) // 最大音量
            // 准备录音(系统会给我们分配一些资源)
            recorder.prepareToRecord()
            recorder.record()
            recorder.pause()
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
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
        } catch {
            print(error)
        }
        
        audioRecord?.record()
    }
    
    func pause() {
        audioRecord?.pause()
    }
    
    func stop(handler: @escaping FinishedHandler) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
        } catch {
            print(error)
        }
        finishedHandler = handler
        audioRecord?.stop()
    }
    
    func updateMeters() {
        audioRecord?.updateMeters()
    }
    
    func averagePower(forChannel: Int) -> Float {
        return audioRecord?.averagePower(forChannel: 0) ?? 0.0
    }
    
    func save(fileName: String) -> (String, String) {
        let m = GAFilePathManager()
        let file = m.saveAudioPath(name: fileName)
        let to = URL(fileURLWithPath: file)

        guard let at = audioRecord?.url else {
            return ("", "")
        }
        if m.copy(at: at, to: to) {
            audioRecord?.prepareToRecord()
            return (file, fileName)
        }
        return ("", "")
    }
    
    func formattedCurrentTime() -> String {
        guard let time = self.audioRecord?.currentTime else { return "00:00:00" }
        return String.ga_formate(time: Int(time))
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
