//
//  TotalUserInfoItemStackView.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/08.
//

import UIKit

/// 좀 더 적절한 이름으로 사용할 수 있게 함
typealias UserInfoItemStackView = TotalUserInfoItemStackView

final class TotalUserInfoItemStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.axis = .vertical
        self.spacing = 8
        self.alignment = .fill
        self.distribution = .equalSpacing
        
        
        bind(userInfoItems: [])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(userInfoItems: [UserInfoItem]) {
        self.removeAllArrangedSubviews()
        
        userInfoItems.forEach { userInfoItem in
            let component = ProfileInfoComponent.init(userInfoItem: userInfoItem)
            self.addArrangedSubview(component)
        }
    }
}
