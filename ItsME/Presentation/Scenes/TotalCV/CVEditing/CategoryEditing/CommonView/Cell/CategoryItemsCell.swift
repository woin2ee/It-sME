//
//  CategoryItemsCell.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/03.
//

import UIKit
import Then
import SnapKit

class CategoryItemsCell: UITableViewCell {
    
    // MARK: - UI Components
    lazy var contentsTextField: UITextField = .init().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.autocorrectionType = .no
        $0.clearButtonMode = .whileEditing
        $0.autocapitalizationType = .none
        $0.isUserInteractionEnabled = true
        $0.allowsEditingTextAttributes = true
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
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

// MARK: - Private Functions

private extension CategoryItemsCell {
    
    func configureSubviews() {
        
        let cellSizeInset = 15
        
        self.contentView.isUserInteractionEnabled = true
        
        self.contentView.addSubview(contentsTextField)
        contentsTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(cellSizeInset)
            make.top.bottom.equalToSuperview().inset(cellSizeInset)
        }
    }
}
