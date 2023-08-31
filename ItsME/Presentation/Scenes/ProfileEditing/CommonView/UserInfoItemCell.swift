//
//  UserInfoItemCell.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/17.
//

import SnapKit
import Then
import UIKit

final class UserInfoItemCell: UITableViewCell {

    private lazy var iconLabel: UILabel = .init().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .center
    }

    private lazy var contentsLabel: UILabel = .init().then {
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .secondarySystemGroupedBackground
        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(userInfoItem: UserBasicProfileInfo) {
        iconLabel.text = userInfoItem.icon.toEmoji
        contentsLabel.text = userInfoItem.contents
    }
}

// MARK: - Private Functions

private extension UserInfoItemCell {

    func configureSubviews() {
        let commonInsetValue = 4

        self.contentView.addSubview(iconLabel)
        iconLabel.snp.makeConstraints { make in
            make.height.width.equalTo(35)
            make.top.greaterThanOrEqualToSuperview().inset(commonInsetValue)
            make.bottom.lessThanOrEqualToSuperview().inset(commonInsetValue)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(commonInsetValue)
        }

        self.contentView.addSubview(contentsLabel)
        contentsLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(commonInsetValue)
            make.leading.equalTo(iconLabel.snp.trailing).offset(10)
        }
    }
}
