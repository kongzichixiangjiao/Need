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
    
    private let titles: [String] = ["列表", "设置"]
    private let pageVc = TYTabPagerController().then {
        $0.tabBarHeight = 30.0
        $0.tabBar.backgroundColor = Need.tabsBgColor
        $0.tabBar.layout.barStyle = .progressElasticView
        $0.tabBar.layout.cellWidth = kScreenWidth / 2
        $0.tabBar.layout.cellSpacing = 0
        $0.tabBar.layout.cellEdging = 0
        $0.tabBar.layout.progressColor = Need.title1Color
        $0.tabBar.layout.normalTextColor = Need.title2Color!
        $0.tabBar.layout.selectedTextColor = Need.title1Color!
    }
    private var vcs: [UIViewController] = []
    
    lazy var listVC: GAListingViewController = {
        let vc = self.ga_storyboardVC(type: GAListingViewController.self, storyboardName: HomeStoryboard.name)
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _request()
        _initPageController()
        
        self.rx.viewWillAppear.subscribe(onNext: { (b) in
            GAFloatWindow.show {
                [unowned self] in
                guard let currentVC = UIApplication.ga_currentVC(self) else {
                    return
                }
                let vc = currentVC.ga_storyboardVC(type: GAPlanAddViewController.self, storyboardName: HomeStoryboard.name)
                vc.listingModel = self.listingModel
                currentVC.present(vc, animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)
        self.rx.viewDidDisappear.subscribe(onNext: { (b) in
            GAFloatWindow.hide()
        }).disposed(by: disposeBag)
    }
    
    private func _initViews() {
        b_showNavigationView(title: "清单详情")

        b_showNavigationRightButton(imgName: Other.kListingDetailsRightRefreshButtonIcon) { [unowned self] title in
            let result = GACoreData.ga_find_planModels(value: self.listingModel.listingId ?? "")
            for model in result {
                GACoreData.ga_save_planModel(model: GAPlanItemModel.getItem(planModel: model), isFinished: false) { (result) in
                    self.listVC.reload()
                }
            }
        }
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
        pageVc.pagerController.scrollToController(at: 0, animate: false)
    }
}

extension GAListingDetailsViewController: TYTabPagerControllerDelegate, TYTabPagerControllerDataSource {
    func numberOfControllersInTabPagerController() -> Int {
        return titles.count
    }
    func tabPagerController(_ tabPagerController: TYTabPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        if index == 0 {
            listVC.listingModel = listingModel
            return listVC
        } else if index == 1 {
            let vc = self.ga_storyboardVC(type: GAListingSettingViewController.self, storyboardName: HomeStoryboard.name)
            vc.listingModel = listingModel
            return vc
        }
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.white
        return vc
    }
    func tabPagerController(_ tabPagerController: TYTabPagerController, titleFor index: Int) -> String {
        return titles[index]
    }
    
    func tabPagerControllerDidEndScrolling(_ tabPagerController: TYTabPagerController, animate: Bool) {
        
    }
}
