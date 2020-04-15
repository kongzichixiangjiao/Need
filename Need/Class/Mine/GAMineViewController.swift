//
//  GAMineViewController.swift
//  Need
//
//  Created by houjianan on 2020/4/9.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift

struct GAMineSection {
    var items: [Item]
    var title = ""
}

extension GAMineSection: SectionModelType {
    typealias Item = [String : Any]
    
    init(original: GAMineSection, items: [Item]) {
        self = original
        self.items = items
    }
    
    init(original: GAMineSection, title: String, items: [Item]) {
        self = original
        self.title = title
        self.items = items
    }
}

class GAMineViewController: NeedNavViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let sections = [GAMineSection(items: [["title":"时间轴标题", "vc":"GATimeLineTitleViewController"]], title: "时间")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _request()
        
        let dataObservable = Observable<[GAMineSection]>.just(sections)
        dataObservable.bind(to: self.tableView.rx.items(dataSource: _getDataSorce())).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(GAMineSection.Item.self).subscribe(onNext: { (model) in
            let vc = self.ga_storyboardVC(identifier: model["vc"] as? String ?? "", storyboardName: Setting.name)
            self.ga_push(vc: vc)
        }).disposed(by: disposeBag)
    }
    
    private func _getDataSorce() -> RxTableViewSectionedReloadDataSource<GAMineSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<GAMineSection>(configureCell: {
            s, tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: GAMineCell.identifier, for: indexPath) as! GAMineCell
            cell.nameLabel.text = model["title"] as? String
            return cell
        }, titleForHeaderInSection: { (data, section) -> String in
            return "123"
        })
        
        return dataSource
    }
    
    private func _initViews() {
        b_showNavigationView(title: "俺的")
    }
    
    private func _request() {
        
    }
    
}

extension GAMineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = sections[section].title
        let v = GAMineSectionView.ga_xibView()
        v.sectionTitleLabel.text = title
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0 
    }
    
}

class GAMineCell: NeedCell {
    @IBOutlet weak var nameLabel: UILabel!
}

public extension UIViewController {
    func ga_storyboardVC(identifier: String, storyboardName: String) -> UIViewController {
        let vc = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier)
        return vc
    }
}
