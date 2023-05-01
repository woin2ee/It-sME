//
//  CoverLetterCell.swift
//  ItsME
//
//  Created by MacBook Air on 2023/02/15.
//

import SnapKit
import Then
import UIKit

class CoverLetterCell: UITableViewCell {
    
    private let cellBottomPadding = 5
    
    //MARK: - UI Component
    
    lazy var titleLabel = UILabel().then {
        $0.text = "제목"
        $0.numberOfLines = 0
        $0.textColor = .systemBlue
        $0.font = .boldSystemFont(ofSize: 20)
    }
    lazy var contents = UILabel().then {
        $0.text = "내용"
        $0.numberOfLines = 0
        $0.textColor = .label
        $0.font = .boldSystemFont(ofSize: 15)
    }
    
    private var customBackgroundView: UIView = .init().then {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    private var coverView: UIView = .init().then {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
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
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func bind(coverLetterItem: CoverLetterItem) {
        titleLabel.text = coverLetterItem.title
        contents.text = coverLetterItem.contents
    }
    
}

// MARK: - Private Functions

private extension CoverLetterCell {
    
    func configureSubviews() {
        
        self.backgroundColor = .clear
        
        self.addSubview(customBackgroundView)
        customBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().offset(-cellBottomPadding)
        }
        
        self.contentView.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().offset(-cellBottomPadding)
        }
        
        self.coverView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().offset(10)
        }
        
        self.coverView.addSubview(contents)
        contents.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().offset(10)
            make.bottom.equalToSuperview()
        }
    }
    
}
