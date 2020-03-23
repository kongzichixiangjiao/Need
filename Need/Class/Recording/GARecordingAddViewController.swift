//
//  GARecordingAddViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/14.
//  Copyright © 2020 houjianan. All rights reserved.
//  录音

import UIKit
import SwiftDate
import RxSwift
import MagicalRecord
import SCLAlertView

class GARecordingAddViewController: GARecordingBaseViewController {
    
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioType = .recording
        
        _initViews()
        _addTimer()
        
        _recordingButtonAction()
    }
    
    private func _initViews() {
        b_showNavigationView(title: "增加一段录音记录")
    }
    
    private func _addTimer() {
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.asyncInstance)
        timer.subscribe(onNext: {
            [weak self] time in
            if self?.recording.isRecording ?? false {
                self?.currentTimeLabel.text = self?.recording.formattedCurrentTime() ?? ""
            }
        }).disposed(by: disposeBag)
    }
    
    deinit {
        print("---")
    }
}

extension GARecordingAddViewController {
    fileprivate func _recordingButtonAction() {
        self.recordingButton.rx.tap.subscribe {
            [unowned self] e in
            if !self.isAllowed {
                self.requestRecordPermission()
                return
            }
            if self.recordingButton.isSelected   {
                self.recording.stop {
                    [unowned self] b, message in
                    if b {
                        self._save(totalTime: self.stopSonic())
                    } else {
                        GAShowWindow.ga_show(message: message)
                    }
                }
            } else {
                self.recording.start()
                self.startSonic()
            }
            self.recordingButton.isSelected = !self.recordingButton.isSelected
        }.disposed(by: disposeBag)
    }
    
    fileprivate func _save(totalTime: Double) {
        
        let appearance = SCLAlertView.SCLAppearance(
             kWindowWidth: kScreenWidth - 40, showCloseButton: false, circleBackgroundColor: UIColor.white
        )
        
        let alert = SCLAlertView(appearance: appearance)
        let txt = alert.addTextField("请输入文件名字")
        alert.addButton("确定", backgroundColor: kMainButtonDefaultColor) {
            save(title: txt.text ?? self._fileName())
        }
        alert.addButton("使用默认名称", backgroundColor: kMainButtonDefaultColor) {
            save(title: self._fileName())
        }
        alert.addButton("不保存", backgroundColor: kMainButtonDefaultColor) {
            
        }
        
        alert.showEdit("文件名称", subTitle: "输入一个有针对性的名称", colorStyle: 0x999999)
        
        func save(title: String) {
            let input = self.recording.save(fileName: title)
            let path = input.0
            let name = input.1
            let dateString = GADate.currentDateToDateString(dateFormat: GADateFormatType.y_m_d_h_m_s_chinese.rawValue)
            if !path.isEmpty {
                GACoreData.saveDB(type: GARecordingModel.self, name: name, block: { (entity) in
                    entity?.path = path
                    entity?.name = name
                    entity?.dateString = dateString
                    entity?.totalTime = totalTime
                }) { (models) in
                    let result = GACoreData.findAll(type: GARecordingModel.self)
                    print(result.last?.dateString ?? "")
                    print(result.last?.name ?? "")
                    GAShowWindow.ga_show(message: "保存成功")
                }
            } else {
                GAShowWindow.ga_show(message: "保存失败")
            }
        }
    }
    
    fileprivate func _fileName() -> String {
        return Date().ga_milliStamp + "_" + String.ga_random(5, true)
    }
}

