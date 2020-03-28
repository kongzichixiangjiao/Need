//
//  GAListingSettingViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/23.
//  Copyright © 2020 houjianan. All rights reserved.
//  首页-清单-设置

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

enum GAListingSettingCellType: Int {
    case color = 0, repeatName = 1, delete = 2
}

protocol GAListingSettingViewControllerDelegate: class {
    
}

class GAListingSettingViewController: GARxSwiftNavViewController {
    
    weak var delegate: GAListingSettingViewControllerDelegate?
    
    @IBOutlet weak var cellsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _request()
    }
    
    private func _initViews() {
        for view in cellsStackView.arrangedSubviews {
            let cell = view as! GAListingSettingCell
            let type = GAListingSettingCellType(rawValue: cell.tag)
            
            cell.didClick = {
                [unowned self] in
                switch type {
                case .color:
                    break
                case .repeatName:
                    break
                case .delete:
                    break
                case .none:
                    break
                }
            }
        }
    }
    
    private func _request() {
        
    }
}
