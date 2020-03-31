//
//  ViewController+Extension.swift
//  YE
//
//  Created by 侯佳男 on 2017/12/8.
//  Copyright © 2017年 侯佳男. All rights reserved.
//

/*
 *  交换方法viewWillAppear、viewDidDisappear方法
 *  获取storyboard的root vc
 *  push pop present相关犯法
 */

import UIKit

public extension UIViewController {
    func ga_storyboardRootVC(name: String) -> UIViewController? {
        if name.isEmpty {
            print("error ga_storyboardRootVC name字符串为空")
            return nil
        }
        guard let vc = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController() else {
            print("error ga_storyboardRootVC 没有viewcontroller")
            return nil
        }
        return vc
    }
}

// MARK: - Push Pop 方法
public extension UIViewController {
    /// PUSH
    func ga_push(vc: UIViewController, animated: Bool = true) {
        guard let nv = self.navigationController else {
            print("没有navigationController")
            return
        }
        nv.pushViewController(vc, animated: animated)
    }
    /// PUSH XIB 只能展示VC view
    func ga_pushXIB(nibName: String, animated: Bool = true) {
        guard let nv = self.navigationController else {
            print("没有navigationController")
            return
        }
        let vc = UIViewController(nibName: nibName, bundle: nil)
        nv.pushViewController(vc, animated: animated)
    }
    
    /// POP
    func ga_pop(animated: Bool = true) {
        guard let nv = self.navigationController else {
            print("没有navigationController")
            return
        }
        nv.popViewController(animated: animated)
    }
    /// POPTO
    func ga_popTo(vc: UIViewController, animted: Bool = true) {
        guard let nv = self.navigationController else {
            print("没有navigationController")
            return
        }
        for item in nv.viewControllers {
            if item == vc {
                nv.popToViewController(vc, animated: true)
                return
            }
        }
        print("没有目标UIViewController")
    }
    /// POPROOT
    func ga_popRoot(animated: Bool = true) {
        guard let nv = self.navigationController else {
            print("没有navigationController")
            return
        }
        nv.popToRootViewController(animated: true);
        
    }
    /// PRESENT
    func ga_present(animated: Bool = true) {
        present(self, animated: animated, completion: nil)
    }
    // storyboar PUSH
    func ga_push(storyboardName name: String, animated: Bool = true) {
        if name.isEmpty {
            print("name字符串为空")
            return
        }
        guard let vc = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController() else {
            print("没有viewcontroller")
            return
        }
        ga_push(vc: vc, animated: animated)
    }
    // storyboar PUSH
    func ga_push(storyboardName name: String, vcIdentifier identifier: String, animated: Bool = true) {
        if name.isEmpty || identifier.isEmpty {
            print("字符串有空")
            return
        }
        let vc = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier)
        ga_push(vc: vc, animated: animated)
    }
    
}

public extension UIViewController {
    
    func ga_resentVC(vc: UIViewController) -> UIViewController? {
        guard let p = vc.presentedViewController else {
            return self
        }
        return ga_resentVC(vc: p)
    }
    
}

public extension UIViewController {
    func ga_storyboardVC<T: UIViewController>(type: T.Type, storyboardName: String) -> T {
        let vc = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: String(describing: type)) as! T
        return vc
    }
}

// plist View controller-based status bar appearance   YES
public extension UIAlertController {
     override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
     override var shouldAutorotate: Bool {
        return false
    }
}
