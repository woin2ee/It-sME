//
//  IconInputCell.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/14.
//

import SnapKit
import Then
import UIKit

final class IconInputCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = .init().then {
        $0.text = "아이콘"
    }
    
    lazy var iconLabel: UILabel = .init().then {
        $0.text = UserInfoItemIcon.default.toEmoji
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    private func configureSubviews() {
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(40).priority(999)
            make.width.equalTo(60)
        }
        
        self.contentView.addSubview(iconLabel)
        iconLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(20)
        }
    }
}
