//
//  GASelectedColorsViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/31.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit

class GASelectedColorsViewController: GANavViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listingModel: GAListingModel!
    
    var dataSource: [[String : String]] = [["name" : "默认", "color" : "ffffff"],
                                           ["name" : "黄色", "color" : "f0f30a"],
                                           ["name" : "绿色", "color" : "41f30a"],
                                           ["name" : "蓝色", "color" : "0a5df3"],
                                           ["name" : "粉色", "color" : "f192f9"],
                                           ["name" : "紫色", "color" : "840290"],
                                           ["name" : "棕色", "color" : "904802"],
                                           ["name" : "橘色", "color" : "f7ba38"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _request()
    }
    
    private func _initViews() {
        b_showNavigationView(title: "清单颜色")
    }
    
    private func _request() {
        
    }
}

extension GASelectedColorsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ga_dequeueReusableCell(cellClass: GASelectedColorsCell.self)
        cell.nameLabel.text = dataSource[indexPath.row]["name"]
        cell.iconView.backgroundColor = dataSource[indexPath.row]["color"]?.color0X
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let color = dataSource[indexPath.row]["color"]
        GACoreData.saveDB(type: GAListingModel.self, key: "listingId", value: self.listingModel.listingId ?? "", block: { (empty) in
            empty?.color = color ?? Need.kListingDefaultColor
        }) { (result) in
            GAShowWindow.ga_show(message: DefaultText.Toast.success)
        }
    }
}


class GASelectedColorsCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconView: UIView!
    
}
