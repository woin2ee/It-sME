//
//  ButtonCell.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/28.
//

import SnapKit
import UIKit

final class ButtonCell: UITableViewCell {

    // MARK: - UI Objects

    lazy var titleLabel: UILabel = {
        let label: UILabel = .init()
        label.setContentHuggingPriority(.init(rawValue: 249), for: .horizontal)
        return label
    }()

    lazy var trailingButton: UIButton = .init(configuration: .gray())

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = nil) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }

    convenience init(title: String) {
        self.init()
        titleLabel.text = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Functions

private extension ButtonCell {

    func configureSubviews() {
        let stackView: UIStackView = .init().then {
            $0.addArrangedSubview(titleLabel)
            $0.addArrangedSubview(trailingButton)
            $0.distribution = .fill
            $0.spacing = 10.0
            $0.axis = .horizontal
            $0.alignment = .center
        }

        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(10)
            make.directionalVerticalEdges.equalToSuperview().inset(5)
        }
    }
}
