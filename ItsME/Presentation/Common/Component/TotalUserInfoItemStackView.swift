//
//  TotalUserInfoItemStackView.swift
//  ItsME
//
//  Created by Jaewon Yun on 2022/12/08.
//

import UIKit

final class TotalUserInfoItemStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.isUserInteractionEnabled = false
        self.axis = .vertical
        self.spacing = 4
        self.alignment = .fill
        self.distribution = .fillEqually
        
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
