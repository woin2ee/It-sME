//
//  EducationCell.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/16.
//

import SnapKit
import UIKit

final class EducationCell: UITableViewCell {

    static let reuseIdentifier: String = .init(describing: EducationCell.self)
    
    // MARK: - UI Components
    
    private lazy var periodLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "Period"
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "Title"
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "Description"
        return label
    }()
    
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
        super.setSelected(selected, animated: animated)

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
        self.addSubview(periodLabel)
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        
        periodLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.left.equalTo(periodLabel.snp.right).offset(12)
            make.bottom.equalTo(descriptionLabel.snp.top)
            make.width.equalTo(descriptionLabel.snp.width)
            make.width.equalTo(periodLabel.snp.width).multipliedBy(2.5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
        }
    }
}
