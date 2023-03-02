//
//  TextFieldCell.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/28.
//

import SnapKit
import UIKit

class TextFieldCell: UITableViewCell {
    
    lazy var textField: InsetTextField = .init(inset: .all(10))
    
    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier: String? = nil) {
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
        self.contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
