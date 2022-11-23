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
    
    init(userInfoItem: UserInfoItem) {
        self.userInfoItem = userInfoItem
        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var icon: UIImageView = {
        let icon: UIImageView = .init(image: UIImage(systemName: userInfoItem.icon?.rawValue ?? ""))
        return icon
    }()
    
    
    private lazy var contents: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .black
        label.textAlignment = .left
        label.text = userInfoItem.contents
        label.numberOfLines = 2
        return label
    }()
    
    override func layoutSubviews() {
        self.addArrangedSubview(icon)
        self.addArrangedSubview(contents)
        self.axis = .horizontal
        self.spacing = 10
        self.alignment = .center
        self.distribution = .fill
        
        icon.backgroundColor = .mainColor
        
        icon.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.9)
            make.width.equalTo(self.snp.height)
        }
        
        contents.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.9)
        }
        
    }
}

