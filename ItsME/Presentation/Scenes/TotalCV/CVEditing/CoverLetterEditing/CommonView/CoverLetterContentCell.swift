//
//  CoverLetterContentCell.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/21.
//

import UIKit
import SnapKit
import Then
import UITextView_Placeholder

class CoverLetterContentCell: UITableViewCell {
    
// MARK: - UI Components
    lazy var content: UITextView = .init().then {
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = true
        $0.allowsEditingTextAttributes = true
        $0.backgroundColor = .systemGray5
        $0.isScrollEnabled = true
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.keyboardType = .default
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
        
        self.contentView.addSubview(content)
        content.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(contentInset)
            make.height.equalTo(200)
        }
    }
}
