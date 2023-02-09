//
//  CategoryTitle.swift
//  ItsME
//
//  Created by MacBook Air on 2023/02/08.
//

import SnapKit
import Then
import UIKit

class CategoryTitle: UITableViewHeaderFooterView {
    
    static let reuseIdentifier: String = .init(describing: CategoryTitle.self)
    
    //MARK: - UI Component
    
    lazy var titleLabel = UILabel().then {
        $0.text = "제목"
        $0.numberOfLines = 0
        $0.textColor = .systemBlue
        $0.font = .systemFont(ofSize: 30, weight: .bold)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fatalError("awakeFromNib() has not been implemented")
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(resumeCategory: ResumeCategory) {
        titleLabel.text = resumeCategory.title
    }
}

// MARK: - Private Functions
private extension CategoryTitle {
    
    func configureSubviews() {
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(40)
        }
    }
}

