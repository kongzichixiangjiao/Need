//
//  GARecordingViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/14.
//  Copyright © 2020 houjianan. All rights reserved.
//  语音录制的列表

import Foundation
import RxSwift
import RxDataSources
import MJRefresh
import SCLAlertView

class GARecordingListViewController: GARxSwiftNavViewController, Refreshable {
    
    @IBOutlet weak var tableView: UITableView!
    var refreshHeader: MJRefreshHeader!
    
    var vm: GARecordingViewModel!
    var out: GARecordingViewModel.Output!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        _request()
        
        vm = GARecordingViewModel()
        out = vm.transform(input: GARecordingViewModel.GARecordingInput())
        out.sections.drive(tableView.rx.items(dataSource: _getDataSorce())).disposed(by: disposeBag)
        
        refreshHeader = initRefreshHeader(tableView, {
            self.out.requestCommand.onNext(true)
        })
        
        out.autoSetRefreshHeaderStatus(header: refreshHeader, footer: nil).disposed(by: disposeBag)
        refreshHeader.beginRefreshing()
        
        tableView.rx.modelSelected(GARecordingModel.self).subscribe(onNext: {
            [unowned self] model in
            let vc = self.ga_storyboardVC(type: GAAudioDetailsViewController.self, storyboardName: RecordingStoryboard.name)
            vc.model = model
            vc.publishModel?.subscribe(onNext: { (model) in
                
            }).disposed(by: self.disposeBag)
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func _getDataSorce() -> RxTableViewSectionedReloadDataSource<GARecordingSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<GARecordingSection>(configureCell: {
            [weak self] s, tableView, indexPath, model in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: GARecordingCell.identifier, for: indexPath) as! GARecordingCell
            cell.nameLabel.text = model.name
            cell.dateLabel.text = model.dateString
            cell.totalLabel.text = String.ga_formate(time: Int(model.totalTime))
            if let weakSelf = self {
                cell.rightButtons = weakSelf.rightButtons()
                cell.scrollDelegate = self
                cell.row = indexPath.row
            }
            return cell
        })
        return dataSource
    }
    
    func rightButtons() -> [UIButton] {
        let v = UIButton()
        v.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        v.setTitle("删除", for: .normal)
        v.backgroundColor = UIColor.red
        return [v]
    }
    
    private func _initViews() {
        b_showNavigationView(title: "录音列表")
    }
    
    private func _request() {
        
    }
}

extension GARecordingListViewController: GATableScrollCellDelegate {
    func tableScrollCellClicked(row: Int, tag: Int) {
        let appearance = SCLAlertView.SCLAppearance(
            kWindowWidth: kScreenWidth - 40, showCloseButton: false, circleBackgroundColor: UIColor.white
        )
        
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("确定", backgroundColor: kMainButtonDefaultColor) {
            self.vm.delete(row: row, tag: tag)
        }
        alert.addButton("取消", backgroundColor: kMainButtonDefaultColor) {
            
        }
        alert.showInfo("删除", subTitle: "确定要删除这条数据吗？")
    }
}

extension GARecordingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

class GARecordingCell: GATableScrollCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
}


//override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    performSegue(withIdentifier: "ShowRecordViewController", sender: self)
//}
//
//// MARK: - Navigation
//override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "ShowRecordViewController" {
//        guard let type = HUDType(rawValue: selectedIndex) else {
//            return
//        }
//        let recordVC = segue.destination as! RecordViewController
//        recordVC.HUDType = type
//    }
//}
