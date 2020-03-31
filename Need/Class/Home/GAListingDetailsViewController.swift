//
//  GAListingDetailsViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/22.
//  Copyright © 2020 houjianan. All rights reserved.
//  清单详情

import UIKit
import TYPagerController

class GAListingDetailsViewController: NeedNavViewController {
    var listingModel: GAListingModel!
    
    private let titles: [String] = ["新增", "列表", "设置"]
    private let pageVc = TYTabPagerController().then {
        $0.tabBarHeight = 30.0
        $0.tabBar.backgroundColor = Need.tabsBgColor
        $0.tabBar.layout.barStyle = .progressElasticView
        $0.tabBar.layout.cellWidth = kScreenWidth / 3
        $0.tabBar.layout.cellSpacing = 0
        $0.tabBar.layout.cellEdging = 0
        $0.tabBar.layout.progressColor = Need.title1Color
        $0.tabBar.layout.normalTextColor = Need.title2Color!
        $0.tabBar.layout.selectedTextColor = Need.title1Color!
    }
    private var vcs: [UIViewController] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _request()
        _initPageController()
    }
    
    private func _initViews() {
        b_showNavigationView(title: "清单详情")
    }
    
    private func _request() {
        
    }
}

extension GAListingDetailsViewController {
    private func _initPageController() {
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

extension GAListingDetailsViewController: TYTabPagerControllerDelegate, TYTabPagerControllerDataSource {
    func numberOfControllersInTabPagerController() -> Int {
        return titles.count
    }
    func tabPagerController(_ tabPagerController: TYTabPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        if index == 0 {
            let vc = self.ga_storyboardVC(type: GAPlanAddViewController.self, storyboardName: HomeStoryboard.name)
            vc.listingModel = listingModel
            return vc
        } else if index == 1 {
            let vc = self.ga_storyboardVC(type: GAListingViewController.self, storyboardName: HomeStoryboard.name)
            vc.listingModel = listingModel
            return vc
        } else if index == 2 {
            let vc = self.ga_storyboardVC(type: GAListingSettingViewController.self, storyboardName: HomeStoryboard.name)
            vc.listingModel = listingModel
            return vc
        }
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.orange
        return vc
    }
    func tabPagerController(_ tabPagerController: TYTabPagerController, titleFor index: Int) -> String {
        return titles[index]
    }

    func tabPagerControllerDidEndScrolling(_ tabPagerController: TYTabPagerController, animate: Bool) {

    }
}
