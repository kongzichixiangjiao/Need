//
//  GAPlanAddViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/22.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import MJRefresh
import CoreData
import SwiftDate

enum GAPlanAddCellType: Int {
    case date = 3, `repeat` = 7, listtingTitle = 2, add = 9, note = 1, title = 0, people = 10, alertTime = 11, alertDate = 12, alertWeek = 13
}

enum GARepeatStringType: String {
    case `default` = "指定时间", minute = "每分", hour = "每时", day = "每天", week = "每周", month = "每月", year = "每年"
}

enum GAPlanAddFromType: Int {
    case normal = 0, listing = 1
}

class GAPlanAddViewController: NeedNavViewController, GAPickerViewProtocol, Refreshable, GAAlertProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var fromType: GAPlanAddFromType = .normal
    
    var listingModel: GAListingModel!
    var refreshHeader: MJRefreshHeader!
    var vm: GAPlanAddViewModel!
    var out: GAPlanAddViewModel.Output!
    var dataSource: RxTableViewSectionedReloadDataSource<GAPlanAddSection>!
    var planModel: GAPlanItemModel = GAPlanItemModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _request()
        
        vm = GAPlanAddViewModel()
        out = vm.transform(input: GAPlanAddViewModel.GAPlanAddInput(fromType: fromType, planModel: planModel, listingModel: listingModel))
        
        dataSource = _getDataSorce()
        
        out.sections.drive(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        self.out.requestCommand.onNext(true)
        
        tableView.rx.itemSelected.subscribe(onNext: {
            [unowned self] indexPath in
            var model = self._model(indexPath)
            switch model.identifier {
            case GAPlanAddCellType.date.rawValue:
                self.pickerDateView_show {
                    [unowned self] date in
                    let dateString = date.toString(.custom(GADateFormatType.y_m_d.rawValue))
                    self._editedReload(model: &model, restult: dateString, indexPath: indexPath)
                    self.planModel.date = dateString
                }
                break
            case GAPlanAddCellType.repeat.rawValue:
                self.pickerNormalView_show(dataSource: [(model.dataSource)]) { [unowned self] result in
                    let repeatString = (result.first ?? "")
                    self._editedReload(model: &model, restult: repeatString, indexPath: indexPath)
                    self.planModel.repeatString = repeatString
                    
                    self.vm.reloadAlertTime(dataSource: self.dataSource[0], repeatType: GARepeatStringType(rawValue: repeatString) ?? .default)
                    self.tableView.reloadData()
                }
                break
            case GAPlanAddCellType.listtingTitle.rawValue:
                let dataSource = GACoreData.ga_find_planModel_names()
                self.pickerNormalView_show(dataSource: [dataSource]) { [unowned self] result in
                    let listingName = (result.first ?? "")
                    self._editedReload(model: &model, restult: listingName, indexPath: indexPath)
                    self.planModel.listingName = listingName
                }
                break
            // MARK: 添加
            case GAPlanAddCellType.add.rawValue:
                self.planModel.listingId = self.listingModel.listingId ?? ""
                if self.fromType == .normal {
                    GALocalPushManager.share.remove(requesIDs: [self.planModel.planId])
                }
                GACoreData.ga_save_planModel(model: self.planModel, isAdd: self.fromType == .normal) { planModel in
                    DispatchQueue.main.async {
                        if self.fromType == .normal {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
                break
            case GAPlanAddCellType.people.rawValue:
                self.pickerNormalView_show(dataSource: [model.dataSource], isMultipleChoice: true, resultData: model.people) { [unowned self] result in
                    self.planModel.people = result
                    model.people = result
                    model.isEdited = true
                    self.tableView.reloadRows(at: [indexPath], with: .left)
                }
                break
            case GAPlanAddCellType.alertDate.rawValue:
                self.b_endEdit()
                self.pickerDateView_show(dateModel: .date) { (date) in
                    let alertDateString = date.dateString(formate: .y_m_d)
                    self.planModel.alertDateString = alertDateString
                    self.planModel.alertDate = date
                    self._editedReload(model: &model, restult: alertDateString, indexPath: indexPath)
                }
                break
            case GAPlanAddCellType.alertWeek.rawValue:
                self.b_endEdit()
                break
            case GAPlanAddCellType.alertTime.rawValue:
                self.b_endEdit()
                self.pickerDateView_show(dateModel: .time) { (date) in
                    let alertTimeString = date.dateString(formate: .h_m)
                    self.planModel.alertTimeString = alertTimeString
                    self.planModel.alertTime = date
                    self._editedReload(model: &model, restult: alertTimeString, indexPath: indexPath)
                }
                break
                
            default:
                if !model.isClicked {
                    
                }
                if model.isVip {
                    GAShowWindow.ga_show(message: "你还不是会员！")
                }
                break
            }
        }).disposed(by: disposeBag)
    }
    
    private func _getDataSorce() -> RxTableViewSectionedReloadDataSource<GAPlanAddSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<GAPlanAddSection>(configureCell: {
            [unowned self] s, tableView, indexPath, model in
            switch model.cellType {
            case GAPlanAddTitleCell.identifier:
                let cell = tableView.ga_dequeueReusableCell(cellClass: GAPlanAddTitleCell.self)
                cell.publishModel.subscribe(onNext: {
                    text in
                    model.editText = text
                    model.isEdited = !text.isEmpty
                    self.planModel.name = text
                }).disposed(by: self.disposeBag)
                cell.textField.text = model.isEdited ? model.editText : ""
                cell.iconButton.setImage(UIImage(named: model.icon), for: .normal)
                cell.iconButton.rx.tap.asDriver().drive(onNext: { [unowned self] in
                    GACoreData.ga_save_planModel(model: self.planModel, isFinished: !self.planModel.isFinished) { [unowned self] models in
                        self.planModel.isFinished = !self.planModel.isFinished
                        self._model(indexPath).icon = self.planModel.isFinished ? Other.kNotiFinished : self.planModel.iconName
                        self.tableView.reloadItemsAtIndexPaths([indexPath], animationStyle: .bottom)
                    }
                }).disposed(by: self.disposeBag)
                return cell
            case GAPlanAddNoteCell.identifier:
                let cell = tableView.ga_dequeueReusableCell(cellClass: GAPlanAddNoteCell.self)
                cell.model = model
                let indexPath = IndexPath(item: 0, section: indexPath.section)
                let model = self._model(indexPath)
                cell.publishModel.subscribe(onNext: {
                    [unowned self] obj in
                    model.icon = obj.selectedIcon
                    self.planModel.iconName = obj.selectedIcon
                    self.tableView.reloadItemsAtIndexPaths([indexPath], animationStyle: UITableViewRowAnimation.bottom)
                }).disposed(by: self.disposeBag)
                cell.publishNoteString.subscribe(onNext: {
                    [unowned self] text in
                    model.isEdited = true
                    model.editText = text 
                    self.planModel.note = text
                }).disposed(by: self.disposeBag)
                return cell
            case GAPlanAddBasicCell.identifier:
                let cell = tableView.ga_dequeueReusableCell(cellClass: GAPlanAddBasicCell.self)
                cell.model = model
                return cell
            case GASelectedDataCell.identifier:
                let cell = tableView.ga_dequeueReusableCell(cellClass: GASelectedDataCell.self)
                cell.delegate = self
                cell.selectedData = model.weeks
                cell.dataSource = model.dataSource
                return cell
            default:
                return NeedCell()
            }
        })
        return dataSource
    }
    
    private func _editedReload(model: inout GAPlanAddModel, restult: String, indexPath: IndexPath) {
        model.editText = restult
        model.isEdited = true
        self.tableView.reloadRows(at: [indexPath], with: .left)
    }
    
    private func _initViews() {
        if fromType == .listing {
            b_showNavigationView(title: planModel.name)
            if planModel.isFinished {
                b_showNavigationRightButton(imgName: Other.kNavImgName_refresh) { [unowned self] _ in
                    GACoreData.ga_save_planModel(model: self.planModel, isFinished: false) { [unowned self] _ in
                        self.planModel.isFinished = false
                        self.refreshHeader.beginRefreshing()
                        self.b_navigationView.isShowRightButton = false 
                    }
                }
            }
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: deleteButton.height * 2, right: 0)
        }
        deleteButton.isHidden = fromType == .normal
        
        tableView.ga_register(nibNames: [GAPlanAddTitleCell.identifier, GAPlanAddNoteCell.identifier,
                                         GAPlanAddBasicCell.identifier, GASelectedDataCell.identifier])
    }
    
    private func _request() {
        
    }
    
    private func _model(_ indexPath: IndexPath) -> GAPlanAddModel {
        let section = dataSource[indexPath.section]
        let model = section.items[indexPath.row]
        return model
    }
    
    // MARK: 删除
    @IBAction func deleteAction(_ sender: Any) {
        alertNormal_show(title: "删除操作", message: "删除将不会再找回") { [unowned self] b in
            if b {
                GACoreData.ga_delete_planModel(planId: self.planModel.planId) {
                    [unowned self] in
                    GALocalPushManager.share.remove(requesIDs: [self.planModel.planId])
                    self.ga_pop()
                }
            }
        }
    }
    
    deinit {
        
    }
}

