//
//  MovableEducationCell.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/05/03.
//

import SnapKit
import Then
import UIKit

final class MovableEducationCell: EducationCell {
    
    // MARK: - UI Components
    
    lazy var line3ImageView: UIImageView = .init().then {
        let colorConfig: UIImage.SymbolConfiguration = .init(hierarchicalColor: .systemGray2)
        $0.image = .init(systemSymbol: .line3Horizontal, withConfiguration: colorConfig)
    }
    
    // MARK: Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    override func addSubviews() {
        self.addSubview(line3ImageView)
        super.addSubviews()
    }
    
    override func setupConstraints() {
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
        }
        line3ImageView.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(24)
            make.leading.equalTo(titleLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
    }
}
