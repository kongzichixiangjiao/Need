//
//  GATableScrollCell.swift
//  Need
//
//  Created by houjianan on 2020/3/17.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import SnapKit

protocol GATableScrollCellDelegate: class {
    func tableScrollCellClicked(row: Int, tag: Int)
}

class GATableScrollCell: UITableViewCell {
    
    weak var scrollDelegate: GATableScrollCellDelegate?
    
    private var rightButtonTotalWidth: CGFloat = 0
    var rightButtons: [UIButton] = []
    var row: Int = -1
    
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView(frame: self.bounds)
        v.backgroundColor = UIColor.clear
        v.translatesAutoresizingMaskIntoConstraints = false
        v.showsHorizontalScrollIndicator = true
        v.showsVerticalScrollIndicator = true
        v.isPagingEnabled = false
        v.delegate = self
        return v
    }()
    
    lazy var buttonsView: GATableScrollButtonView = {
        let v = GATableScrollButtonView()
        return v
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView.addSubview(self.contentView)
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let h = self.contentView.frame.size.height
        let w = self.contentView.frame.size.width
        
        
        scrollView.addSubview(buttonsView)
        rightButtonTotalWidth = buttonsView.add(cell: self, buttons: rightButtons) {
            [unowned self] tag in
            self.scrollDelegate?.tableScrollCellClicked(row: self.row, tag: tag)
        }
        buttonsView.frame = CGRect(x: w, y: 0, width: rightButtonTotalWidth, height: h)
        
        scrollView.contentSize = CGSize(width: w + rightButtonTotalWidth, height: h)
        scrollView.contentOffset = CGPoint.zero
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension GATableScrollCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        if x >= rightButtonTotalWidth {
            scrollView.contentOffset = CGPoint(x: rightButtonTotalWidth, y: 0)
            return
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.x > rightButtonTotalWidth / 2 {
            UIView.animate(withDuration: 0.25) {
                scrollView.contentOffset = CGPoint(x: self.rightButtonTotalWidth, y: 0)
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                scrollView.contentOffset = CGPoint.zero
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    }
}

class GATableScrollButtonView: UIView {
    typealias Handler = (_ tag: Int) -> ()
    var handler: Handler?
    
    func add(cell: GATableScrollCell, buttons: [UIButton], handler: @escaping Handler) -> CGFloat {
        for b in self.subviews {
            b.removeFromSuperview()
        }
        
        self.handler = handler
        let h = cell.contentView.frame.size.height
        let _ = cell.contentView.frame.size.width
        var totalHeight: CGFloat = 0.0
        
        for i in 0..<buttons.count {
            let b = buttons[i]
            let bW = b.frame.size.width
            totalHeight += bW
            b.frame = CGRect(x: CGFloat(i) * bW, y: 0, width: bW, height: h)
            b.addTarget(self, action: #selector(rightButtonsTouchUpInside(sender:)), for: UIControl.Event.touchUpInside)
            self.addSubview(b)
        }
        return totalHeight
    }
    
    @objc func rightButtonsTouchUpInside(sender: UIButton) {
        self.handler?(sender.tag)
    }
    
}
