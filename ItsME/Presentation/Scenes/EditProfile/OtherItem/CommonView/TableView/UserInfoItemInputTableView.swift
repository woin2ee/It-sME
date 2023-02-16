//
//  UserInfoItemInputTableView.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/14.
//

import SnapKit
import Then
import UIKit

final class UserInfoItemInputTableView: IntrinsicHeightTableView {
    
    lazy var iconInputCell: IconInputCell = .init(style: .default, reuseIdentifier: IconInputCell.reuseIdentifier)
    lazy var contentsInputCell: ContentsInputCell = .init(style: .default, reuseIdentifier: ContentsInputCell.reuseIdentifier)
    
    var inputCells: [UITableViewCell] {
        [
            iconInputCell,
            contentsInputCell,
        ]
    }
    
    var currentInputUserInfoItem: UserInfoItem {
        let emoji = iconInputCell.iconLabel.text ?? UserInfoItemIcon.default.toEmoji
        let icon: UserInfoItemIcon = .init(rawValue: emoji) ?? .default
        let contents = contentsInputCell.contentsTextField.text ?? ""
        return .init(icon: icon, contents: contents)
    }
    
    init(style: UITableView.Style) {
        super.init(frame: .zero, style: style)
        self.register(IconInputCell.self, forCellReuseIdentifier: IconInputCell.reuseIdentifier)
        self.register(ContentsInputCell.self, forCellReuseIdentifier: ContentsInputCell.reuseIdentifier)
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(userInfoItem: UserInfoItem) {
        iconInputCell.iconLabel.text = userInfoItem.icon.toEmoji
        contentsInputCell.contentsTextField.text = userInfoItem.contents
    }
}

// MARK: - UITableViewDataSource

extension UserInfoItemInputTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return inputCells[indexPath.row]
    }
}