extension GAPlanAddViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = _model(indexPath)
        return model.isShow ? (model.height.ga_toCGFloat() ?? 0) : 0
    }
}
extension GAPlanAddViewController: GASelectedDataCellDelegate {
    func selectedDataCell_didSelected(data: [String]) {
        let section = dataSource[0]
        for item in section.items {
            if item.identifier == GAPlanAddCellType.alertWeek.rawValue {
                self.planModel.weeks = data 
            }
        }
    }
}


// MARK: ViewModel
import RxSwift
import RxDataSources
import RxCocoa

class GAPlanAddViewModel: GAViewModel {
    private let vmDatas = Variable<[([GAPlanAddModel])]>([])
}

extension GAPlanAddViewModel: GAViewModelType {
    typealias Input = GAPlanAddInput
    
    typealias Output = GAPlanAddOutput
    
    struct GAPlanAddInput {
        var fromType: GAPlanAddFromType!
        var planModel: GAPlanItemModel!
        var listingModel: GAListingModel!
        
        init(fromType: GAPlanAddFromType, planModel: GAPlanItemModel, listingModel: GAListingModel) {
            self.fromType = fromType
            self.planModel = planModel
            self.listingModel = listingModel
        }
    }
    
    struct GAPlanAddOutput: OutputRefreshProtocol {
        var sections: Driver<[GAPlanAddSection]>
        var refreshStatus: Variable<GARefreshStatus>
        let requestCommand = PublishSubject<Bool>()
        
