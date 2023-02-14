//
//  ContentsInputCell.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/14.
//

import SnapKit
import Then
import UIKit

final class ContentsInputCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = .init().then {
        $0.text = "URL"
    }
    
    private lazy var contentsTextField: UITextField = .init().then {
        $0.font = .systemFont(ofSize: 16.0)
        $0.placeholder = "http://example.com"
        $0.autocorrectionType = .no
        $0.keyboardType = .URL
        $0.autocapitalizationType = .none
        $0.clearButtonMode = .whileEditing
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    private func configureSubviews() {
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(40).priority(999)
            make.width.equalTo(60)
        }
        
        self.contentView.addSubview(contentsTextField)
        contentsTextField.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(20)
        }
    }
}
