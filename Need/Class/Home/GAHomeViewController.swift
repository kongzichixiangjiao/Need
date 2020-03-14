//
//  GAHomeViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/14.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import TYPagerController
import Then
import SnapKit

class GAHomeViewController: GARxSwiftNavViewController, GANavViewControllerProtocol {
    
    private let titles: [String] = ["时间", "录音"]
    private let pageVc = TYTabPagerController().then {
        $0.tabBarHeight = 80.0
        $0.tabBar.backgroundColor = kSecondaryBackgroundColor
        $0.tabBar.layout.barStyle = .progressElasticView
        $0.tabBar.layout.cellWidth = kScreenWidth / 2
        $0.tabBar.layout.cellSpacing = 0
        $0.tabBar.layout.cellEdging = 0
        $0.tabBar.layout.progressColor = kFont_3_6_LevelColor
        $0.tabBar.layout.normalTextColor = kFont_2_9_LevelColor!
        $0.tabBar.layout.selectedTextColor = kFont_4_3_LevelColor!
    }
    private var vcs: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nav_hideBackButton()
        b_showNavigationView(title: "首页")
        initPageController()
    }
    
}

extension GAHomeViewController {
    private func initPageController() {
        pageVc.delegate = self
        pageVc.dataSource = self
        pageVc.view.frame = self.view.frame
        view.addSubview(pageVc.view)
        self.addChild(pageVc)
        pageVc.view.snp.makeConstraints { (make) in
            make.top.equalTo(b_navigationViewMaxY)
            make.left.right.bottom.equalToSuperview()
        }
        pageVc.reloadData()
        // 设置起始页
        pageVc.pagerController.scrollToController(at: 1, animate: false)
    }
}

extension GAHomeViewController: TYTabPagerControllerDelegate, TYTabPagerControllerDataSource {
    func numberOfControllersInTabPagerController() -> Int {
        return titles.count
    }
    func tabPagerController(_ tabPagerController: TYTabPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        if index == 0 {
            return UIViewController()
        } else if index == 1 {
            return UIViewController()
        }
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.orange
        return vc
    }
    func tabPagerController(_ tabPagerController: TYTabPagerController, titleFor index: Int) -> String {
        return titles[index]
    }
}
