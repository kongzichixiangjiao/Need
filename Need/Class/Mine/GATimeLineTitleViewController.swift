//
//  GATimeLineTitleViewController.swift
//  Need
//
//  Created by houjianan on 2020/4/13.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit

class GATimeLineTitleViewController: NeedNavViewController, GAAlertProtocol {

    var data = [GATagsButtonModel]()
    
    lazy var tagsView: GATagsView = {
        let model = GATagsViewModel()
        let v = GATagsView(frame: CGRect(x: 0, y: b_navigationViewMaxY, width: kScreenWidth, height: 200), btnModels: data, model: model, clickedHandler: {
            [unowned self] btn, model, isLast  in
            if isLast {
                
                self.alertEdit_show { [unowned self] text in
                    let model = GATagsButtonModel()
                    model.name = text
                    self.data.append(model)
                    
                    self.tagsView.reloadViewsMoreType(btnModels: self.data, maxRows: 100)
                }
                
            } else {
                
            }
        })
        v.delegate = self
        v.backgroundColor = UIColor.randomColor()
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _initViews()
        _request()
    }
    
    private func _initViews() {
        b_showNavigationView(title: "时间轴标题")

        self.view.addSubview(tagsView)
        
    }
    
    private func _request() {
//        var titles = [String]()
//        for model in data {
//            titles.append(model.name)
//        }
//        if GAPlistManager.share.writeArrayPlist(data: titles, fileName: Plist.FileName.kTimeLineTitles) {
//            GAShowWindow.ga_show(message: "保存成功")
//        }
        
        guard let titles = GAPlistManager.share.readDicPlist(fileName: Plist.FileName.kTimeLineTitles) as? [String] else { return }
        for title in titles {
            let model = GATagsButtonModel()
            model.name = title
            data.append(model)
        }
        
        tagsView.reloadViewsMoreType(btnModels: data)
    }

}

extension GATimeLineTitleViewController: GATagsViewDelegate {
    func tagsViewClickedConfirm(text: String) {
        
    }
}
