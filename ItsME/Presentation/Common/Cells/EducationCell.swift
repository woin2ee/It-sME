//
//  EducationCell.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/16.
//

import SFSafeSymbols
import SnapKit
import Then
import UIKit

class EducationCell: UITableViewCell {

    // MARK: - UI Components

    lazy var periodLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "Period"
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()

    lazy var titleLabel: UILabel = .init().then {
        $0.text = "Title"
        $0.textColor = .label
    }

    lazy var descriptionLabel: UILabel = .init().then {
        $0.text = "Description"
        $0.textColor = .secondaryLabel
    }

    // MARK: Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }

    func addSubviews() {
        self.contentView.addSubview(periodLabel)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
    }

    func setupConstraints() {
        let verticalInsetValue = 5
        let horizontalInsetValue = 15

        periodLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(verticalInsetValue)
            make.leading.equalToSuperview().inset(horizontalInsetValue)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(descriptionLabel)
            make.top.equalToSuperview().inset(verticalInsetValue)
            make.bottom.equalTo(descriptionLabel.snp.top)
            make.leading.equalTo(periodLabel.snp.trailing).offset(14)
            make.width.equalTo(periodLabel).multipliedBy(2.3)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(verticalInsetValue)
            make.trailing.equalToSuperview().inset(horizontalInsetValue)
        }
    }

    func bind(educationItem: Education) {
        periodLabel.text = educationItem.period
        titleLabel.text = educationItem.title
        descriptionLabel.text = educationItem.description
    }
}
