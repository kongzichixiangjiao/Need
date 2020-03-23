//
//  GAListingViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/22.
//  Copyright © 2020 houjianan. All rights reserved.
//  首页-清单

import UIKit
import RxSwift
import RxCocoa

class GAListingViewController: GARxSwiftNavViewController {
    
    var model: GAPlanModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var topHeight: CGFloat = 400
    private let fixedHeight: CGFloat = 90
    private var _containerView: UIView!
    
    lazy var topView: UIView = {
        let v = GADemoView()
        v.frame = CGRect(x: 0, y: -topHeight, width: self.view.width, height: topHeight)
        return v
    }()
    
    lazy var fixedView: GADemoView = {
        let v = GADemoView()
        v.frame = CGRect(x: 0, y: b_navigationViewMaxY, width: self.view.width, height: fixedHeight)
        v.text = "fixedView"
        v.isHidden = true
        return v
    }()
    
    lazy var navView: GADemoView = {
        let v = GADemoView()
        v.frame = CGRect(x: 0, y: 0, width: self.view.width, height: b_navigationViewMaxY)
        v.text = "navView"
        v.isHidden = true
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _request()
        _request()
        _request()
    }
    
    private func _initViews() {
        b_showNavigationView(title: model.name ?? "")
        
        b_showNavigationRightButton(imgName: Other.kNavImgName_add) {
            [unowned self] title in
            
        }
        
        self.tableView.addSubview(topView)
        self.view.addSubview(fixedView)
        let vc = self.ga_storyboardVC(type: GAListingContainerViewController.self, storyboardName: HomeStoryboard.name)
        vc.delegate = self
        guard let containerView = vc.view else {
                return
        }
        _containerView = containerView
        self.topView.addSubview(_containerView)
    }
    
    private func _request() {
        
    }
    
    override func b_viewDidLayoutSubviews() {
        self._containerView.frame = self.topView.bounds
        self.topView.frame = CGRect(x: 0, y: -self.topHeight, width: self.view.width, height: self.topHeight)
        self.tableView.contentInset = UIEdgeInsets(top: self.topHeight, left: 0, bottom: 0, right: 0)
        self.tableView.contentOffset = CGPoint(x: 0, y: -self.topHeight)
        self.tableView.reloadData()
    }
    
}

extension GAListingViewController: GAListingContainerViewControllerDelegate {

}

extension GAListingViewController: UITableViewDelegate, UITableViewDataSource{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if y <= -self.topHeight {
            self.topView.y = -topHeight + (y + topHeight)
            self.topView.height = -y
            return
        }
        
        if y > -fixedHeight {
            self.topView.y = -topHeight + fixedHeight + y
            navView.isHidden = false
        } else {
            navView.isHidden = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.ga_dequeueReusableCell(cellClass: GAListingCell.self)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}

class GAListingCell: UITableViewCell {
    
}
