//
//  UITableView+PlaceHolder.swift
//  YE
//
//  Created by 侯佳男 on 2017/12/26.
//  Copyright © 2017年 侯佳男. All rights reserved.
//  感谢 微博@iOS程序犭袁

/*
 001、// 必须实现numberOfSections代理方法
 
 002、self.tableView.emptyDelegate = self
 
 // 刷新使用ga_reloadData()
 003、self.tableView.ga_reloadData()
 
 004、// 实现代理UITableViewPlaceHolderDelegate方法
 public extension <#UIViewController#>: UITableViewPlaceHolderDelegate {
 func tableViewPlaceHolderView() -> UIView {
 let v = <#UIView#>
 return v
 }
 
 func tableViewEnableScrollWhenPlaceHolderViewShowing() -> Bool {
 return <#true#>
 }
 }
 */

import UIKit

public enum UIScrollViewHolderType: Int {
    case empty = 0, noNetwork = 1
}

public protocol UITableViewPlaceHolderDelegate {
    func tableViewPlaceHolderView() -> UIView
    func tableViewEnableScrollWhenPlaceHolderViewShowing() -> Bool
    func tableViewPlaceHolderViewOffSetY() -> CGFloat
    func tableViewClickedPlaceHolderViewRefresh()
    func tableViewPlaceHolder_NoNetWork_View() -> UIView?
}

public extension UITableView {
    
    static var k_t_EmptyDelegateKey: UInt = 149001
    static var k_t_ScrollWasEnabledKey: UInt = 149002
    static var k_t_PlaceHolderViewKey: UInt = 149003
    
    var scrollWasEnabled: Bool {
        set {
            objc_setAssociatedObject(self, &UITableView.k_t_ScrollWasEnabledKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &UITableView.k_t_ScrollWasEnabledKey) as! Bool
        }
    }
    
    var placeHolderView: UIView? {
        set {
            objc_setAssociatedObject(self, &UITableView.k_t_PlaceHolderViewKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            let v = objc_getAssociatedObject(self, &UITableView.k_t_PlaceHolderViewKey) as? UIView
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapTableView))
            v?.addGestureRecognizer(tap)
            return v
        }
    }
    
    var emptyDelegate: UITableViewPlaceHolderDelegate? {
        set {
            objc_setAssociatedObject(self, &UITableView.k_t_EmptyDelegateKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &UITableView.k_t_EmptyDelegateKey) as? UITableViewPlaceHolderDelegate
        }
    }
    
    func ga_reloadData() {
        self.reloadData()
        self.ga_judgeEmpty()
    }
    
    private func ga_judgeEmpty() {
        self.scrollWasEnabled = self.isScrollEnabled
        
        removeView()
        
        if isEmpty() {
            placeholderView(type: .empty)
            self.separatorStyle = .none
        } else {
            
        }
    }
    
    private func isEmpty() -> Bool {
        var isEmpty: Bool = true
        let src = self.dataSource
        let sections = src?.numberOfSections!(in: self) ?? 1
        for i in 0..<sections {
            if let row = src?.tableView(self, numberOfRowsInSection: i) {
                if row > 0 {
                    isEmpty = false
                }
            }
        }
        return isEmpty
    }
    
    private func placeholderView(type: UIScrollViewHolderType) {
        if let emptyDelegate = self.emptyDelegate {
            self.isScrollEnabled = emptyDelegate.tableViewEnableScrollWhenPlaceHolderViewShowing()
            if (type == .empty) {
                self.placeHolderView = emptyDelegate.tableViewPlaceHolderView()
            } else {
                if let v = emptyDelegate.tableViewPlaceHolder_NoNetWork_View() {
                    self.placeHolderView = v
                }
            }
            let w: CGFloat = self.frame.size.width
            let h: CGFloat = self.frame.size.height
            let pW: CGFloat = self.placeHolderView?.frame.size.width ?? 0
            let pH: CGFloat = self.placeHolderView?.frame.size.height ?? 0
            let offSetY: CGFloat = emptyDelegate.tableViewPlaceHolderViewOffSetY()
            let l = self.contentInset.left
            let t = self.contentInset.top
            let b = self.contentInset.bottom
            let r = self.contentInset.right
            self.placeHolderView?.frame = CGRect(x: w / 2 - pW / 2 - l / 2 + r / 2, y: h / 2 - pH / 2 - offSetY - t / 2 + b / 2, width: pW - l - r, height: pH - t - b)
//            self.placeHolderView?.backgroundColor = UIColor.orange
            self.addSubview(self.placeHolderView!)
            //            self.backgroundView = self.placeHolderView
        } else {
            print("UITableView+PlacerHolder ga_judgeEmpty() 没遵守代理")
        }
    }
    
    private func removeView() {
        self.isScrollEnabled = true
        self.placeHolderView?.removeFromSuperview()
        self.placeHolderView = nil
    }
    
    @objc private func tapTableView() {
        emptyDelegate?.tableViewClickedPlaceHolderViewRefresh()
    }
}


