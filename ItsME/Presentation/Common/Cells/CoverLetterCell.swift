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
    
    //MARK: - UI Component
    lazy var contents = UILabel().then {
        $0.text = "내용"
        $0.numberOfLines = 0
        $0.textColor = .label
        $0.font = .boldSystemFont(ofSize: 15)
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
    
}

// MARK: - Private Functions

private extension CoverLetterCell {
    
    func configureSubviews() {
        
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        self.contentView.addSubview(contents)
        contents.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.bottom.top.equalToSuperview().inset(10)
        }
    }
    
}
