//
//  TextViewCell.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/13.
//

import UIKit
import SnapKit

class TextViewCell: UITableViewCell {

    lazy var textView: UITextView = .init()
    var textViewHeigt = 100
    
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
        self.contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
            make.height.equalTo(textViewHeigt)
        }
    }
}
