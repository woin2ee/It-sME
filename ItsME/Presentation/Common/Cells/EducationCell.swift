//
//  EducationCell.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/16.
//

import SnapKit
import Then
import UIKit

final class EducationCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private lazy var periodLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "Period"
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    private lazy var titleLabel: UILabel = .init().then {
        $0.text = "Title"
        $0.textColor = .label
    }
    
    private lazy var descriptionLabel: UILabel = .init().then {
        $0.text = "Description"
        $0.textColor = .secondaryLabel
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fatalError("awakeFromNib() has not been implemented")
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
        
        // Configure the view for the selected state
    }
    
    func bind(educationItem: EducationItem) {
        periodLabel.text = educationItem.period
        titleLabel.text = educationItem.title
        descriptionLabel.text = educationItem.description
    }
}

// MARK: - Private Functions

private extension EducationCell {
    
    func configureSubviews() {
        
        self.contentView.addSubview(periodLabel)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
        
        let verticalInsetValue = 5
        let horizontalInsetValue = 15
        
        periodLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(verticalInsetValue)
            make.leading.equalToSuperview().inset(horizontalInsetValue)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(descriptionLabel)
            make.top.equalToSuperview().inset(verticalInsetValue)
            make.trailing.equalToSuperview().inset(horizontalInsetValue)
            make.bottom.equalTo(descriptionLabel.snp.top)
            make.leading.equalTo(periodLabel.snp.trailing).offset(14)
            make.width.equalTo(periodLabel).multipliedBy(2.3)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(verticalInsetValue)
            make.trailing.equalToSuperview().inset(horizontalInsetValue)
        }
    }
}
