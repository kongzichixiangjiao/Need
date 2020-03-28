//
//  GAHomeViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/14.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import TYPagerController
import Then
import SnapKit
import RxDataSources
import MJRefresh
import RxSwift
import RxCocoa
import GAAlertPresentation

class GAHomeViewController: GARxSwiftNavViewController, GANavViewControllerProtocol, Refreshable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var refreshHeader: MJRefreshHeader!
    var vm: GAHomeViewModel!
    var out: GAHomeViewModel.HomeOutput!
    
    private var _isAdd: Bool = false
    private var _newAddName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _request()
        
        vm = GAHomeViewModel()
        out = vm.transform(input: GAHomeViewModel.HomeInput())
        out.sections.drive(collectionView.rx.items(dataSource: _getDataSorce())).disposed(by: disposeBag)
        
        refreshHeader = initRefreshHeader(collectionView, {
            [unowned self] in
            self.out.requestCommand.onNext(true)
        })
        
        out.autoSetRefreshHeaderStatus(header: refreshHeader, footer: nil).disposed(by: disposeBag)
        
        refreshHeader.beginRefreshing()
        
        collectionView.rx.modelSelected(GAListingModel.self).subscribe(onNext: {
            [unowned self] model in
            let vc = self.ga_storyboardVC(type: GAListingDetailsViewController.self, storyboardName: HomeStoryboard.name)
            vc.listingModel = model
            self.ga_push(vc: vc)
        }).disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func _getDataSorce() -> RxCollectionViewSectionedReloadDataSource<GAPlanSection> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<GAPlanSection>(configureCell: { (dataSource, collectionView, indexPath, model) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GAHomeCell.identifier, for: indexPath) as! GAHomeCell
            cell.nameLabel.text = model.name
            return cell
        }, configureSupplementaryView: {
            [unowned self] dataSource, collectionView, kinds, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kinds, withReuseIdentifier: GAHomeHeader.identifier, for: indexPath) as! GAHomeHeader
            header.textField.text = ""
            header.delegate = self
            return header
        })
        return dataSource
    }
    
    private func _initViews() {
        nav_hideBackButton()
        b_showNavigationView(title: "Need")
        _initNavigationButtons()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.collectionViewLayout = layout
    }
    
    private func _initNavigationButtons() {
        let imgName = Other.kNavImgName_add
        b_showNavigationLeftButton(title: "取消", imgName: "") { [unowned self] title in
            self._isAdd = false
            self.collectionView.reloadData()

            self.b_navigationView.nav_updateNavigationRightButton(imgName: imgName)
            self.b_navigationView.leftButton.isHidden = true
        }
        self.b_navigationView.leftButton.isHidden = true
        
        b_showNavigationRightButton(title: "", imgName: imgName) {
            [unowned self] title in
            let bTitle = "完成"
            if title == bTitle {
                self.b_navigationView.nav_updateNavigationRightButton(imgName: imgName)
                self.b_navigationView.leftButton.isHidden = true
                self._save()
            } else {
                self.b_navigationView.leftButton.isHidden = false
                self.b_navigationView.nav_updateNavigationRightButton(title: bTitle)
                self.collectionView.reloadData()
            }
            self._isAdd = title != bTitle
        }
    }
    
    private func _save() {
        let name = _newAddName
        GACoreData.saveDB(type: GAListingModel.self, name: name, block: { (empty) in
            empty?.name = name
        }) { (result) in
            self.refreshHeader.beginRefreshing()
        }
    }
    
    private func _request() {
        
    }
    
}

extension GAHomeViewController: GAHomeHeaderDelegate {
    func normalizeTextFieldDidChange(text: String) {
        _newAddName = text
    }
}

extension GAHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return _isAdd ? CGSize(width: kScreenWidth, height: 150) : CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenWidth - 40, height: 60)
    }
}

class GAHomeCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var planCountsLabel: UILabel!
}

protocol GAHomeHeaderDelegate: class {
    func normalizeTextFieldDidChange(text: String)
}

class GAHomeHeader: UICollectionReusableView, GANormalizeTextFieldDelegate{
    
    weak var delegate: GAHomeHeaderDelegate?
    
    @IBOutlet weak var textField: GANormalizeTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.mDelegate = self
    }
    
    func normalizeTextFieldDidChange(textField: GANormalizeTextField) {
        delegate?.normalizeTextFieldDidChange(text: textField.text ?? "")
    }
}
