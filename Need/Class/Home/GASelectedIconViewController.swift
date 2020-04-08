//
//  GASelectedIconViewController.swift
//  Need
//
//  Created by houjianan on 2020/4/7.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit

class GASelectedBaseViewController: NeedNavViewController {
    var listingModel: GAListingModel!
}

class GASelectedIconViewController: GASelectedBaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource = ["shouj", "ye", "jt", "yd", "cf", "gw", "jc", "sj", "zh", "gz", "ny", "hy", "cs", "ds"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _request()
    }
    
    private func _initViews() {
        b_showNavigationView(title: "图标")
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0 
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func _request() {
        
    }
}

extension GASelectedIconViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GASelectedIconCell.identifier, for: indexPath) as! GASelectedIconCell
        cell.iconImageView.image = UIImage(named: "need_time_icon_" + dataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.width / 5, height: self.view.width / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        GACoreData.saveDB(type: GAListingModel.self, key: "listingId", value: self.listingModel.listingId ?? "", block: { (empty) in
            empty?.iconName = "need_time_icon_" + self.dataSource[indexPath.row] 
        }) { (result) in
            GAShowWindow.ga_show(message: DefaultText.Toast.success)
        }
    }
}

class GASelectedIconCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    
}
