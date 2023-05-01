//
//  ProfileInfoComponent.swift
//  ItsME
//
//  Created by MacBook Air on 2022/11/17.
//

import Foundation
import UIKit
import SnapKit

final class ProfileInfoComponent: UIStackView {
    
    /**
     `ProfileInfoComponent` 가 현재 보여주고 있는 `UserInfoItem` 객체입니다.
     
     Component 의 내용을 변경하고 싶다면 이 프로퍼티에 새 객체를 할당하십시오.
     */
    var userInfoItem: UserInfoItem {
        didSet {
            icon.text = userInfoItem.icon.toEmoji
            contents.text = userInfoItem.contents
        }
    }
    
    // MARK: - UI Components
    
    private lazy var icon: UILabel = {
        let label = UILabel()
        label.text = userInfoItem.icon.toEmoji
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var contents: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .label
        label.textAlignment = .left
        label.text = userInfoItem.contents
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK: - Initialization
    
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
            make.height.width.equalTo(35)
        }
        
        contents.snp.makeConstraints { make in
            make.height.equalToSuperview()
        }
    }
}
