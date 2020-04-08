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
import MJRefresh
import RxDataSources

enum GAListingSettingCellType: Int {
    case iconName = 0, conver = 1, color = 2, voice = 3, password = 4, name = 5, delete = 6
}

class GAListingSettingViewController: NeedNavViewController, Refreshable, GAAlertProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var listingModel: GAListingModel!
    var refreshHeader: MJRefreshHeader!
    var vm: GAListingSettingViewModel = GAListingSettingViewModel()
    var out: GAListingSettingViewModel.Output!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _request()
        
        out = vm.transform(input: GAListingSettingViewModel.Input(planModel: self.listingModel))
        
        out.sections.drive(tableView.rx.items(dataSource: _getDataSorce())).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        refreshHeader = initRefreshHeader(tableView, {
            [unowned self] in
            self.out.requestCommand.onNext(true)
        })
        
        out.autoSetRefreshHeaderStatus(header: refreshHeader, footer: nil).disposed(by: disposeBag)
        
        refreshHeader.beginRefreshing()
        
        tableView.rx.modelSelected([String : Any].self).subscribe(onNext: { [unowned self] model in
            let identifier = model["identifier"] as! Int
            switch identifier {
            case GAListingSettingCellType.iconName.rawValue:
                let vc = self.ga_storyboardVC(type: GASelectedIconViewController.self, storyboardName: ListingSetting.name)
                vc.listingModel = self.listingModel
                self.ga_push(vc: vc)
                break
            case GAListingSettingCellType.conver.rawValue:
                break
            case GAListingSettingCellType.color.rawValue:
                let vc = self.ga_storyboardVC(type: GASelectedColorsViewController.self, storyboardName: ListingSetting.name)
                vc.listingModel = self.listingModel
                self.ga_push(vc: vc)
                break
            case GAListingSettingCellType.voice.rawValue:
                break
            case GAListingSettingCellType.password.rawValue:
                break
            case GAListingSettingCellType.name.rawValue:
                let vc = self.ga_storyboardVC(type: GARenameViewController.self, storyboardName: ListingSetting.name)
                vc.listingModel = self.listingModel
                self.ga_push(vc: vc)
                break
            default:
                break 
            }
        }).disposed(by: disposeBag)
        
        deleteButton.rx.tap.asDriver().drive(onNext: { [unowned self] in
            self.alertNormal_show(title: "确定删除吗？", message: "如果删除这条清单，内部的计划一并被清除") {
                [unowned self] b in
                if b {
                    GACoreData.ga_delete_listingModel(listingId: self.listingModel.listingId ?? "") {
                        
                    }
                }
            }
            }).disposed(by: disposeBag)
    }
    
    private func _getDataSorce() -> RxTableViewSectionedReloadDataSource<GAListingSettingSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<GAListingSettingSection>(configureCell: {
            s, tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: GAPlanAddBasicCell.identifier, for: indexPath) as! GAPlanAddBasicCell
            if GAListingSettingCellType(rawValue: indexPath.row) == .color {
                cell.iconImageView.iconColor = (self.listingModel.color ?? "").color0X
            } else {
                cell.iconImageView.iconColor = Need.iconColor
            }
            cell.iconImageView.iconName = model["icon"] as! String
            cell.titleLabel.text = model["title"] as? String
            cell.vipImageView.isHidden = !(model["isVip"] as! Bool)
            return cell
        })
        return dataSource
    }
    
    private func _initViews() {
        tableView.ga_register(nibName: GAPlanAddBasicCell.identifier)
    }
    
    private func _request() {
        
    }
}

extension GAListingSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: ViewModel
import RxSwift
import RxDataSources
import RxCocoa

class GAListingSettingViewModel: GAViewModel {
    private let vmDatas = Variable<[([[String : Any]])]>([])
}

extension GAListingSettingViewModel: GAViewModelType {
    typealias Input = GAListingSettingInput
    
    typealias Output = GAListingSettingOutput
    
    
    struct GAListingSettingInput {
        var planModel: GAListingModel!
        
        init(planModel: GAListingModel) {
            self.planModel = planModel
        }
    }
    
    struct GAListingSettingOutput: OutputRefreshProtocol {
        var sections: Driver<[GAListingSettingSection]>
        var refreshStatus: Variable<GARefreshStatus>
        let requestCommand = PublishSubject<Bool>()
        
        init(sections: Driver<[GAListingSettingSection]>) {
            self.sections = sections
            refreshStatus = Variable(GARefreshStatus.none)
        }
    }
    
    func transform(input: GAListingSettingViewModel.GAListingSettingInput) -> GAListingSettingViewModel.GAListingSettingOutput {
        let sections = vmDatas.asObservable().map { (sections) -> [GAListingSettingSection] in
            sections.map { (models) -> GAListingSettingSection in
                return GAListingSettingSection(items: models)
            }
        }.asDriver(onErrorJustReturn: [])
        
        let out = GAListingSettingOutput(sections: sections)
        out.requestCommand.subscribe(onNext: { [weak self]
            isPull in
            guard let weakSelf = self else {
                return
            }
            guard let path = Bundle.main.path(forResource: "listingSetting", ofType: "plist") else {
                #if DEBUG
                print("fileName 错误")
                #endif
                return
            }
            
            let result = NSArray.init(contentsOf: URL(fileURLWithPath: path)) as! [[String : Any]]
            weakSelf.vmDatas.value = [(result)]
            
            out.refreshStatus.value = .endHeaderRefresh
        }).disposed(by: disposeBag)
        return out
    }
}


struct GAListingSettingSection {
    var items: [Item]
}

extension GAListingSettingSection: SectionModelType {
    
    typealias Item = [String : Any]
    
    init(original: GAListingSettingSection, items: [[String : Any]]) {
        self = original
        self.items = items
    }
}
