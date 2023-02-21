//
//  UserInfoItemCell.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/17.
//

import SnapKit
import UIKit

final class UserInfoItemCell: UITableViewCell {
    
    private lazy var profileInfoComponent: ProfileInfoComponent = .init(userInfoItem: .empty)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemBackground
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(userInfoItem: UserInfoItem) {
        profileInfoComponent.userInfoItem = userInfoItem
    }
}

// MARK: - Private Functions

private extension UserInfoItemCell {
    
    func configureSubviews() {
        self.contentView.addSubview(profileInfoComponent)
        profileInfoComponent.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
}
