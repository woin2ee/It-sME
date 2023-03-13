//
//  YearMonthPickerCell.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/03/02.
//

import SnapKit
import UIKit

final class YearMonthPickerCell: UITableViewCell {
    
    lazy var yearMonthPickerView: YearMonthPickerView = .init()
    
    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = nil) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        self.contentView.addSubview(yearMonthPickerView)
        yearMonthPickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
