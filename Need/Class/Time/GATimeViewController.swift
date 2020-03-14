//
//  GATimeViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/14.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit

class GATimeViewController: GARxSwiftNavViewController, GANavViewControllerProtocol {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTimeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nav_hideBackButton()
        b_showNavigationView(title: "时间")
        
    }

}


extension GATimeViewController {
   
}
