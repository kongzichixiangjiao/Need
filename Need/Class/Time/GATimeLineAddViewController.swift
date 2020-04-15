//
//  GATimeLineAddViewController.swift
//  Need
//
//  Created by houjianan on 2020/4/8.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import RxGesture

class GATimeLineAddViewController: GARecordingBaseViewController, GAPickerViewProtocol, GAAlertProtocol {
    
    @IBOutlet weak var sTimeLabel: UILabel!
    @IBOutlet weak var sTimeButton: UIButton!
    @IBOutlet weak var eTimeLabel: UILabel!
    @IBOutlet weak var eTimeButton: UIButton!
    @IBOutlet weak var textView: GANormalizeTextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var natureButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    var timeLineModel: GATimeLineModel = GATimeLineModel.empty()
    var isAdd: Bool = true
    var onceString: String = ""
    var newString: String = ""
    
    lazy var microphoneView: GAMicrophoneKeyboardView = {
        let v = GAMicrophoneKeyboardView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 50))
        self.view.addSubview(v)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        
        sTimeButton.rx.tap.asDriver().drive(onNext: {
            #if DEBUG
            print("123")
            #endif
            self.pickerDateView_show(dateModel: .time) { [unowned self] date in
                self.sTimeLabel.isHidden = false
                let d = GASwiftDate.dateRegion(date: date)
                self.sTimeButton.setTitle(d.toString(.dateTime(.short)), for: .normal)
                self.timeLineModel.startDate = date
            }
        }).disposed(by: disposeBag)
        
        eTimeButton.rx.tap.asDriver().drive(onNext: {
            self.pickerDateView_show(dateModel: .time) { [unowned self] date in
                self.eTimeLabel.isHidden = false
                let d = GASwiftDate.dateRegion(date: date)
                self.eTimeButton.setTitle(d.toString(.dateTime(.short)), for: .normal)
                self.timeLineModel.endDate = date
            }
        }).disposed(by: disposeBag)
        
        textView.rx.text.subscribe(onNext: { (text) in
            self.timeLineModel.describe = text ?? ""
        }).disposed(by: disposeBag)
        
        natureButton.rx.tap.asDriver().drive(onNext: {
            self.pickerNormalView_show(dataSource: [["重要", "一般"]]) { (result) in
                let title = result.first ?? ""
                self.natureButton.setTitleColor(title == DefaultText.nature ? Need.title1Color : Need.kRedColor, for: .normal)
                self.natureButton.setTitle(title, for: .normal)
                self.timeLineModel.nature = title
            }
        }).disposed(by: disposeBag)
        
        saveButton.rx.tap.asDriver().drive(onNext: {
            guard let sDate = self.timeLineModel.startDate, let eDate = self.timeLineModel.endDate else {
                GAShowWindow.ga_show(message: "请选择开始、结束时间")
                return
            }
            if sDate.compare(eDate) != .orderedAscending {
                GAShowWindow.ga_show(message: "结束时间不能早于开始时间")
            }
            
            self.timeLineModel.createTime = Date()
            self.timeLineModel.timeLineId = String.ga_random(18)
            GACoreData.ga_save_timeLineModel(model: self.timeLineModel, timeLineId: "") {
                print("完成")
                self.ga_pop()
            }    
        }).disposed(by: disposeBag)
        
        deleteButton.rx.tap.asDriver().drive(onNext: {
            GACoreData.ga_delete_timeLineModel(timeLineId: self.timeLineModel.timeLineId ?? "") {
                print("完成")
                self.ga_pop()
            }
        }).disposed(by: disposeBag)
        
        microphoneView.observer(beginTapHandler: {
            self.speech.start()
            self.onceString = self.textView.text
        }, endTapHandler: {
            self.speech.stop()
            self.textView.text = self.onceString + self.newString
        }) { (h) in
            print(h)
        }
    }
    
    override func b_speechRecognition(text: String) {
        self.textView.text = self.onceString + text
        newString = text
        microphoneView.setupContent(s: text)
    }
    
    deinit {
        print("12312")
        microphoneView.removeObserver()
    }
    
    private func _initViews() {
        b_showNavigationView(title: "时间")
        
        textView.mDelegate = self
        
        let dataSource = [["洗漱", "吃饭", "拉坨坨", "穿衣服", "上班路上", "午睡", "下午活动", "下班路上", "运动" ]]
        b_navigationView.titleLable.rx.tapGesture().subscribe(onNext: { (tap) in
            if self.isAdd {
                self.pickerNormalView_show(dataSource: dataSource) { (result) in
                    let name = result.first ?? "无标题"
                    self.timeLineModel.name = name
                    self.b_navigationView.title = name
                }
            }
        }).disposed(by: disposeBag)
        
        if !isAdd {
            self.eTimeLabel.isHidden = false
            self.sTimeLabel.isHidden = false
            self.sTimeButton.setTitle(timeLineModel.startDate?.toString(.dateTime(.short)), for: .normal)
            self.eTimeButton.setTitle(timeLineModel.endDate?.toString(.dateTime(.short)), for: .normal)
            self.textView.text = timeLineModel.describe
            self.b_navigationView.title = timeLineModel.name
            let title = timeLineModel.nature ?? ""
            self.natureButton.setTitleColor(Need.natureButtonColor(title: title), for: .normal)
            self.timeLineModel.nature = title
        }
        self.deleteButton.isHidden = isAdd
    }
    
    
}

extension GATimeLineAddViewController: GANormalizeTextViewDelegate {
    func normalizeTextViewClickedReturn(textView: GANormalizeTextView) {
        print(textView)
    }
    
    func normalizeTextViewContentOffset(textView: GANormalizeTextView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 2, bottom: 0, right: 0)
    }
    
    func normalizeTextViewPlaceholdView(textView: GANormalizeTextView) -> UIView {
        let l = UILabel().then {
            $0.frame = CGRect(x: 0, y: textView.height / 2 - 15, width: kScreenWidth, height: 15)
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 24)
            $0.textColor = kFont_2_9_LevelColor
            $0.text = "请输入描述的内容"
        }
        return l
    }
}