        init(sections: Driver<[GAPlanAddSection]>) {
            self.sections = sections
            refreshStatus = Variable(GARefreshStatus.none)
        }
    }
    
    func transform(input: GAPlanAddViewModel.GAPlanAddInput) -> GAPlanAddViewModel.GAPlanAddOutput {
        let sections = vmDatas.asObservable().map { (sections) -> [GAPlanAddSection] in
            sections.map { (models) -> GAPlanAddSection in
                return GAPlanAddSection(items: models)
            }
        }.asDriver(onErrorJustReturn: [])
        
        input.planModel.listingName = input.listingModel.name ?? ""
        
        let out = GAPlanAddOutput(sections: sections)
        out.requestCommand.subscribe(onNext: { [weak self]
            isPull in
            guard let weakSelf = self else {
                return
            }
            guard let path = Bundle.main.path(forResource: "planAdd", ofType: "plist") else {
                #if DEBUG
                print("fileName 错误")
                #endif
                return
            }
            
            let arr = NSArray.init(contentsOf: URL(fileURLWithPath: path)) as! [[String : Any]]
            
            let result = [GAPlanAddModel].init(JSONArray: arr)
            if input.fromType == .listing {
                for i in 0..<result.count {
                    let model = result[i]
                    switch model.identifier {
                    case GAPlanAddCellType.title.rawValue:
                        result[i].editText = input.planModel.name
                        result[i].icon = input.planModel.isFinished ? Other.kNotiFinished : input.planModel.iconName
                        result[i].isEdited = true
                        break
                    case GAPlanAddCellType.date.rawValue:
                        result[i].editText = input.planModel.date
                        result[i].isEdited = true
                        break
                    case GAPlanAddCellType.repeat.rawValue:
                        result[i].editText = input.planModel.repeatString
                        result[i].isEdited = true
                        break
                    case GAPlanAddCellType.note.rawValue:
                        result[i].editText = input.planModel.note
                        result[i].isEdited = true
                        break
                    case GAPlanAddCellType.listtingTitle.rawValue:
                        result[i].editText = input.planModel.listingName
                        result[i].isEdited = true
                        break
                    case GAPlanAddCellType.add.rawValue:
                        result[i].title = "保存"
                        break
                    case GAPlanAddCellType.people.rawValue:
                        result[i].people = input.planModel.people
                        result[i].isEdited = true
                        break
                    case GAPlanAddCellType.alertDate.rawValue:
                        result[i].editText = input.planModel.alertDateString ?? ""
                        result[i].isEdited = true
                    case GAPlanAddCellType.alertTime.rawValue:
                        result[i].editText = input.planModel.alertTimeString ?? ""
                        result[i].isEdited = true
                    case GAPlanAddCellType.alertWeek.rawValue:
                        result[i].weeks = input.planModel.weeks
                        result[i].isEdited = true
                    default:
                        break
                    }
                }
                let section = GAPlanAddSection(items: result)
                weakSelf.reloadAlertTime(dataSource: section, repeatType: GARepeatStringType(rawValue: input.planModel.repeatString) ?? .default)
            }
            weakSelf.vmDatas.value = [(result)]
            
            out.refreshStatus.value = .endHeaderRefresh
        }).disposed(by: disposeBag)
        return out
    }
    // MARK: 选择重复类型 更新cell显示
    func reloadAlertTime(dataSource: GAPlanAddSection, repeatType: GARepeatStringType) {
        for item in dataSource.items {
            let isDate = item.identifier == GAPlanAddCellType.alertDate.rawValue
            let isTime = item.identifier == GAPlanAddCellType.alertTime.rawValue
            let isWeek = item.identifier == GAPlanAddCellType.alertWeek.rawValue
            if isDate || isTime || isWeek {
                switch repeatType {
                case .default:
                    item.isShow = isDate || isTime
                case .minute:
                    item.isShow = false
                case .day:
                    item.isShow = isWeek || isTime
                case .hour, .week, .month, .year:
                    break
                }
            }
        }
    }
    
}


