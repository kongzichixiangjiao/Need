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
        model.bNormalBackColor = Need.cellBgColor ?? UIColor.lightText
        
        let v = GATagsView(frame: CGRect(x: 0, y: b_navigationViewMaxY, width: kScreenWidth, height: 200), btnModels: data, model: model, clickedHandler: {
            [unowned self] btn, model, isLast  in
            self._showEdit()
        })
        v.backgroundColor = Need.vcBgColor
        return v
    }()
    
    var editTag: Int = -1
    private func _showEdit() {
        self.alertEdit_show { [unowned self] text in
            if self.editTag != -1 {
                let model = self.data[self.editTag]
                model.name = text
            } else {
                let model = GATagsButtonModel()
                model.name = text
                self.data.append(model)
            }
            self.save()
            self.tagsView.reloadViews(btnModels: self.data, maxRows: 100) { [unowned self] b, model, isLast in
                if isLast {
                    self.editTag = -1
                } else {
                    self.editTag = b.tag
                }
                self._showEdit()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        _request()
        _initViews()
    }
    
    private func _initViews() {
        b_showNavigationView(title: "时间轴标题")
        
        self.view.addSubview(tagsView)
        
    }
    
    private func _request() {
        
        guard let titles = GAPlistManager.share.readArrayPlist(fileName: Plist.FileName.kTimeLineTitles) as? [String] else { return }
        
        for title in titles {
            let model = GATagsButtonModel()
            model.name = title
            data.append(model)
        }
    }
    
    func save() {
        var titles = [String]()
        for model in data {
            titles.append(model.name)
        }
        if GAPlistManager.share.writeArrayPlist(data: titles, fileName: Plist.FileName.kTimeLineTitles) {
            GAShowWindow.ga_show(message: "保存成功")
        }
    }
    
}
