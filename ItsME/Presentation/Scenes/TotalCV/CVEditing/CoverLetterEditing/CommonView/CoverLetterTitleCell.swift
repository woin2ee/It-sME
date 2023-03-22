//
//  CoverLetterItemCell.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/09.
//

import UIKit
import SnapKit
import Then

class CoverLetterTitleCell: UITableViewCell {
    
    // MARK: - UI Components
    
    lazy var titleTextField = UITextField().then {
        $0.placeholder = "항목"
        $0.textColor = .systemBlue
        $0.isUserInteractionEnabled = true
        $0.allowsEditingTextAttributes = true
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
        
        self.contentView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(contentInset)
        }
    }
}
