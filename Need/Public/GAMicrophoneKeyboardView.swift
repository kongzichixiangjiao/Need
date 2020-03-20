//
//  KeyboardProtocol.swift
//  Need
//
//  Created by houjianan on 2020/3/19.
//  Copyright © 2020 houjianan. All rights reserved.
//

//let v = MicrophoneKeyboardView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 40), beginTapHandler: {
//
//}, endTapHandler: {
//
//}) { (h) in
//    print(h)
//}
//v.backgroundColor = UIColor.randomColor()
//self.view.addSubview(v)

//deinit {
//    microphoneView.removeObserver()
//}

import UIKit

class GAMicrophoneKeyboardView: GAKeyboardView {
    
    lazy var contentLabel: UILabel = {
        let v = UILabel()
        v.frame = CGRect(x: 0, y: -20, width: self.frame.size.width, height: 20)
        v.font = UIFont.systemFont(ofSize: 12)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        
        let w: CGFloat = 40.0
        let b = UIButton(frame: CGRect(x: self.frame.size.width / 2 - w / 2, y: 0, width: w, height: w))
        b.setImage(UIImage(named: "recording_icon_recording"), for: UIControl.State.normal)
        b.addTarget(self, action: #selector(touchDown), for: UIControl.Event.touchDown)
        b.addTarget(self, action: #selector(touchUpInside), for: UIControl.Event.touchUpInside)
        b.addTarget(self, action: #selector(touchUpOutside), for: UIControl.Event.touchUpOutside)
        self.addSubview(b)
        
        self.addSubview(contentLabel)
    }
    
    func setupContent(s: String) {
        contentLabel.text = s
    }
    
    @objc func touchDown() {
        beginTapHandler()
        print("touchDown")
    }
    
    @objc func touchUpInside() {
        endTapHandler()
        print("touchUpInside")
    }
    
    @objc func touchUpOutside() {
        endTapHandler()
        print("touchUpOutside")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
//        guard let img = UIImage(named: "recording_icon_recording") else {
//            return
//        }
//
//        let w = self.frame.size.width
//
//        let imgW: CGFloat = 50.0
//        let imgH: CGFloat = 50.0
//        let imgX: CGFloat = w / 2 - imgW / 4
//        let imgY: CGFloat = 20
//
//        guard let imgCG = img.cgImage else {
//            return
//        }
//
//        let context = UIGraphicsGetCurrentContext()
//        context?.translateBy(x: 0, y: imgH)
//        context?.scaleBy(x: 1.0, y: -1.0)
//        context?.draw(imgCG, in: CGRect(x: imgX, y: imgY, width: imgW / 2, height: imgH / 2))
        
    }
    
}

