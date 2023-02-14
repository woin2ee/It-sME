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
    
    lazy var inputCells: [UITableViewCell] = [
        IconInputCell.init(style: .default, reuseIdentifier: IconInputCell.reuseIdentifier),
        ContentsInputCell.init(style: .default, reuseIdentifier: ContentsInputCell.reuseIdentifier),
    ]
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.register(IconInputCell.self, forCellReuseIdentifier: IconInputCell.reuseIdentifier)
        self.register(ContentsInputCell.self, forCellReuseIdentifier: ContentsInputCell.reuseIdentifier)
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
