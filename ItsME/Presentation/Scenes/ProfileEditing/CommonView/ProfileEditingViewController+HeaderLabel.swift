//
//  ProfileEditingViewController+HeaderLabel.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/17.
//

import UIKit

extension ProfileEditingViewController {

    final class HeaderLabel: UILabel {

        init(title: String) {
            super.init(frame: .zero)

            self.text = title
            self.font = .boldSystemFont(ofSize: 26)
            self.textColor = .systemBlue
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
