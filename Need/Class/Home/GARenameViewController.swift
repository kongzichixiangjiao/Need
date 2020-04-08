//
//  GARenameViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/29.
//  Copyright © 2020 houjianan. All rights reserved.
//  重命名 添加备注

import UIKit

class GARenameViewController: NeedNavViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    
    var listingModel: GAListingModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _request()
    }
    
    private func _initViews() {
        b_showNavigationView(title: "重命名")
        nameTextField.text = listingModel.name ?? ""
        noteTextField.text = listingModel.nameNote ?? ""
    }
    
    private func _request() {
        
    }
    
    override func b_clickedLeftButtonAction() {
        let newName = nameTextField.text
        let newNameNote = noteTextField.text
        GACoreData.saveDB(type: GAListingModel.self, value: listingModel.name ?? "", block: { (empty) in
            empty?.name = newName
            empty?.nameNote = newNameNote
        }) { [unowned self] result in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
