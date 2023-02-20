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
    
    private lazy var iconInputCell: IconInputCell = .init(
        style: .default,
        reuseIdentifier: IconInputCell.reuseIdentifier,
        viewModel: .init(icon: .default)
    )
    private lazy var contentsInputCell: ContentsInputCell = .init(
        style: .default,
        reuseIdentifier: ContentsInputCell.reuseIdentifier
    )
    
    var inputCells: [UITableViewCell] {
        [
            iconInputCell,
            contentsInputCell,
        ]
    }
    
    var currentUserInfoItem: UserInfoItem {
        .init(
            icon: iconInputCell.viewModel.currentIcon,
            contents: contentsInputCell.contentsTextField.text ?? ""
        )
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
        iconInputCell.viewModel.updateIcon(userInfoItem.icon)
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