struct GAPlanAddSection {
    var items: [Item]
}

extension GAPlanAddSection: SectionModelType {
    
    typealias Item = GAPlanAddModel
    
    init(original: GAPlanAddSection, items: [GAPlanAddModel]) {
        self = original
        self.items = items
    }
}

// MARK: Model
import ObjectMapper

class GAPlanAddModel: Mappable {
    required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        icon <- map["icon"]
        title <- map["title"]
        cellType <- map["cellType"]
        isEdited <- map["isEdited"]
        editText <- map["editText"]
        height <- map["height"]
        buttonIcons <- map["buttonIcons"]
        people <- map["people"]
        selectedIcon <- map["selectedIcon"]
        identifier <- map["identifier"]
        dataSource <- map["dataSource"]
        isClicked <- map["isClicked"]
        isVip <- map["isVip"]
        isShow <- map["isShow"]
        weeks <- map["weeks"]
        alertDate <- map["alertDate"]
        alertTime <- map["alertTime"]
        
    }
    
    var icon: String = ""
    var title: String = ""
    var cellType: String = ""
    var isEdited: Bool = false
    var editText: String = ""
    var height: String = "0"
    var buttonIcons: [String] = []
    var people: [String] = []
    var selectedIcon: String = ""
    var identifier: Int = -1
    var dataSource: [String] = []
    var isClicked: Bool = false
    var isVip: Bool = false
    var isShow: Bool = true
    var weeks: [String] = []
    var alertDate: String = ""
    var alertTime: String = ""
}
