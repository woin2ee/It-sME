//
//  ProfileInfoComponent.swift
//  ItsME
//
//  Created by MacBook Air on 2022/11/17.
//

import Foundation
import UIKit
import SnapKit

class ProfileInfoComponent: UIStackView {
    var userInfoItem: UserInfoItem
    
    private lazy var icon: UILabel = {
        let label = UILabel()
        label.text = userInfoItem.icon.toEmoji
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var contents: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black
        label.textAlignment = .left
        label.text = userInfoItem.contents
        label.numberOfLines = 2
        return label
    }()
    
    init(userInfoItem: UserInfoItem) {
        self.userInfoItem = userInfoItem
        super.init(frame: .zero)
        
        self.axis = .horizontal
        self.spacing = 10
        self.alignment = .center
        self.distribution = .fill
        
        configureSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        self.addArrangedSubview(icon)
        self.addArrangedSubview(contents)
        
        icon.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.9)
            make.width.equalTo(self.snp.height)
        }
        
        contents.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.9)
        }
    }
}