@objc public protocol UICollectionViewPlaceHolderDelegate: class {
    func collectionViewPlaceHolderView() -> UIView
    func collectionViewEnableScrollWhenPlaceHolderViewShowing() -> Bool
    func tableViewPlaceHolderViewOffSetY() -> CGFloat
    @objc optional func collectionViewPlaceHolderViewFrame() -> CGRect
    func collectionViewPlaceHolder_NoNetWork_View() -> UIView?
    func collectionViewClickedPlaceHolderViewRefresh()
}

public extension UICollectionView {
    
    static var k_c_EmptyDelegateKey: UInt = 149004
    static var k_c_ScrollWasEnabledKey: UInt = 149005
    static var k_c_PlaceHolderViewKey: UInt = 149006
    
    var scrollWasEnabled: Bool {
        set {
            objc_setAssociatedObject(self, &UICollectionView.k_c_ScrollWasEnabledKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &UICollectionView.k_c_ScrollWasEnabledKey) as! Bool
        }
    }
    
    var placeHolderView: UIView? {
        set {
            objc_setAssociatedObject(self, &UICollectionView.k_c_PlaceHolderViewKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            let v = objc_getAssociatedObject(self, &UICollectionView.k_c_PlaceHolderViewKey) as? UIView
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapCollectionView))
            v?.addGestureRecognizer(tap)
            return v
        }
    }
    
    var emptyDelegate: UICollectionViewPlaceHolderDelegate? {
        set {
            objc_setAssociatedObject(self, &UICollectionView.k_c_EmptyDelegateKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &UICollectionView.k_c_EmptyDelegateKey) as? UICollectionViewPlaceHolderDelegate
        }
    }
    
    func ga_reloadData() {
        self.reloadData()
        self.ga_judgeEmpty()
    }
    
    private func ga_judgeEmpty() {
        self.scrollWasEnabled = self.isScrollEnabled
        
        removeView()
        
        if isEmpty() {
            placeholderView(type: .empty)
        }
    }
    
    private func isEmpty() -> Bool {
        var isEmpty: Bool = true
        let src = self.dataSource
        let sections = src?.numberOfSections!(in: self) ?? 1
        for i in 0..<sections {
            if let row = src?.collectionView(self, numberOfItemsInSection: i) {
                if row > 0 {
                    isEmpty = false
                }
            }
        }
        return isEmpty
    }
    
    private func placeholderView(type: UIScrollViewHolderType) {
        if let emptyDelegate = self.emptyDelegate {
            self.isScrollEnabled = emptyDelegate.collectionViewEnableScrollWhenPlaceHolderViewShowing()
            if (type == .empty) {
                self.placeHolderView = emptyDelegate.collectionViewPlaceHolderView()
            } else {
                if let v = emptyDelegate.collectionViewPlaceHolder_NoNetWork_View() {
                    self.placeHolderView = v
                }
            }
            let w: CGFloat = self.frame.size.width
            let h: CGFloat = self.frame.size.height
            let pW: CGFloat = self.placeHolderView?.frame.size.width ?? 0
            let pH: CGFloat = self.placeHolderView?.frame.size.height ?? 0
            let offSetY: CGFloat = emptyDelegate.tableViewPlaceHolderViewOffSetY()
            self.placeHolderView?.frame = CGRect(x: w / 2 - pW / 2, y: h / 2 - pH / 2 - offSetY, width: pW, height: pH)
//            self.placeHolderView?.backgroundColor = UIColor.orange
            self.addSubview(self.placeHolderView!)
        } else {
            print("UITableView+PlacerHolder ga_judgeEmpty() 没遵守代理")
        }
    }
    
    private func removeView() {
        self.isScrollEnabled = true
        self.placeHolderView?.removeFromSuperview()
        self.placeHolderView = nil
    }
    
    
    @objc private func tapCollectionView() {
        emptyDelegate?.collectionViewClickedPlaceHolderViewRefresh()
    }
}

extension UIScrollView {
    func global_swizzleinstanceSelector(origSel: Selector, replaceSel: Selector) {
        guard let origMethod = class_getInstanceMethod(self.classForCoder, origSel) else {
            return
        }
        guard let replaceMethod = class_getInstanceMethod(self.classForCoder, replaceSel) else {
            return
        }
        
        let didAddMethod = class_addMethod(self.classForCoder, origSel, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod))
        if didAddMethod {
            class_replaceMethod(self.classForCoder, replaceSel, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod))
        } else {
            method_exchangeImplementations(origMethod, replaceMethod)
        }
    }
}
