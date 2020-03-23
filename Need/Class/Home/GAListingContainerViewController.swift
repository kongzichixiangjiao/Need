//
//  GAListingContainerViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/22.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

enum GAListingSettingCellType: Int {
    case color = 0, repeatName = 1, delete = 2 
}

protocol GAListingContainerViewControllerDelegate: class {
    
}

class GAListingContainerViewController: GARxSwiftNavViewController {
    
    weak var delegate: GAListingContainerViewControllerDelegate?
    
    @IBOutlet weak var cellsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _request()
    }
    
    private func _initViews() {
        self.view.backgroundColor = UIColor.randomColor()
        
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
