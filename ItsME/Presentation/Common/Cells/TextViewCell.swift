//
//  TextViewCell.swift
//  ItsME
//
//  Created by MacBook Air on 2023/03/13.
//

import UIKit
import SnapKit
import UITextView_Placeholder

class TextViewCell: UITableViewCell {
    
    let textViewPlaceholder: String? = "설명을 입력하세요."
    
    var textViewHeight = 100 {
        didSet {
            textView.snp.updateConstraints { make in
                make.height.equalTo(textViewHeight)
            }
            self.setNeedsLayout()
        }
    }
    
    //MARK: - UI Component
    lazy var textView: UITextView = .init()
    
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
            make.height.equalTo(textViewHeight)
        }
    }
}
