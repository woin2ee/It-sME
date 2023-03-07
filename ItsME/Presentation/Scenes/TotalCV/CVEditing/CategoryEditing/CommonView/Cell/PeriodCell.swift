//
//  PeriodCell.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/03.
//

import UIKit
import Then
import SnapKit

class PeriodCell: UITableViewCell {
    
    // MARK: - UI Components
    
    lazy var periodLabel: UILabel = .init().then {
        $0.text = "기간"
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 15, weight: .regular)
    }
    
    lazy var periodTextField: UITextField = .init().then {
        $0.text = "눌러보세요"
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 20, weight: .regular)
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

private extension PeriodCell {
    
    func configureSubviews() {
        
        let cellSizeInset = 15
        let cellOffset = 10
        let contentsOffset = 5
        
        self.addSubview(periodLabel)
        periodLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(cellOffset)
            make.top.bottom.equalToSuperview().inset(cellSizeInset)
        }
        
        self.addSubview(periodTextField)
        periodTextField.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-cellOffset)
            make.top.bottom.equalToSuperview().inset(cellSizeInset)
            make.leading.equalTo(periodLabel.snp.trailing).offset(contentsOffset)
        }
    }
}
