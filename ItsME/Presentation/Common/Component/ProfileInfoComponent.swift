//
//  ProfileInfoComponent.swift
//  ItsME
//
//  Created by MacBook Air on 2022/11/17.
//

import Foundation
import UIKit
import SnapKit
import Then

final class ProfileInfoComponent: UIStackView {
    
    /**
     `ProfileInfoComponent` 가 현재 보여주고 있는 `UserInfoItem` 객체입니다.
     
     Component 의 내용을 변경하고 싶다면 이 프로퍼티에 새 객체를 할당하십시오.
     */
    var userInfoItem: UserBasicProfileInfo {
        didSet {
            icon.text = userInfoItem.icon.toEmoji
            contentsLabel.text = userInfoItem.contents
        }
    }
    
    // MARK: - UI Components
    
    private lazy var icon: UILabel = .init().then {
        $0.text = userInfoItem.icon.toEmoji
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .center
    }
    
    private lazy var contentsPlaceholder: UITextField = .init().then {
        $0.placeholder = "기본 정보를 입력해주세요."
        $0.isEnabled = false
        $0.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        $0.textColor = .label
        $0.textAlignment = .left
    }
    
    private lazy var contentsLabel: UILabel = .init().then {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        $0.textColor = .label
        $0.textAlignment = .left
        $0.text = userInfoItem.contents
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    // MARK: - Initialization
    
    init(userInfoItem: UserBasicProfileInfo) {
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
        icon.snp.makeConstraints { make in
            make.height.width.equalTo(35)
        }
        
        if userInfoItem.contents == "" {
            self.addArrangedSubview(contentsPlaceholder)
            contentsPlaceholder.snp.makeConstraints { make in
                make.height.equalToSuperview()
            }
        } else {
            self.addArrangedSubview(contentsLabel)
            contentsLabel.snp.makeConstraints { make in
                make.height.equalToSuperview()
            }
        }
    }
}
