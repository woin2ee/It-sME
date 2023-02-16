//
//  CVLettersCell.swift
//  ItsME
//
//  Created by MacBook Air on 2023/02/15.
//

import SnapKit
import Then
import UIKit

class CVLettersCell: UITableViewCell {
    
    //MARK: - UI Component
    lazy var content = UILabel().then {
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

private extension CVLettersCell {
    
    func configureSubviews() {
        self.contentView.addSubview(content)
        content.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
    }
    
}
