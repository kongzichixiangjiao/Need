//
//  GATabBarController.swift
//  YueYe
//
//  Created by 侯佳男 on 2017/5/19.
//  Copyright © 2017年 侯佳男. All rights reserved.
//  self.title = "" 这个不要设置  GABaseXibTabBarView配置导航样式  storyboard增删vc

import UIKit

class GATabBarViewController: UITabBarController {
    
    @IBInspectable var hideSpecialView: Bool = true
    @IBInspectable var specialIndex: Int = 2
    
    public var vcs: [UIViewController] = []
    
    private let lu_titles = ["1", "2", "3", "2", "3"]
    private let lu_vcs = [UIViewController(), UIViewController(), UIViewController(), UIViewController(), UIViewController()]
    
    lazy var xibTabBarView: GABaseXibTabBarView = {
        let v = GABaseXibTabBarView.loadBaseXibTabBarView()
        v.mDelegate = self
        v.frame = CGRect(x: 0, y: 0, width: self.tabBar.bounds.width, height: kTabBarHeight)
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin]
        return v
    }()
    
    lazy var specialView: UILabel = {
        let w: CGFloat = self.view.width / 5
        let v = UILabel(frame: CGRect(x: 0, y: -30, width: w, height: w))
        v.layer.cornerRadius = w / 2
        v.layer.masksToBounds = true
        v.ga_addTapGestureRecognizer(target: self, action: #selector(_specialTap(tap:)))
        v.text = "中间"
        v.textAlignment = .center
        v.backgroundColor = UIColor.randomColor()
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // removeFromView方式，观看图层，层级特别多。
        self.setValue(xibTabBarView, forKey: "tabBar")
        
        _hideTopLineView()
        
        if !hideSpecialView {
            xibTabBarView.b_tabBarSpecialView(v: specialView, index: specialIndex)
        }
        
        self.delegate = self
        
        initViewControllers()
        
        xibTabBarView.b_tabBarVeiwClicked(tag: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func initViewControllers() {
        guard let vcs = self.viewControllers else {
            _initLuVC()
            return
        }
        
        _initStoryboardVC(vcs: vcs)
        
        self.viewControllers = self.vcs
    }
    
    private func _initStoryboardVC(vcs: [UIViewController]) {
        for i in 0..<vcs.count {
            let vc = vcs[i]
            _initVC(vc: vc, tag: i)
        }
    }
    
    private func _initLuVC() {
        for i in 0..<vcs.count {
            let title = lu_titles[i]
            xibTabBarView.updateView(title: title, index: i)
            
            let vc = lu_vcs[i]
            _initVC(vc: vc, tag: i)
        }
        
        self.viewControllers = self.vcs
    }
    
    private func _initVC(vc: UIViewController, tag: Int) {
        if NSStringFromClass(type(of: vc)).components(separatedBy: ".").last! == "GANavigationViewController" ||
            NSStringFromClass(type(of: vc)).components(separatedBy: ".").last! == "UINavigationViewController" {
            vc.vc_tag = tag
            self.vcs.append(vc)
        } else {
            let nav = GANavigationViewController(rootViewController: vc)
            nav.vc_tag = tag
            self.vcs.append(nav)
        }
    }
    
    public var tabBar_currentVC: UIViewController {
        return self.viewControllers![selectedIndex]
    }
    
    public func willShowVC(clickedIndex d_idnex: Int) -> UIViewController {
        return self.viewControllers![d_idnex]
    }
    
    // 再次点击 刷新当前vc
    public func tabbar_refreshCurrent(vc: UIViewController) {
        
    }
    
    public func tabbar_login(vc: UIViewController, index: Int) {
        
    }
    
    @objc func _specialTap(tap: UITapGestureRecognizer) {
        selectedIndex = 2
    }
    
    private func _hideTopLineView() {
        if #available(iOS 13, *) {
            let appearance = self.tabBar.standardAppearance.copy()
            appearance.backgroundImage = UIColor.randomColor().ga_image(viewSize: CGSize(width: self.tabBar.width, height: 1))
            appearance.shadowImage = UIColor.randomColor().ga_image(viewSize: CGSize(width: self.tabBar.width, height: 1))
            appearance.shadowColor = .clear
            //            appearance.configureWithTransparentBackground() // 隐藏topline需要打开注释
            self.tabBar.standardAppearance = appearance
        } else {
            self.tabBar.shadowImage = UIColor.randomColor().ga_image(viewSize: CGSize(width: self.tabBar.width, height: 1))
            self.tabBar.backgroundImage = UIColor.randomColor().ga_image(viewSize: CGSize(width: self.tabBar.width, height: 1))
        }
    }
    
}

extension GATabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        xibTabBarView.b_tabBarVeiwClicked(tag: viewController.vc_tag)
    }
}

extension GATabBarViewController: GABaseXibTabBarViewDelegate {
    func base_xibTabBarView(currentIndex c_index: Int, clickedIndex d_index: Int) {
        self.selectedIndex = d_index
        
        tabbar_login(vc: self.vcs[d_index], index: d_index)
    }
    
    func base_xibTabBarViewClickedCurrentItem(index: Int) {
        tabbar_refreshCurrent(vc: self.vcs[index])
    }
}

extension UIViewController {
    static var kViewControllerKey_tag: UInt = 19112301
    
    var vc_tag: Int {
        set {
            objc_setAssociatedObject(self, &UIViewController.kViewControllerKey_tag, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            if let b = objc_getAssociatedObject(self, &UIViewController.kViewControllerKey_tag) {
                return b as! Int
            }
            return -2019
        }
    }
}









