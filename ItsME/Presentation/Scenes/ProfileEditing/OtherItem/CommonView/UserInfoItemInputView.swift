//
//  UserInfoItemInputView.swift
//  ItsME
//
//  Created by Jaewon Yun on 2023/02/13.
//

import SnapKit
import Then
import UIKit

/// deprecated
final class UserInfoItemInputView: UIStackView {
    
    lazy var iconButton: UIButton = .init().then {
        $0.setTitle(UserInfoItemIcon.default.toEmoji, for: .normal)
        let action: UIAction = .init { _ in
            print("Touch")
        }
        $0.addAction(action, for: .touchUpInside)
    }
    
    lazy var contentsTextField: UITextField = .init().then {
        $0.font = .systemFont(ofSize: 16.0)
        $0.borderStyle = .roundedRect
        $0.placeholder = "http://example.com"
        $0.autocorrectionType = .no
        $0.keyboardType = .URL
        $0.autocapitalizationType = .none
        $0.clearButtonMode = .whileEditing
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.alignment = .center
        self.axis = .horizontal
        self.distribution = .fill
        self.spacing = 10.0
        
        configureSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        self.addArrangedSubview(iconButton)
        self.addArrangedSubview(contentsTextField)
        
        iconButton.snp.makeConstraints { make in
            make.width.height.equalTo(contentsTextField.snp.height)
        }
    }
}
