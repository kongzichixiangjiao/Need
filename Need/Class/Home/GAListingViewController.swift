//
//  GAListingViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/22.
//  Copyright © 2020 houjianan. All rights reserved.
//  首页-清单

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import TYPagerController
import RxDataSources
import MJRefresh

class GAListingViewController: GARxSwiftNavViewController, Refreshable {
    
    @IBOutlet weak var tableView: UITableView!
    
    var listingModel: GAListingModel!
    var vm: GAListingViewModel = GAListingViewModel()
    var out: GAListingViewModel.ListingOutput!
    var refreshHeader: MJRefreshHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        out = vm.transform(input: GAListingViewModel.ListingInput())
        out.sections.drive(tableView.rx.items(dataSource: _getDataSorce())).disposed(by: disposeBag)
        refreshHeader = initRefreshHeader(tableView, {
            [unowned self] in
            self.out.requestCommand.onNext((true, self.listingModel.name ?? ""))
        })
        
        out.autoSetRefreshHeaderStatus(header: refreshHeader, footer: nil).disposed(by: disposeBag)
        refreshHeader.beginRefreshing()
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(GAPlanModel.self).subscribe(onNext: {
            [unowned self] model in
            let vc = self.ga_storyboardVC(type: GAPlanAddViewController.self, storyboardName: HomeStoryboard.name)
            vc.listingModel = self.listingModel
            vc.fromType = .listing 
            vc.planModel = GAPlanItemModel.getItem(planModel: model)
            self.ga_push(vc: vc)
        }).disposed(by: disposeBag)
        
        _initViews()
        _request()
        
    }
    
    private func _getDataSorce() -> RxTableViewSectionedReloadDataSource<GAListingSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<GAListingSection>(configureCell: {
            [unowned self] s, tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: GAListingCell.identifier, for: indexPath) as! GAListingCell
            let imgName = model.isFinished ? Other.kNotiFinished : model.iconName
            cell.iconButton.setImage(UIImage(named: imgName ?? ""), for: .normal)
            cell.nameLabel.text = model.name ?? ""
            cell.noteLabel.text = model.note ?? ""
            cell.iconAction.subscribe { (b) in
                GACoreData.ga_save_planModel(name: model.name ?? "", isFinished: !model.isFinished) { [unowned self] models in
                    GAShowWindow.ga_show(message: "操作完成")
                    self.refreshHeader.beginRefreshing()
                }
            }.disposed(by: self.disposeBag)
            return cell
        })
        return dataSource
    }
    
    private func _initViews() {
        
    }
    
    private func _request() {
        
    }
    
}

extension GAListingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

class GAListingCell: UITableViewCell {
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    let iconAction = PublishSubject<Bool>()
    
    @IBAction func iconAction(_ sender: UIButton) {
        iconAction.onNext(true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

import RxSwift
import RxDataSources
import RxCocoa

class GAListingViewModel: GAViewModel {
    private let vmDatas = Variable<[([GAPlanModel])]>([])
}

extension GAListingViewModel: GAViewModelType {
    typealias Input = ListingInput
    
    typealias Output = ListingOutput
    
    struct ListingInput {
        
    }
    
    struct ListingOutput: OutputRefreshProtocol {
        var sections: Driver<[GAListingSection]>
        var refreshStatus: Variable<GARefreshStatus>
        let requestCommand = PublishSubject<(Bool, String)>()
        
        init(sections: Driver<[GAListingSection]>) {
            self.sections = sections
            refreshStatus = Variable(GARefreshStatus.none)
        }
    }
    
    func transform(input: GAListingViewModel.ListingInput) -> GAListingViewModel.ListingOutput {
        let sections = vmDatas.asObservable().map { (sections) -> [GAListingSection] in
            sections.map { (models) -> GAListingSection in
                return GAListingSection(items: models)
            }
        }.asDriver(onErrorJustReturn: [])
        
        let out = ListingOutput(sections: sections)
        out.requestCommand.subscribe(onNext: { [unowned self] model in
            let result = GACoreData.ga_find_planModels(value: model.1)
            print(result)
            self.vmDatas.value = [result]
            out.refreshStatus.value = .endHeaderRefresh
        }).disposed(by: disposeBag)
        
        return out
    }
}


struct GAListingSection {
    var items: [Item]
}

extension GAListingSection: SectionModelType {
    
    typealias Item = GAPlanModel
    
    init(original: GAListingSection, items: [GAPlanModel]) {
        self = original
        self.items = items
    }
}
