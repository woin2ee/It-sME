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
    lazy var contentsTextField = UITextField().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.autocorrectionType = .no
        $0.clearButtonMode = .whileEditing
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

private extension CategoryItemsCell {
    
    func bind(resumeItem: ResumeItem) {
        
    }
    
    func configureSubviews() {
        
        let cellSizeInset = 15
        let cellOffset = 20
        
        self.addSubview(contentsTextField)
        contentsTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(cellOffset)
            make.top.bottom.equalToSuperview().inset(cellSizeInset)
        }
    }
}
