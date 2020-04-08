//
//  GASelectedDataCell.swift
//  Need
//
//  Created by houjianan on 2020/4/3.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit

protocol GASelectedDataCellDelegate: class {
    func selectedDataCell_didSelected(data: [String])
}

class GASelectedDataCell: UITableViewCell {

    weak var delegate: GASelectedDataCellDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: [String] = ["1", "2", "3", "4", "5", "6", "7"]
    var selectedData: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.ga_register(nibName: GASelectedBasicCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension GASelectedDataCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GASelectedBasicCell.identifier, for: indexPath) as! GASelectedBasicCell
        let item = dataSource[indexPath.row]
        cell.contentView.backgroundColor = selectedData.contains(item) ? "999999".color0X : "fafafa".color0X
        cell.l.text = item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: self.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        if selectedData.contains(item) {
            guard let index = selectedData.firstIndex(of: item) else { return }
            selectedData.remove(at: index)
        } else {
            selectedData.append(item)
        }
        collectionView.reloadData()
        delegate?.selectedDataCell_didSelected(data: selectedData)
    }
}

extension Array {

    func ga_filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}
