//
//  GATableViewController.swift
//  GAFramework
//
//  Created by houjianan on 2019/8/27.
//  Copyright © 2019 houjianan. All rights reserved.
//

import UIKit
import GAExtension

class GATableViewController: GAViewController {
    @IBOutlet weak var tableView: UITableView!
    // 防止重复点击
    private var preventRepeatClicked: Bool = false
    
    @objc func preventRepeatClicked(b: Bool) {
        preventRepeatClicked = b
    }
}

extension GATableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !preventRepeatClicked {
            preventRepeatClicked = true
            tableView.deselectRow(at: indexPath, animated: true)
            self.perform(#selector(preventRepeatClicked(b:)), with: false, afterDelay: 1.0)
        } else {
            return
        }
    }
}

class GANavTableViewController: GANavViewController {
    @IBOutlet weak var tableView: UITableView!
    // 防止重@objc 复点击
    private var preventRepeatClicked: Bool = false
    
    @objc func preventRepeatClicked(b: Bool) {
        preventRepeatClicked = b
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.emptyDelegate = self
    }
    
    public func b_clickedPlaceHolderViewrefresh() {
        
    }
}

extension GANavTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !preventRepeatClicked {
            preventRepeatClicked = true
            tableView.deselectRow(at: indexPath, animated: true)
            self.perform(#selector(preventRepeatClicked(b:)), with: false, afterDelay: 1.0)
        } else {
            return
        }
    }
}

extension GANavTableViewController: UITableViewPlaceHolderDelegate {
    func tableViewPlaceHolderViewOffSetY() -> CGFloat {
        return 50
    }
    
    // 如果有其他样式图片可以重写此方法
    @objc func tableViewPlaceHolderView() -> UIView {
        let v = GAListPlaceholderView.ga_xibView()
        v.imgName = "scrollView_noData_icon"
        return v
    }
    
    func tableViewEnableScrollWhenPlaceHolderViewShowing() -> Bool {
        return true
    }
    
    func tableViewClickedPlaceHolderViewRefresh() {
        
    }
    
    func tableViewPlaceHolder_NoNetWork_View() -> UIView? {
        return nil
    }
}
