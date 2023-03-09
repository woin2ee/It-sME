//
//  CoverLetterItemCell.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/09.
//

import UIKit
import SnapKit
import Then

class CoverLetterItemCell: UITableViewCell {
    
    // MARK: - UI Components
    
    lazy var titleBackgroundView = UIView().then {
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    
    lazy var titleTexField = UITextField().then {
        $0.placeholder = "항목"
        $0.textColor = .systemBlue
        $0.isUserInteractionEnabled = true
        $0.allowsEditingTextAttributes = true
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }
    
    lazy var content: UITextView = .init().then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = true
        $0.allowsEditingTextAttributes = true
        $0.backgroundColor = .systemGray5
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fatalError("awakeFromNib() has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    private func configureSubviews() {
        
        let contentInset = 15
        let contentOffset = 10
        
        self.contentView.addSubview(titleBackgroundView)
        titleBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(contentOffset)
            make.leading.trailing.equalToSuperview().inset(contentInset)
        }
        
        self.titleBackgroundView.addSubview(titleTexField)
        titleTexField.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(contentInset)
        }
        
        self.contentView.addSubview(content)
        content.snp.makeConstraints { make in
            make.top.equalTo(titleBackgroundView.snp.bottom).offset(contentOffset)
            make.leading.trailing.equalToSuperview().inset(contentInset)
            make.bottom.equalToSuperview().offset(-contentOffset)
            make.height.equalTo(400)
        }
    }
}
