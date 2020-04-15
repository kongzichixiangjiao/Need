//
//  GATimeLineViewController.swift
//  Need
//
//  Created by houjianan on 2020/4/8.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import MJRefresh

class GATimeLineViewController: NeedNavViewController, Refreshable, GANavViewControllerProtocol {

    @IBOutlet weak var tableView: UITableView!
    var refreshHeader: MJRefreshHeader!
    
    var vm = GATimeLineViewModel()
    var out: GATimeLineViewModel.Output!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _request()
        
        out = vm.transform(input: GATimeLineViewModel.GATimeLineInput())
        out.sections.asDriver().drive(tableView.rx.items(dataSource: _getDataSorce())).disposed(by: disposeBag)
        
        refreshHeader = initRefreshHeader(tableView, {
            [unowned self] in
            self.out.requestCommand.onNext(true)
        })
        
        out.autoSetRefreshHeaderStatus(header: refreshHeader, footer: nil).disposed(by: disposeBag)
        refreshHeader.beginRefreshing()
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(GATimeLineModel.self).subscribe(onNext: {
            [unowned self] model in
            let vc = self.ga_storyboardVC(type: GATimeLineAddViewController.self, storyboardName: Time.name)
            vc.timeLineModel = model
            vc.isAdd = false
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func _getDataSorce() -> RxTableViewSectionedReloadDataSource<GATimeLineSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<GATimeLineSection>(configureCell: {
            s, tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: GATimeLineCell.identifier, for: indexPath) as! GATimeLineCell
            if let startDate = model.startDate {
                cell.sDateLabel.text = startDate.dateString(formate: .h_m)
            }
            if let endDate = model.endDate {
                cell.eDateLabel.text = endDate.dateString(formate: .h_m)
            }
            cell.nameLabel.text = model.name 
            cell.describeLabel.text = model.describe
            let nature = model.nature ?? DefaultText.nature
            cell.levelLabel.text = nature
            cell.levelLabel.textColor = Need.natureButtonColor(title: nature)
            return cell
        })
        return dataSource
    }
    
    private func _initViews() {
        nav_hideBackButton()
        b_showNavigationView(title: "时间轴")
        b_showNavigationRightButton(title: "新增") { (title) in
            let vc = self.ga_storyboardVC(type: GATimeLineAddViewController.self, storyboardName: Time.name)
            self.ga_push(vc: vc)
        }
    }
    
    private func _request() {
        
    }
    
}

extension GATimeLineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}


import RxSwift
import RxDataSources
import RxCocoa

class GATimeLineViewModel: GAViewModel {
    private let vmDatas = Variable<[([GATimeLineModel])]>([])
}

extension GATimeLineViewModel: GAViewModelType {
    typealias Input = GATimeLineInput
    
    typealias Output = GATimeLineOutput
    
    
    struct GATimeLineInput {
        
    }
    
    struct GATimeLineOutput: OutputRefreshProtocol {
        var sections: Driver<[GATimeLineSection]>
        var refreshStatus: Variable<GARefreshStatus>
        let requestCommand = PublishSubject<Bool>()
        
        init(sections: Driver<[GATimeLineSection]>) {
            self.sections = sections
            refreshStatus = Variable(GARefreshStatus.none)
        }
    }
    
    func transform(input: GATimeLineViewModel.GATimeLineInput) -> GATimeLineViewModel.GATimeLineOutput {
        let sections = vmDatas.asObservable().map { (sections) -> [GATimeLineSection] in
            sections.map { (models) -> GATimeLineSection in
                return GATimeLineSection(items: models)
            }
        }.asDriver(onErrorJustReturn: [])
        
        let out = GATimeLineOutput(sections: sections)
        out.requestCommand.subscribe(onNext: { [weak self]
            isPull in
            guard let weakSelf = self else {
                return
            }
            
            let result = GACoreData.findAllSorted(type: GATimeLineModel.self)
            weakSelf.vmDatas.value = [(result)]

            out.refreshStatus.value = .endHeaderRefresh
        }).disposed(by: disposeBag)
        return out
    }
}


struct GATimeLineSection {
    var items: [Item]
}

extension GATimeLineSection: SectionModelType {
    
    typealias Item = GATimeLineModel
    
    init(original: GATimeLineSection, items: [GATimeLineModel]) {
        self = original
        self.items = items
    }
}

class GATimeLineCell: NeedCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sDateLabel: UILabel!
    @IBOutlet weak var eDateLabel: UILabel!
    @IBOutlet weak var describeLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
}
