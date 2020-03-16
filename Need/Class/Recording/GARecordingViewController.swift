//
//  GARecordingViewController.swift
//  Need
//
//  Created by houjianan on 2020/3/14.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import MJRefresh

class GARecordingViewController: GARecordingBaseViewController, Refreshable {
    
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
            let vc = self.ga_storyboardVC(type: GAAudioDetailsViewController.self, name: "Recording")
            vc.model = model
            vc.publishModel?.subscribe(onNext: { (model) in
                print(model)
            }).disposed(by: self.disposeBag)
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func _getDataSorce() -> RxTableViewSectionedReloadDataSource<GARecordingSection> {
        let dataSource = RxTableViewSectionedReloadDataSource<GARecordingSection>(configureCell: {
            s, tableView, indexPath, model in
            let cell = tableView.dequeueReusableCell(withIdentifier: GARecordingCell.identifier, for: indexPath) as! GARecordingCell
            cell.nameLabel.text = model.name
            cell.dateLabel.text = model.dateString
            return cell
        })
        return dataSource
    }
    
    private func _initViews() {
        b_showNavigationView(title: "录音列表")
    }
    
    private func _request() {
        
    }
}

extension GARecordingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

class GARecordingCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
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
